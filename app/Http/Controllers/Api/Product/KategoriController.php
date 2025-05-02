<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


// Categori
use App\Http\Controllers\Component\Product\KategoriController as C_Kategori;

// Repsonse
use App\Http\Resources\Default\ReponseSuccessWithData as R_Reponse;
use GuzzleHttp\Psr7\Response;

class KategoriController extends Controller
{
    protected $kategoriController;

    public function __construct(){
        $this->kategoriController = new C_Kategori();
    }
    
    public function searchCategori(Request $request){
        $value = $request->validate([
            'id' => ['nullable','string','exists:kategoris,id'],
            'page' => ['nullable','numeric'],
        ]);
        $value['id'] = (is_null($value['id'])) ?? null ;
        $value['page'] = (is_null($value['page'])) ?? 1;
        $data = $this->kategoriController->getCategori($value['id'],$value['page']);
        return new R_Reponse(['data' => $data]);
    }
}
