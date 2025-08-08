<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


use App\Models\Log_Kategori as Log_Kategori;


class Kategori extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'nama_kategori',
    ];
    public $timestamps = true;


   // Relasi ke Log_Kategori
    public function log_kategoris()
    {
        return $this->hasMany(Log_Kategori::class, 'id_kategori', 'id');
    }
}
