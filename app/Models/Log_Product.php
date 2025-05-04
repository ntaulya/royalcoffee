<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


use App\Models\Varian_Product as ProductVariants;
use App\Models\User as User;
class Log_Product extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'variant_id',
        'user_id',
        'status_upload',
        'qty_chnage',
        'note',
    ];

    public function variant(): BelongsTo {
        return $this->belongsTo(ProductVariants::class, 'variant_id','variant_id');
    }

    public function user() : BelongsTo{
        return $this->belongsTo(User::class,'user_id','user_id');
    }
}
