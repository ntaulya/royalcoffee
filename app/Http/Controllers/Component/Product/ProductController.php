<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\Product;
use App\Models\Log_Product as L_Product;
use App\Models\Log_Kategori as L_Kategori;

class ProductController extends Controller
{
    protected $status = "non_aktif";
    protected $stock = 0;
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
