<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;


use App\Models\Varian_Product as ProductVariant;
use Illuminate\Database\Eloquent\Concerns\HasUlids;

class Product extends Model
{
    use HasFactory,HasUlids;
    public $incrementing = false;
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'nama_product',
        'harga_product',
        'Description',
        'status_product',
        'stock',
    ];


   
    public function variants() {
        return $this->hasMany(ProductVariant::class,'product_id','id');
    }
}
