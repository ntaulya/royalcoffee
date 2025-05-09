<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;


use App\Models\Product;
use App\Models\Log_Product as L_Product;
use App\Models\Log_Kategori as L_Kategori;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Auth;

class ProductController extends Controller
{
    protected $status = "non_aktif";
    protected $stock = 0;

    public function search($kategori_id = 1 , $id_product = null , $search = null , $page = 1 , $limit = 10){
        $product = Product::with(['variants.images']);

        if(Auth::check()){
            $user = Auth::user();
            if(!$user->hasAnyRole("admin")){
                $product->orderByRaw("CASE 
                                    WHEN status_product = 'aktif' THEN 0
                                    WHEN status_product = 'tidak_aktif' THEN 1
                                  END")
                    ->orderByDesc('updated_at'); 
            }
        }else{
            $product->where('status_product', '!=', 'tidak_aktif')->orderByDesc('updated_at');
        }



        //  Admin
        $data = $product->paginate($limit);

        if ($id_product == null){
            $data->getCollection()->transform(function ($item) {
                $firstPrimaryImage = null;
                $harga_tambahan = 0;
                foreach ($item->variants as $variant) {
                    if($variant->harga > 0){
                        $harga_tambahan = $item->harga_product + $variant->harga;
                    }
                    foreach ($variant->images as $image) {
                        if ($image->is_primary) {
                            $firstPrimaryImage = $image;
                            break;
                        }
                    }
                }
            
                return [
                    'id' => $item->id,
                    'nama_product' => $item->nama_product,
                    'harga_product' => ($harga_tambahan != 0) ? $item->harga_product ." ~ " .$harga_tambahan : (string) $item->harga_product,
                    'status_product' => $item->status_product,
                    'image_path' => URL::to('image/' . basename($firstPrimaryImage?->image_name)),
                ];
            });
        }else{
            
        }
        
        return $data;
    }


    public function create(
        $nama, 
        $harga , 
        $kategori_id,
        $des , 
        )
        {
        
        $product = Product::create([
            'nama_product' => $nama,
            "harga_product" => $harga,
            "Description" => $des,
            "status_product" => $this->status,
            "stock" => $this->stock,
        ]);
        L_Kategori::create([
            "product_id" => $product->id,
            "id_kategori" => $kategori_id,
        ]);
        return $product;
    }

    public function create_log($varian_id,$user_id,$status_upload,$stock,$notes){
        L_Product::create([
            "variant_id" => $varian_id,
            "user_id" => $user_id,
            "status_upload" => "in",
            "qty_change" => $stock,
            "note" => $notes,
        ]);

    }

}
