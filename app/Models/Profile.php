<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Profile extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    
    protected $fillable = [
        'user_id',
        'nama_lengkap',
        'no_handphone',
    ];


    public function user(): HasOne {
        return $this->HasOne(User::class , 'user_id', 'user_id');
    }
}
