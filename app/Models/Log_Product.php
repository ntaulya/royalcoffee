<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


use App\Models\Product as Product;

use App\Models\User as User;

class Log_Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'product_id',
        'user_id',
        'status_upload',
        'qty_chnage',
        'note',
    ];

    public function product() : BelongsTo{
        return $this->belongsTo(Product::class,'product_id','id');
    }

    public function user() : BelongsTo{
        return $this->belongsTo(User::class,'user_id','id');
    }
}
