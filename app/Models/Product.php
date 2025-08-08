<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;


use App\Models\Log_Kategori as LogKategori;
use App\Models\Kategori as Kategori;
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
        'description',
        'status_product',
        'stock',
    ];


   
    public function variants() {
        return $this->hasMany(ProductVariant::class,'product_id','id');
    }

    // Relasi ke 'log_kategori' untuk mendapatkan kategori_id
    public function log_kategori()
    {
        return $this->hasOne(LogKategori::class, 'product_id', 'id');
    }

    // Relasi ke 'kategori' melalui 'log_kategori'
    public function kategori()
    {
        return $this->belongsToMany(Kategori::class, 'log_kategoris', 'product_id', 'id_kategori');
    }
}
