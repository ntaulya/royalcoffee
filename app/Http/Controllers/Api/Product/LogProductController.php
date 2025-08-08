<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Http\Controllers\Component\Product\LogProductController as C_L_Varian;

// Response
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\Failed\ResponseFailedLogin as R_Failed;
use App\Http\Resources\Default\Failed\ReponseForbidden as R_F_Forbidden;



class LogProductController extends Controller
{

    protected $logController;
    public function __construct(){
        $this->logController = new C_L_Varian();
    }
    public function logVarian(Request $request){
        $value = $request->validate([
            'product_id' => ['required','string','exists:products,id'],
            'varian_id' => ['required','string','exists:varian__products,id'],
        ]);
        $value['varian_id'] = (int) $value['varian_id'];
        $data = $this->logController->getLogVarian(id_varian :$value['varian_id']);
        if(is_null($data)){
            return new R_F_Forbidden([]);
        }
         return new R_D_Success(['data' => $data,'message' => "log berhasil di ambil"]);
    }

    public function deleteLogVarian(Request $request){
        $value = $request->validate([
            'id_log' => ['required','string','exists:log__products,id'],
            'password' => ['required','string','min:8'],
        ]);
        $status = $this->logController->deleteLogVarian($value['id_log'],$value['password']);
        if(!$status) return new R_Failed(['message' => "Terjadi kesalahan pada data"]);
        return new R_Success(['message' => "Konfirmasi berhasil"]);
    }
}
