<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


use App\Models\Carts as Cart;
use App\Models\Product as Product;
use App\Models\Varian_Product as VarianProduct;


class Carts_Item extends Model
{
   protected $table = 'carts__items';

    protected $fillable = [
        'cart_id',
        'product_id',
        'varian_id',
        'qty',
        'price_at_that_time',
        'subtotal',
    ];

    public function cart()
    {
        return $this->belongsTo(Cart::class, 'cart_id');
    }

    public function product()
    {
        return $this->belongsTo(Product::class,'product_id','id');
    }

    public function varian()
    {
        return $this->belongsTo(VarianProduct::class, 'varian_id');
    }
}
