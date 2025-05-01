<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

use App\Models\Kategori;

class KategoriSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = ["coffe","Non-Coffe","Snack","Food"];

        foreach( $data as $value){
            Kategori::create(['nama_kategori' => $value]);
        }

    }
}
