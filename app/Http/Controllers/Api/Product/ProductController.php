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
use App\Http\Requests\Product\CheckOutRequest as V_Checkout;

// Response
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;
use App\Http\Resources\Default\Failed\ResponseFailedLogin as R_Failed;


use App\Http\Resources\Default\Failed\ReponseForbidden as R_F_Forbidden;

class ProductController extends Controller
{
    protected $productController , $kategoriController , $varianController;
    public function __construct(){
        $this->productController = new C_Product();
        $this->varianController = new C_Varian();
    }


    public function searchProduct(V_Search $request){
        $value = $request->validated();
        $value['id_categori'] = (is_null($value['id_categori'])) ? null : $value['id_categori'];
        $value['id_product'] = (is_null($value['id_product']))  ? null :  $value['id_product'];
        $value['search'] = (is_null($value['search'])) ? null : $value['search'];
        $value['page'] =  (is_null($value['page'])) ? 1 : $value['page'];
        $data = $this->productController->search($value['id_categori'],$value['id_product'], $value['search'],$value['page']);
        return new R_D_Success(['data' => $data,'message']);
    }


    public function createProduct(V_Create $request){
        $value = $request->validated();
        if( (int) $value['kategori_id'] <= 1){
           return response()->json(['messange' => "Category harus di atas 2"],401);
        }

        $user = Auth::user()->id;
        $product = $this->productController->create(
             $value['nama_product'],
             $value['harga_product'],
             $value['kategori_id'],
             $value['description_product'],
             $value['varian_product'],
             $user,
        );
        return new R_Success(['message' => 'Product berhasil dibuat']);
    }

    public function updateStatusProduct(Request $request){
        $value = $request->validate([
            'product_id' => ['required','string','exists:products,id'],
            'status_product' => ['required','string','in:aktif,non_aktif'],
        ]);
        $this->productController->update(product_id:$value['product_id'],status:$value['status_product']);
        return new R_Success(['message' => 'Product berhasil diubah']);
    }


    public function deleteProduct(Request $request){
        $value = $request->validate([
            'product_id' => ['required','string','exists:products,id'],
        ]);
        $status = $this->productController->deleteProduct($value['product_id']);
        if($status == 403) {
            return new R_F_Forbidden([]);
        }
        if($status == 409){
            return response()->json([
                "status" => "false",
                "message" => "Produk tidak dapat dihapus karena sudah pernah memiliki log stock",
            ],409);
        }
        return new R_Success(['message' => "Berhasil Menghapus data"]);
    }


    public function addStockProduct(Request $request){
        $value = $request->validate([
            'product_id' => ['required','string','exists:products,id'],
            'varian_id' => ['required','string','exists:varian__products,id'],
            'qty' => ['required','integer','min:1'],
        ]);
        $this->varianController->addStock(varian_id:$value['varian_id'],status_upload:"in",stock:$value['qty'],node:"Barang Masuk");
        return new R_Success(['message' => "Berhasil menambahkan stock"]);
    }



    public function updateProduct(Request $request){
        $value = $request->validate([
            'product_id' => ['required','string','exists:products,id'],
            'nama_product' => ['nullable' , 'string', 'max:255','unique:products,nama_product'],
            'harga_product' => ['nullable','string',"min:0"],
            'description_product' => ["nullable","string"],
            'kategori_id' => ["nullable","string","exists:kategoris,id"],
            'varian_product' => ["nullable","array","min:1"],
            'varian_product.*.varian_id' => ['nullable','string','exists:varian__products,id'],
            'varian_product.*.nama_varian' => ["nullable","string","max:100"],
            'varian_product.*.harga_varian' => ["nullable","integer","min:0"],
            'varian_product.*.stock' => ['nullable','integer','min:1'],
            'varian_product.*.is_primary' => ["nullable","in:true,false"],
            'varian_product.*.image_varian' => ["nullable","image","mimes:png,jpg,jpeg","max:2048"]
        ]);
        if (isset($value['kategori_id']) && (int)$value['kategori_id'] <= 1) {
            return response()->json(['message' => "Category harus di atas 2"], 422);
        }
        if (!empty($value['varian_product'])) {
            foreach ($value['varian_product'] as $varian) {
            if (!empty($varian['varian_id'])) {
                // Update varian lama
                $this->varianController->update(
                    varian_id:$varian['varian_id'],
                    nama_varian:$varian['nama_varian'],
                    harga_tambahan:$varian['harga_varian'],
                );
                $this->varianController->deleteImage($varian['varian_id']);
                $this->varianController->createImage($varian['varian_id'],$varian['image_varian'],$varian['is_primary']);
            } else {
                // Tambah varian baru
                $this->varianController->create(
                    product_id:$value['product_id'],
                    nama_varian:$varian['nama_varian'],
                    harga_tambahan:$varian['harga_varian'],
                    stock:$varian['stock'],
                    is_primary:$varian['is_primary'],
                    image_file:$varian['image_varian'],
                    user_id:Auth::user()->id,
                );
            }
        }

        }
        $value = [
            'product_id' => $value['product_id'],
            'nama_product'       => $value['nama_product'] ?? null,
            'harga_product'      => $value['harga_product'] ?? null,
            'description_product'=> $value['description_product'] ?? null,
            'kategori_id'        => $value['kategori_id'] ?? null,
        ];
        $this->productController->update(product_id:$value['product_id'],kategori_id:$value['kategori_id'],nama:$value['nama_product'],harga:$value['harga_product'],des:$value["description_product"]);
        return new R_Success(['message' => "Berhasil update product"]);
    }
}
