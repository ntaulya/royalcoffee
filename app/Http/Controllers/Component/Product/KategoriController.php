<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Kategori;

class KategoriController extends Controller
{
    
    public function getCategori($kategori_id = null , $page = 1 , $limit = 2){
        if(is_null($kategori_id)){
            return Kategori::select(['id','nama_kategori as nama'])->paginate($limit);
        }
        return Kategori::findOrFail($kategori_id);
    }
}
