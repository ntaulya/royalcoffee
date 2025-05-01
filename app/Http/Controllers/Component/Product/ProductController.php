<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\Product;
use App\Models\Log_Product as L_Product;

class ProductController extends Controller
{
    public function create($user_id , $nama, $harga , $des , $stock , $id_kategori){
        
        $product = Product::create([
            'nama_product' => $nama,
            "harga_product" => $harga,
            "Description" => $des,
            "status_product" => "non_aktif",
            "stock" => $stock,
        ]);

        $log = L_Product::create([
            'product_id' => $product->id,
            'user_id' => $user_id,
            'status_upload' => "in",
            "qty_chnage" => $stock,
            "note" => "Barang Baru Masuk",
        ]);
    }
}
