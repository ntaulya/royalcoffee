<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

use App\Models\Carts_Item as CartsItem;
use App\Models\cart_waiting as LogCartsItem;
use App\Models\Payment as Payment;
use App\Models\User as User;

class Carts extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'user_id',
        'tipe_pemesanan',
        'metode_pembayaran',
        'status_pemesanan',
        'nomor_antrian',
        'total_before_tax',
        'tax_percent',
        'total_after_tax',
        'notes',
        'created_at',
    ];


    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            if (empty($model->id)) {
                do {
                    $id = Str::upper(Str::random(6)); // Misal: FXG1KZ
                } while (Carts::where('id', $id)->exists());

                $model->id = $id;
            }
        });
    }


    // RELATIONS
    public function items()
    {
        return $this->hasMany(CartsItem::class, 'cart_id', 'id');
    }

    public function logs()
    {
        return $this->hasOne(LogCartsItem::class, 'cart_id', 'id');
    }

    public function payment()
    {
        return $this->hasOne(Payment::class, 'cart_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id','id');
    }
}
