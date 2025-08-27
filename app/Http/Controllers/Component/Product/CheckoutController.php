<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;


use App\Models\Product;
use App\Models\Carts as Carts;
use App\Models\Carts_Item as CartsItem;
use App\Models\Payment;
use App\Models\User  as User;
use App\Models\cart_waiting as CartWaiting;
use Carbon\Carbon;


use App\Http\Controllers\Component\Product\ProductController as C_Product;
use App\Http\Controllers\Component\Product\VarianController as C_Varian;
use App\Http\Controllers\Component\Pajak\PajakController as C_Pajak;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\URL;

class CheckoutController extends Controller
{
    protected C_Pajak $C_Pajak;
    protected float $persen_pajak;
    protected $time_hangus = 30;
    //

    public function __construct(){
        $this->C_Pajak = new C_Pajak();
        $this->persen_pajak = $this->C_Pajak->getDefaultPajak();
    }

    public function search($id_checkout = null, $search = null, $page = 1, $limit = 10) {
        $thresholdTime = Carbon::now()->subMinutes($this->time_hangus);

        $carts = Carts::query()
            ->whereNull('metode_pembayaran');

        if (!empty($id_checkout)) {
             $carts = $carts->where('id', $id_checkout);
        }

        if (!empty($search)) {
            $userIds = User::where('email', 'like', '%' . $search . '%')->pluck('id');
            if ($userIds->isEmpty()) return false;
            $carts = $carts->where(function ($query) use ($userIds) {
                $query->whereIn('user_id', $userIds);
            });
        }

        $carts = $carts->whereNot('created_at', '<', $thresholdTime);
        $data = $carts->orderBy('created_at', 'asc')->paginate($limit);

        $data->getCollection()->transform(function ($item) use ($id_checkout) {
            return !empty($id_checkout) ? $this->detailList($item) : $this->searchList($item);
        });
        return $data;
    }

    protected function detailList($item){
        $itemsProduct = [];
        foreach($item->items as $varian){
            $itemsProduct[] = [
                'product_id' => $varian->product_id, 
                'nama_product' => $varian->product->nama_product,
                'varian_id' => $varian->varian_id,
                'nama_varian' => $varian->varian->nama_varian,
                'qty' => $varian->qty,
                'harga_satuan' => $varian->price_at_that_time,
                'harga_total' => $varian->subtotal,
                'image' => URL::to('image/' . basename($varian->varian->images->image_name)),
            ];
        }
        return [
            'id_checkout' => $item->id,
            'nama_lengkap' => $item->user->profile->nama_lengkap,
            'email' => $item->user->email,
            'tipe_pemesanan' => $item->tipe_pemesanan,
            'created_at'=> $item->created_at->toIso8601String(),
            'notes' => $item->notes,
            'item_product' => $itemsProduct,
            
        ];
    }

    protected function searchList($item){
        return [
                'nama_lengkap' => $item->user->profile->nama_lengkap,
                'email' => $item->user->email,
                'id_checkout' => $item->id,
                'tipe_pemesanan' => $item->tipe_pemesanan,
        ];
    }
    
    
    public function checkOut(array $products,String $tipe_pemesanan , $notes = null){
        $total_harga = 0;
       
        if (!in_array($tipe_pemesanan, ['dine_in', 'take_away'])) {
            return false;
        }
        foreach($products as $product){
           if (empty($product['product_id']) || empty($product['id_varian']) || empty($product['qty'])) {
                return false;
            }
        }
        $user = Auth::user()->id;
        $cart = Carts::create([
            'user_id' => $user,
            'status_pemesanan' => "waiting",
            'total_before_tax' => 0,
            'tax_percent' => $this->persen_pajak,
            'tipe_pemesanan' => $tipe_pemesanan,
            'notes' => $notes,
        ]);

        foreach ($products as $product){
            $detail_product = Product::find($product['product_id']);
            $harga_tambahan = $detail_product->variants()->find($product['id_varian'])->harga;
            $harga_tambahan = (int) $detail_product->harga_product + $harga_tambahan;
            $subtotal = $product['qty'] *  $harga_tambahan;
            $items = CartsItem::create([
                'cart_id' => $cart->id,
                'product_id' => $product['product_id'],
                'varian_id' => $product['id_varian'],
                'price_at_that_time' => $harga_tambahan,
                'qty' => $product['qty'],
                'subtotal' => $subtotal,
            ]);
            $total_harga = $total_harga + $subtotal;
        }
        // update Carts
        $this->updateCarts($cart->id,total_harga_sebelum_pajak:$total_harga,pajak_pph:$this->persen_pajak);
        return $cart->id;
    }

