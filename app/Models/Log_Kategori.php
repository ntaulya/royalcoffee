<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


use App\Models\Product as Product;
use App\Models\Kategori as Kategori;

class Log_Kategori extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';

    protected $fillable = [
        'product_id',
        'id_kategori',
    ];


     // Relasi ke Product
    // Relasi ke Product
    public function product()
    {
        return $this->belongsTo(Product::class, 'product_id', 'id');
    }

    // Relasi ke Kategori
    public function kategori()
    {
        return $this->belongsTo(Kategori::class, 'id_kategori', 'id');
    }
}
