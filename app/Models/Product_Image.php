<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

use Illuminate\Database\Eloquent\Relations\BelongsTo;
use App\Models\Varian_Product as ProductVariant;

class Product_Image extends Model
{
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id', 
        'variant_id', 
        'image_name', 
        'image_path', 
        'is_primary'
    ];

    public function variant() : BelongsTo {
        return $this->belongsTo(ProductVariant::class, 'variant_id');
    }
}