    public function updateCarts($carts_id, $metode_pembayaran = null , $total_harga_sebelum_pajak = null, $pajak_pph = null,$nominal_pembayaran = null){
        $cats = Carts::find($carts_id);
        if(!empty($metode_pembayaran)){
            if( $cats->total_after_tax  >  $nominal_pembayaran) return false;
            $cats->update([
                'status_pemesanan' => "processing",
                'metode_pembayaran' => $metode_pembayaran,
            ]);
            $this->pembayaran($cats->id,$metode_pembayaran,$nominal_pembayaran);
            $product = new C_Product();
            $varian = new C_Varian();
            foreach($cats->items as $product_varian){
                $product->create_log($product_varian->product_id,$product_varian->varian_id,$cats->user_id,"out",stock:$product_varian->qty,notes:$cats->tipe_pemesanan);
                $varian->update($product_varian->varian_id,stock:$product_varian->qty,status_upload:"out");
            }
        }
        if(!empty($total_harga_sebelum_pajak)){
            $total_harga_setelah_pajak = $this->perhitungan_setelah_pajak($total_harga_sebelum_pajak,$pajak_pph);
            $cats->update([
                'total_before_tax' => $total_harga_sebelum_pajak,
                'total_after_tax' => $total_harga_setelah_pajak,
            ]);
        }
        return true;
    }


    protected function pembayaran($carts_id,$metode_pembayaran,$nominal_pembayaran){
        Payment::create([
                'cart_id' => $carts_id,
                'payment_method' => $metode_pembayaran,
                'status' => "paid",
                'amount' => $nominal_pembayaran,
                'paid_at' => Carbon::now(),
            ]);
        CartWaiting::create([
                'cart_id' => $carts_id,
                'status' => "dapur",
        ]);
    }

    protected function perhitungan_setelah_pajak($total_harga,$pajak){
       
       return $this->C_Pajak->hitung_total_harga_setelah_pajak($total_harga, $pajak);
    }

    public function konfirmasiPembayaran($id_checkout,$metode_pembayaran,$nominal_pembayaran){
        $carts = Carts::find($id_checkout);

        if($metode_pembayaran != "qris" && empty($nominal_pembayaran)){
            if($nominal_pembayaran < $carts->total_after_tax){
                return false;
            }
        }
        $this->updateCarts($id_checkout,$metode_pembayaran,nominal_pembayaran:$nominal_pembayaran);
        return true;
    }

    public function buktiPembayaran($id_checkout = null , $limit = 10){
        $carts =  Carts::query();
        if(!empty($id_checkout)){
            $carts->where('id','=',$id_checkout);
        }else{
            $user = Auth::user();
            $carts->where('user_id','=',$user->id);
            
        }

        $data = $carts->paginate($limit);
        $data->getCollection()->transform(function($item) use ($id_checkout){
            if(!empty($id_checkout)) return $this->detailStuck($item);
            return $this->listStuck($item);
        });
        return $data;
    }

    protected function listStuck($cart){
        foreach($cart->items as $varian){
            foreach ($varian->varian->images->get() as $image) {
                if ($image->is_primary) {
                    $firstPrimaryImage = $image;
                }
            }
        }
        return [
            'id_checkout' => $cart->id,
            'status_pemesanan' => ($cart->status_pemesanan == "waiting") ? "detail" : "tampilkan_struck",
            'image_path' => URL::to('image/' . basename($firstPrimaryImage->image_name)),
            'created_at'=> $cart->created_at->toIso8601String(),
            'jumlah_item' => $cart->items->count(),
        ];
    }

    protected function detailStuck($carts){
        $itemsProduct = [];
        foreach($carts->items as $varian){
            $itemsProduct[] = [
                'id_varian' => $varian->id,
                'nama_varian' => $varian->product->nama_product,
                'harga_tambahan' => $varian->price_at_that_time,
                'qty' => $varian->qty,
                'image_name' => $varian->varian->images->image_name,
                'image_path' => URL::to('image/' . basename($varian->varian->images->image_name)),
            ];
       }
       $data = [
            'nama_lengkap' => $carts->user->profile->nama_lengkap,
            'tipe_pemesanan' => $carts->tipe_pemesanan,
            'tipe_pembayaran' => $carts->metode_pembayaran,
            'created_at'=> $carts->created_at->toIso8601String(),
            'item_product' => $itemsProduct,
            'total_sebelum_pajak' => $carts->total_before_tax,
            'pajak' => $carts->tax_percent,
            'harga_potongan' => $carts->total_after_tax - $carts->total_before_tax,
            'total_keselurusan' => $carts->total_after_tax,
            'nominal_pembayaran' => ($carts->metode_pembayaran == null) ? "Belum melakukan Pembayaran" : $carts->payment->amount,
            'notes' => $carts->notes,
       ];
       return $data;
    }

    public function deleteItem(String $id , String $id_product , String $id_varian){
       $cart = Carts::with('items')->findOrFail($id);

        $item = $cart->items()
            ->where('product_id', '=',$id_product)
            ->where('varian_id', '=',$id_varian)
            ->first();

        if (!$item) {
            return false;
        }

        $item->delete();

        return true;
    }

    public function deleteCheckout(String $id,String $password){
       $carts = Carts::find($id) ;
       $user = Auth::user();
       if(!Hash::check($password,$user->password)){
         return false;
       }
       $carts->delete();
       return true;
    }
}
