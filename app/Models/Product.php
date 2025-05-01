<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;


use App\Models\Log_Product as L_Product;

class Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'nama_product',
        'harga_product',
        'Description',
        'status_product',
        'stock',
    ];


    public function log_product() : HasMany{
        return $this->hasMany(L_Product::class,'product_id','id');
    }
}
