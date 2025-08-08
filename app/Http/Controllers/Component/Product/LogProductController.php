<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Product as Product;
use App\Models\Varian_Product as Varian;
use App\Models\Log_Product as L_Varian;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;


use App\Http\Controllers\Component\Product\VarianController as C_Varian;
use App\Http\Controllers\Component\Product\ProductController as C_Product;

class LogProductController extends Controller
{
    public function getLogVarian(int $id_varian , int $limit = 10){
        $data = L_Varian::where('variant_id',$id_varian)->orderBy('created_at','desc')->paginate($limit);
        $data->getCollection()->transform(function($item){
            return [
                'id_log' => $item->id,
                'id_varian'  => $item->variant_id,
                'nama_user' => $item->user->profile->nama_lengkap,
                'status_upload' => $item->status_upload,
                'qty' => $item->qty_change,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
            ];
        });
        return $data;
    }

    public function deleteLogVarian(int $id,string $password){
        $user = Auth::user();
        if(!Hash::check($password,$user->password)) return false;
        $data = L_Varian::find($id);
        $stock = $data->variant->stock;
        // Update Stock varian
        $varian = new C_Varian();
        $varian->update(varian_id: $data->variant->id,stock: $stock,status_upload: "out");
        // Update Stock Product
        $product = new C_Product();
        $product->update(product_id:$data->variant->product_id,stock: $stock,status_barang_masuk:"out");
        // Delete Stock
        $data->delete();
        return true;

    }
}
