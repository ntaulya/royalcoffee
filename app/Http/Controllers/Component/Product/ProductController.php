<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Auth;



use App\Models\Product;
use App\Models\Log_Product as L_Product;
use App\Models\Log_Kategori as L_Kategori;


use App\Http\Controllers\Component\Product\VarianController as C_Varian;
use App\Http\Controllers\Component\Product\CheckoutController as C_Checkout;
use App\Http\Controllers\Component\Product\CheckAntrianController as C_Antrian;
use Exception;

class ProductController extends Controller
{
    protected $status = "non_aktif";
    protected $stock = 0;

    public function search($kategori_id = 0, $id_product = null, $search = null, $page = 1, $limit = 10)
    {

        $product = Product::with(['variants.images', 'log_kategori.kategori']); // Menambahkan relasi untuk kategori
        if ($kategori_id != 0 && $kategori_id != 1){
            $product->whereHas('log_kategori', function ($query) use ($kategori_id) {
                $query->where('id_kategori', $kategori_id);
            });
        }
        if (!is_null($id_product)) {
            $product->where('id', $id_product);
        }
        if (!is_null($search)) {
            $product->where('nama_product', 'like', '%' . $search . '%');
        }
        $user = Auth::user();
        $isAdmin = $user && method_exists($user, 'hasAnyRole') && $user->hasAnyRole("admin");
        if ($isAdmin) {
            $product->whereIn('status_product', ['aktif', 'non_aktif'])->orderByRaw("FIELD(status_product, 'aktif', 'non_aktif')");
        }
        if(!$isAdmin){
            $product->where('status_product', 'aktif');
        }
        $product->orderByDesc('nama_product');
        $data = $product->paginate($limit);
        $data->getCollection()->transform(function ($item) use ($id_product,$isAdmin) {
            if (!is_null($id_product)) {
                if(!$isAdmin && $item['status_product'] == "aktif"){
                    return $this->searchDetail($item);
                }
                if($isAdmin){
                    return $this->searchDetail($item);
                }
            }else{
                return $this->searchList($item);
            }
        });
        return $data;
    }


    public function deleteProduct($id_product){
        $user = Auth::user();
        if(!$user->hasRole('admin')) return 403;
        $product = Product::find($id_product);
        if($product['status_product'] == "aktif") return 403;
        try{
            $C_varian = new C_Varian();
            foreach($product->variants()->get() as $varian){
               $C_varian->deleteImage($varian->id);
            }
            $product->delete();
        }catch(Exception $e){
            return 409;
        }
    }

    public function create($nama, $harga , $kategori_id,$des,array $varian_product , $user_id)
    {
        $product = Product::create([
            'nama_product' => $nama,
            "harga_product" => $harga,
            "description" => $des,
            "status_product" => $this->status,
            "stock" => $this->stock,
        ]);
        L_Kategori::create([
            "product_id" => $product->id,
            "id_kategori" => $kategori_id,
        ]);
        $C_varian = new C_Varian();
        foreach($varian_product as $varian){
            $C_varian->create($product->id,$varian['nama_varian'],$varian['harga_varian'],$varian['stock_varian'],$varian['image_varian'],$varian['is_primary'],$user_id) ;
        }
    }

    public function create_log($product_id, $varian_id,$user_id,$status_upload,$stock,$notes){
        L_Product::create([
            "variant_id" => $varian_id,
            "user_id" => $user_id,
            "status_upload" => $status_upload,
            "qty_change" => $stock,
            "note" => $notes,
        ]);
        $this->update($product_id,stock:$stock,status_barang_masuk:$status_upload,status:$status_upload);
    }


    public function update($product_id,$nama = null, $harga = null, $des = null,$kategori_id = null , $status = null, $stock = null , $status_barang_masuk = null){
        $product = Product::find($product_id);
        if(!is_null($nama) && $product->nama_product != $nama){
            $product->update([
                'nama_product' => $nama
            ]);
        }
        if(!is_null($harga) && $product->harga_product != $harga){
            $product->update([
                'harga_product' => $harga
            ]);
        }
        if(!is_null($des) && $product->description != $des){
            $product->update([
                'description' => $des
            ]);
        }
        if(!is_null($status) && $product->status_product != $status){
            if($status == "aktif" || $status == "non_aktif"){
                $product->update([
                    'status_product' => $status
                ]);
            }
        }
        if(!is_null($kategori_id) && $product->log_kategori->id){
            L_Kategori::find($product->log_kategori->id)->update([
                'id_kategori' => $kategori_id,
            ]);
        }
        if(!is_null($stock)){
            if($status_barang_masuk == "in"){
                $stock = $product->stock + $stock;
            }
            if($status_barang_masuk == "out"){
                $stock = $product->stock - $stock;
            }
            $product->update([
                'stock' => $stock
            ]);
        }
    }


    protected function searchDetail($item) {
        $variants = [];
        foreach ($item->variants as $variant) {
            $firstImage = $variant->images;
            $variants[] = [
                'id_varian' => $variant->id,
                'nama_varian' => $variant->nama_varian,
                'harga_tambahan' => $variant->harga,
                'stock' => $variant->stock,
                'image_path' => $firstImage
                ? URL::to('image/' . basename($firstImage->image_name))
                : null, // aman kalau tidak ada image
                'is_primary' => $firstImage? $firstImage->is_primary ? 1 : 0 : null,
            ];
        }

        return [
            'id' => $item->id,
            'nama_product' => $item->nama_product,
            'categori_id' => $item->log_kategori->first()->id_kategori,
            'harga_product' => $item->harga_product,
            'description' => $item->description,
            'status_product' => $item->status_product,
            'variants' => $variants,
        ];
    }
    protected function searchList($item) {
        $firstPrimaryImage = null;
        $harga_tambahan = 0;

        foreach ($item->variants as $variant) {
            if ($variant->harga > 0) {
                $harga_tambahan = $item->harga_product + $variant->harga;
            }

            $image = $variant->images;
            if ($image && isset($image->is_primary) && (int)$image->is_primary === 1) {
                if (!$firstPrimaryImage) {
                    $firstPrimaryImage = $image;
                }
            }
        }

        return [
            'id' => $item->id,
            'nama_product' => $item->nama_product,
            'harga_product' => ($harga_tambahan != 0)
                ? $item->harga_product . " ~ " . $harga_tambahan
                : (string) $item->harga_product,
            'status_product' => $item->status_product,
            'stock' => $item->stock,
            'image_path' => $firstPrimaryImage
                ? URL::to('image/' . basename($firstPrimaryImage->image_name))
                : null, // aman kalau tidak ada image
        ];
    }

}
