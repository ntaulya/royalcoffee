<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


// Controller
use App\Http\Controllers\Component\Product\ProductController as C_Product;
use App\Http\Controllers\Component\Product\VarianController as C_Varian;

// Request
use App\Http\Requests\Product\CreateRequest as V_Create;
use App\Http\Requests\Product\SearchRequest as V_Search;

// Response
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;

class ProductController extends Controller
{
    protected $productController , $kategoriController , $varianController;
    public function __construct(){
        $this->productController = new C_Product();
        $this->varianController = new C_Varian();
    }


    public function searchProduct(V_Search $request){
        $value = $request->validated();
        $value['id_categori'] = (is_null($value['id_categori'])) ? 1 : $value['id_categori'];
        $value['id_product'] = (is_null($value['id_product']))  ? null :  $value['id_product'];
        $value['search'] = (is_null($value['search'])) ? null : $value['search'];
        $value['page'] =  (is_null($value['page'])) ? 1 : $value['page'];
        $data = $this->productController->search($value['id_categori'],$value['id_product'], $value['search'],$value['page']);
        return new R_D_Success(['data' => $data,'message']);
    }


    public function createProduct(V_Create $request){
        $value = $request->validated();
        // user id 
        $user = Auth::user()->id;

        // upload barang 
        $product = $this->productController->create(
             $value['nama_product'],
             $value['harga_product'],
             $value['kategori_id'],
             $value['description_product'],
        );
        $varians = $value['varian_product'];
        foreach($varians as $value){
            $varian = $this->varianController->create(
                $product->id,
                $value['nama_varian'],
                $value['harga_varian'],
                $value['stock_varian'],
                $value['image_varian'],
                ($value['is_primary'] == true) ? 1 : 0,
            );
            $this->productController->create_log(
                $varian->id,
                $user,
                "in",
                $value['stock_varian'],
                "Barang Baru",
            );
        }
        return new R_Success(['message' => 'Product berhasil dibuat']);
    }



    // public function edit(Request $request){
    //     $value = $request->validate([
    //         'nama_product' => ['required','string'],
    //         'harga_product' => ['required','numeric'],
    //         'description_product' => ['required'],
    //         'stock' => ['required','numeric'],
    //         'kategori_id' => ['required','exists:kategoris,id'],
    //         'image' => ["required","image","mimes:png","max:2048"],
    //     ],);
    //     $value['nama_product'] = (is_null($value['nama_product'])) ? null :$value['nama_product'];
    //     $value['harga_product'] = (is_null($value['harga_product'])) ? null :$value['harga_product'];
    //     $value['description_product'] = (is_null($value['description_product'])) ? null :$value['description_product'];
    //     $value['stock'] = (is_null($value['stock'])) ? null :$value['stock'];
    //     $value['kategori_id'] = (is_null($value['kategori_id'])) ? null :$value['kategori_id'];
    // }
}
