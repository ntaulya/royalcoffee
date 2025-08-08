<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


// model
use App\Models\Carts as Carts;

class cart_waiting extends Model
{
    protected $fillable = [
        'cart_id',
        'status',
    ];

    public function cart(){
        return $this->hasOne(Carts::class,'id','cart_id');
    }
}
