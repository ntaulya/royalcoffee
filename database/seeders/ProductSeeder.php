<?php

namespace Database\Seeders;

use App\Models\Kategori;
use Illuminate\Database\Seeder;

use App\Models\Product;
use App\Models\Log_Product as L_Product;
use App\Models\Log_Kategori as L_Kategori;
use App\Models\Varian_Product as VarianProduct;
use App\Models\Product_Image as ProductImage;
use App\Models\User;
use Illuminate\Support\Str;
use Faker\Factory as Faker;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $kategoriId = Kategori::where('nama_kategori', 'coffee')->value('id');
        $user_id = User::where('email','=','admin@gmail.com')->first()->id;
        $fixedProducts = [
            [
                'nama_product' => 'Capucino',
                'harga_product' => 25000,
                'description_product' => 'Terbuat dari Kopi Pilihan alias sasetan',
                'status_product' => 'aktif',
                'kategori_id' => $kategoriId,
                'variants' => [
                    [
                        'nama_varian' => 'HOT',
                        'harga' => 0,
                        'is_primary' => true,
                        'stock' => 10,
                        'image_name' => '1747057568_panas.png',
                    ],
                    [
                        'nama_varian' => 'ICE',
                        'harga' => 0,
                        'is_primary' => false,
                        'stock' => 10,
                        'image_name' => '1747057568_dingin.png',
                    ],
                ],
            ],
            [
                'nama_product' => 'Milk Shake',
                'harga_product' => 20000,
                'description_product' => 'Minuman susu segar dengan berbagai rasa',
                'status_product' => 'non_aktif',
                'kategori_id' => $kategoriId,
                'variants' => [
                    [
                        'nama_varian' => 'Vanilla',
                        'harga' => 1000,
                        'is_primary' => true,
                        'stock' => 5,
                        'image_name' => '1747057568_panas.png',
                    ],
                    [
                        'nama_varian' => 'Strawberry',
                        'harga' => 2000,
                        'is_primary' => false,
                        'stock' => 7,
                        'image_name' => '1747057568_panas.png',
                    ],
                ],
            ],
        ];

        // Masukkan produk tetap
        foreach ($fixedProducts as $data) {
            $product = Product::create([
                'nama_product' => $data['nama_product'],
                'harga_product' => $data['harga_product'],
                'description' => $data['description_product'],
                'status_product' => $data['status_product'],
            ]);
            L_Kategori::create([
                "product_id" => $product->id,
                "id_kategori" => $data['kategori_id'],
            ]);
            $stok = 0;
            foreach ($data['variants'] as $variantData) {
                $stok = $stok + $variantData['stock'] ;
                $varian = VarianProduct::create([
                        "product_id" => $product->id,
                        "nama_varian" => $variantData['nama_varian'],
                        "harga" => $variantData['harga'],
                        "stock"  => $variantData['stock'],
                ]);
                $is_primary = ($variantData['is_primary'] == "true") ? 1 : 0 ;
                ProductImage::create([
                    'variant_id' => $varian->id,
                    "image_name" => $variantData['image_name'],
                    "image_path" => 'product/'.$variantData['image_name'],
                    "is_primary" => $is_primary
                ]);
                 L_Product::create([
                    "variant_id" => $varian->id,
                    "user_id" => $user_id,
                    "status_upload" => "in",
                    "qty_change" => $variantData['stock'],
                    "note" => "Barang Masuk",
                ]);
            }
            $product->update([
                'stock' => $stok,
            ]);
        }

        // // Tambahkan 20 produk acak
        // for ($i = 0; $i < 20; $i++) {
        //     $product = Product::create([
        //         'nama_product' => $faker->words(2, true),
        //         'harga_product' => $faker->numberBetween(10000, 50000),
        //         'description' => $faker->sentence(),
        //         'status_product' => $faker->randomElement(['aktif', 'non_aktif']),
        //     ]);
        //      L_Kategori::create([
        //         "product_id" => $product->id,
        //         "id_kategori" => $faker->numberBetween(1, 4),
        //     ]);
        //     $variantCount = rand(1, 3);
        //     $stock = 0;
        //     for ($v = 0; $v < $variantCount; $v++) {
        //         $random_value = $faker->numberBetween(0, 20);
        //         $stock = $stock + $random_value;
        //         $variant = VarianProduct::create([
        //             'product_id' => $product->id,
        //             'nama_varian' => strtoupper($faker->word),
        //             'harga' => $faker->numberBetween(0, 5000),
        //             'stock' => $random_value, 
        //         ]);
        //         ProductImage::create([
        //             'variant_id' => $variant->id,
        //             'image_name' => '1747057568_dingin.png',
        //             'image_path' => ($v == 0),
        //         ]);
        //     }
        //     $product->update([
        //         'stock' => $stok,
        //     ]);
        // }
    }
}
