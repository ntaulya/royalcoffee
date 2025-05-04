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
        $data = ["coffee","Non-Coffe","Snack","Food"];

        foreach($data as $value){
            Kategori::firstOrCreate(['nama_kategori' => $value]);
        }

    }
}
