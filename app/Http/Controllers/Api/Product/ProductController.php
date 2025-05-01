<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


// Controller
use App\Http\Controllers\Component\Product\ProductController as C_Product;


// Request
use App\Http\Requests\Product\CreateRequest as V_Create;

// Response
use App\Http\Resources\Default\ResponseSuccess as R_Success;


class ProductController extends Controller
{
    protected $productController , $kategoriController;
    public function __construct(){
        $this->productController = new C_Product();
    }

    public function createProduct(V_Create $request){
        $value = $request->validated();
        // user id 
        $user = Auth::user()->id;
        // upload image

        // upload barang 
        $this->productController->create($user , $value['nama_product'],$value['harga_product'],$value['description_product'],$value['stock'],$value['kategori_id']);
        return new R_Success(['message' => 'Product berhasil dibuat']);
    }

    public function edit(Request $request){
        $value = $request->validate([
            'nama_product' => ['required','string'],
            'harga_product' => ['required','numeric'],
            'description_product' => ['required'],
            'stock' => ['required','numeric'],
            'kategori_id' => ['required','exists:kategoris,id'],
            'image' => ["required","image","mimes:png","max:2048"],
        ],);
        $value['nama_product'] = (is_null($value['nama_product'])) ? null :$value['nama_product'];
        $value['harga_product'] = (is_null($value['harga_product'])) ? null :$value['harga_product'];
        $value['description_product'] = (is_null($value['description_product'])) ? null :$value['description_product'];
        $value['stock'] = (is_null($value['stock'])) ? null :$value['stock'];
        $value['kategori_id'] = (is_null($value['kategori_id'])) ? null :$value['kategori_id'];
    }
}
