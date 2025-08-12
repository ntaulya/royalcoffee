<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

use App\Models\Varian_Product as VarianProduct;
use App\Models\Product_Image as ProductImage;
use App\Models\Log_Product as L_Varian;


use App\Http\Controllers\Component\Product\ProductController as C_Product;


class VarianController extends Controller
{
    public function create($product_id,$nama_varian,$harga_tambahan,$stock,$image_file,$is_primary,$user_id){
       $varian = VarianProduct::create([
            "product_id" => $product_id,
            "nama_varian" => $nama_varian,
            "harga" => $harga_tambahan,
            "stock"  => $stock,
       ]);
       $C_Product = new C_Product();
       $this->createImage($varian->id,$image_file,$is_primary);
       $C_Product->create_log($product_id,$varian->id,$user_id,"in",$stock,"Barang Masuk");
    }

    public function addStock($varian_id,$status_upload,$stock,$node){
        L_Varian::create([
            'variant_id' => $varian_id,
            'user_id' => Auth::user()->id,
            'status_upload' => $status_upload,
            'qty_change' => $stock,
            'note' => $node,
        ]);
        $this->update(varian_id:$varian_id,stock:$stock,status_upload:"in");
    }


    public function update($varian_id,$nama_varian = null,$harga_tambahan = null,$stock = 0,$status_upload = null){
        $varain = VarianProduct::find($varian_id);
        if(!empty($nama_varian) && $varain->nama_varian != $nama_varian){
            $varain->update([
                "nama_varian" => $nama_varian
            ]);
        }
        if(!empty($harga_tambahan) && $varain->harga != $harga_tambahan){
            $varain->update([
                "harga" => $harga_tambahan,
            ]);
        }
        if(!empty($stock)){
            if($status_upload == "in"){
                $stock = (int)$varain->stock + (int) $stock;
            }
            if($status_upload == "out"){
                $stock = (int)$varain->stock - (int)$stock;
            }
            if($stock < 0 ){
                $stock = 0;
            }
            $varain->update([
                "stock" => $stock,
            ]);
        }

    }


    public function deleteImage($varian_id){
        $image = ProductImage::findOrFail($varian_id);
        if ($image->image_path && Storage::disk('private')->exists($image->image_path)) {
            Storage::disk('private')->delete($image->image_path);
            $image->delete();
        }
        return true;
    }

    public function createImage($varian_id,$image_file,$is_primary){
        $filename = time() ."_". $image_file->getClientOriginalName();
        $path = $image_file->storeAs("product",$filename,"private");
        $is_primary = ($is_primary == "true") ? 1 : 0 ;
        ProductImage::create([
            'variant_id' => $varian_id,
            "image_name" => $filename,
            "image_path" => $path,
            "is_primary" => $is_primary
        ]);
    }
}
