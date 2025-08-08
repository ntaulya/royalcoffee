<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

use App\Models\Kategori;

class KategoriSeeder extends Seeder
{

    public static $kategori_ids = [];
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = ["all","coffee","Non-Coffe","Snack","Food"];

        foreach($data as $value){
            Kategori::create(['nama_kategori' => $value]);
        }

    }
}
