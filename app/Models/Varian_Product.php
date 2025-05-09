<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

use App\Models\Product;
use App\Models\Product_Image as ProductImage;
use App\Models\Log_Product as LogProduct;
class Varian_Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'product_id',
        'nama_varian',
        'harga',
        'stock',
    ];
    //
    public function product() : BelongsTo {
        return $this->belongsTo(Product::class,'product_id','id');
    }
    
    public function images() : HasMany {
        return $this->hasMany(ProductImage::class, 'variant_id','id');
    }
    public function logs() {
        return $this->hasMany(LogProduct::class, 'variant_id','id');
    }
}
