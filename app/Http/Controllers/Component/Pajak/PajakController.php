<?php

namespace App\Http\Controllers\Component\Pajak;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PajakController extends Controller
{
    protected float $default_Pajak = 12.0;
    public function getDefaultPajak(): float {
        return $this->default_Pajak;
    }

    public function hitung_total_harga_setelah_pajak(float $harga_sebelum_pajak, ?float $custom_pajak = null) {
        $pajak = $custom_pajak ?? $this->default_Pajak;
        return $harga_sebelum_pajak + ( $harga_sebelum_pajak * ( $pajak / 100));
    }

    public function hitung_nilai_pajak(float $harga_sebelum_pajak, ?float $custom_pajak = null){
        $pajak = $custom_pajak ?? $this->default_Pajak;
        return $harga_sebelum_pajak * ($pajak / 100);
    }
    
}
