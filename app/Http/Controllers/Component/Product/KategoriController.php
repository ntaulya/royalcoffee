<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Kategori;

class KategoriController extends Controller
{
    
    public function getCategori($kategori_id = null , $page = 1 , $limit = 2){
        $query = Kategori::select(['id','nama_kategori as nama']);
    
        if (is_null($kategori_id)) {
            return $query->paginate($limit)->toArray(); // return array
        }
    
        return $query->findOrFail($kategori_id)->toArray(); // return array juga
    }
}
