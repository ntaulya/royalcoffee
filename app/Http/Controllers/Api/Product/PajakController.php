<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;

use App\Http\Resources\Default\ReponseSuccessWithData as R_Reponse;

use App\Http\Controllers\Component\Pajak\PajakController as C_Pajak;
use Illuminate\Http\Request;


class PajakController extends Controller
{
    protected $C_Pajak;

    public function __construct(){
        $this->C_Pajak = new C_Pajak();
    }

    public function getPajak(Request $request){
        $value = $request->validate([
            'total' => ['nullable','numeric','min:0'],
        ]);
        $data['pesen_pajak'] = $this->C_Pajak->getDefaultPajak();
        if(isset($value['total'])){
            $data['nilai_pajak'] = $this->C_Pajak->hitung_nilai_pajak($value['total']);
            $data['total_setelah_pajak'] = $this->C_Pajak->hitung_total_harga_setelah_pajak($value['total']);
        }
        return new R_Reponse(['data' => $data]);
    }
}
