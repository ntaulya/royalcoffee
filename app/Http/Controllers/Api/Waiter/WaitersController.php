<?php

namespace App\Http\Controllers\Api\Waiter;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


// Controller
use App\Http\Controllers\Component\Product\CheckAntrianController as C_Antrian;
use App\Http\Controllers\Component\Product\VarianController as C_Varian;


use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;

class WaitersController extends Controller
{
    protected $antrianController , $kategoriController , $varianController;
    public function __construct(){
        $this->antrianController = new C_Antrian();
        $this->varianController = new C_Varian();
    }
  
    public function listWaiter(){
        $data = $this->antrianController->getListWaiters();
        return new R_D_Success(['data' => $data]);
    }

     public function updatelistWaiter(Request $request){
        $value = $request->validate([
            'id_checkout' => ['required','string','exists:carts,id'],
            'id_varian' => ['required','string','exists:carts__items,varian_id'],
        ]);
        $this->antrianController->updateListWaiters($value['id_checkout'],$value['id_varian']);
        return new R_Success(['message' => "Update list Berhasil"]);
    }
}
