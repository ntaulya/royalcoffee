<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


// Controller
use App\Http\Controllers\Component\Product\ProductController as C_Product;
use App\Http\Controllers\Component\Product\CheckoutController as C_Checkout;
use App\Http\Controllers\Component\Product\VarianController as C_Varian;


use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;
use App\Http\Resources\Default\Failed\ResponseFailedLogin as R_Failed;


use App\Http\Requests\CheckOut\DeletePesanan as V_DeletePesanan;
use App\Http\Requests\CheckOut\DeleteItem as V_DeleteItem;
use App\Http\Requests\Product\CheckOutRequest as V_Checkout;

class CheckoutController extends Controller
{
    protected $productController , $kategoriController , $varianController,$checkoutController;
    public function __construct(){
        $this->productController = new C_Product();
        $this->checkoutController = new C_Checkout();
        $this->varianController = new C_Varian();
    }
    // Checkout
    public function getChecklistPembayaran(Request $request){
        $value = $request->validate([
            'id_checkout' => ['nullable','string','max:6'],
            'search' => ['nullable','string'],
            'page' => ['nullable','integer','min:1'],
        ]);
        $value['id_checkout'] = (empty($value['id_checkout'])) ? null  :$value['id_checkout'];
        $value['search'] = (empty($value['search'])) ? null :  $value['search'];
        $value['page'] = (empty($value['page'])) ? 1 : $value['page'];
        $data = $this->checkoutController->search($value['id_checkout'],$value['search'],$value['page']);
        if($data == false) return new R_Failed(['message' => "Data tidak di temukan"]);
        return new R_D_Success(['data' => $data]) ;
    }

    public function confirmationPembayaran(Request $request){
        $value = $request->validate([
            'id_checkout' => ['required','string','exists:carts,id'],
            'metode_pembayaran' => ['required','string','in:qris,tunai'],
            'nominal_pembayaran' => ['required','integer','min:0'],
        ]);

        $status = $this->checkoutController->konfirmasiPembayaran($value['id_checkout'],$value['metode_pembayaran'],$value['nominal_pembayaran']);
        if(!$status) return new R_Failed(['message' => "Nominal yang anda masukkan kurang dari pembayaran"]);
        return new R_Success(['message' => "Konfirmasi berhasil"]);
    }


    public function historyPembayaran(Request $request){
        $value = $request->validate([
            'id_checkout' => ['nullable','string','exists:carts,id'],
        ]);
        $value['id_checkout'] = (empty($value['id_checkout'])) ? null  :$value['id_checkout'];
        $data = $this->checkoutController->buktiPembayaran($value['id_checkout']);
        return new R_D_Success(['data' => $data]) ;
    }

    

    public function createCheckout(V_Checkout $request) {
        $value = $request->validated();
        $value['notes'] = (empty($value['notes']) ? null :  $value['notes']);
        $code_pesanan["code_pemesanan"] = $this->checkoutController->checkOut($value['product'],$value['tipe_pemesanan'],$value['notes']);
        if($code_pesanan["code_pemesanan"] == false){
            return new R_Failed(['message' => "Terjadi kesalahan pada data"]);
        }
        return new R_D_Success(['data' => $code_pesanan]);
    }


    // Belum Beres
    public function deleteItem(V_DeleteItem $request){
        $value = $request->validated();
        $status = $this->checkoutController->deleteItem($value['id_checkout'],$value['id_product'],$value['id_varian']);
        if(!$status){
            return new R_Failed(['message' => "Terjadi kesalahan pada data"]);
        }
        return new R_Success(['message' => "Konfirmasi berhasil"]);

    }

    public function batalkanPesanan(V_DeletePesanan $request){
        $value = $request->validated();
        $status = $this->checkoutController->deleteCheckout($value['id_checkout'],$value['password']);
        if(!$status){
            return new R_Failed(['message' => "Terjadi kesalahan pada data"]);
        }
        return new R_Success(['message' => "Konfirmasi berhasil"]);
    }
}
