<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


use App\Models\Carts as Cart;

class Payment extends Model
{
    protected $primaryKey = 'id';

    public $incrementing = true;


    protected $fillable = [
        'cart_id',
        'payment_method',
        'status',
        'amount',
        'paid_at',
    ];

    public function cart()
    {
        return $this->belongsTo(Cart::class, 'cart_id');
    }
}
