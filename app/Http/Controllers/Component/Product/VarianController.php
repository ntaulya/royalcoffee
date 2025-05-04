<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;

use App\Models\Varian_Product as VarianProduct;
use App\Models\Product_Image as ProductImage;
class VarianController extends Controller
{
    public function create($product_id,$nama_varian,$harga_tambahan,$stock,$image_file,$is_primary){
       $varian = VarianProduct::create([
            "product_id" => $product_id,
            "nama_varian" => $nama_varian,
            "harga" => $harga_tambahan,
            "stock"  => $stock,
       ]);
       $this->createImage($varian->id,$image_file,$is_primary);
       return $varian;
    }

    private function createImage($varian_id,$image_file,$is_primary = 0){
        $file = $image_file->file('image');
        $filename = time() ."_". $file->getClientOriginalName();
        $path = $file->storeAs("product",$filename,"private");

        ProductImage::create([
            'variant_id' => $varian_id,
            "image_name" => $filename,
            "image_path" => $path,
            "is_primary" => $is_primary
        ]);
    }
}
