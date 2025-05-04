<?php

namespace Tests\Feature;

use App\Models\Kategori;
use Database\Seeders\KategoriSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\UploadedFile;
use Tests\TestCase;

class ProductTest extends TestCase
{
    use RefreshDatabase;

    protected $token_admin, $token_user;
    protected function setUp(): void
    {
        parent::setUp();
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email_admin,
            'password' => $this->password,
        ]);
        $loginResponse->assertStatus(200);
        $this->token_admin = $loginResponse->json('data.token');
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
        $loginResponse->assertStatus(200);
        $this->token_user = $loginResponse->json('data.token');
        // Jalankan seeder umum
    }

    public function test_create_product_with_varian_and_image_using_admin_role(){
        Kategori::factory()->create(['id' => 1, 'nama_kategori' => 'Coffee']);
        $image = UploadedFile::fake()->image('panas.png');
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token_admin,
            'Content-Type'=>"multipart/form-data"
        ])->postJson('/api/product/create', [
            'nama_product' => 'Capucino',
            'harga_product' => '25000',
            'description_product' => 'Terbuat dari Kopi Pilihan alias sasetan',
            'kategori_id' => "1",
            'varian_product' => [
                [
                    'nama_varian' => 'HOT',
                    'harga_varian' => '25000',
                    'is_primary' => "true",
                    'stock_varian' => 10,
                    'image_varian' => $image
                ]
            ]
        ]);
        $response->assertStatus(201);
    }
    public function test_cannot_create_product_with_varian_and_image_using_user_role(){
        Kategori::factory()->create(['id' => 1, 'nama_kategori' => 'Coffee']);
        $image = UploadedFile::fake()->image('panas.png');
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token_user,
            'Content-Type'=>"multipart/form-data"
        ])->postJson('/api/product/create', [
            'nama_product' => 'Capucino',
            'harga_product' => '25000',
            'description_product' => 'Terbuat dari Kopi Pilihan alias sasetan',
            'kategori_id' => "1",
            'varian_product' => [
                [
                    'nama_varian' => 'HOT',
                    'harga_varian' => '25000',
                    'is_primary' => "true",
                    'stock_varian' => 10,
                    'image_varian' => $image
                ]
            ]
        ]);
        $response->assertStatus(403);
    }
    
}
