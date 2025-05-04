<?php

namespace Tests\Feature;

use App\Models\Kategori;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class KategoriTest extends TestCase
{
    use RefreshDatabase;
    /**
     * A basic feature test example.
     */
    public function test_it_can_get_all_kategori(){
        Kategori::factory()->count(4)->create();
        // Make GET request to the API with parameters
        $response = $this->getJson('api/categori?id=&page=1');
        // Check if the response status is 200
        $response->assertStatus(200);
        $response->assertJsonFragment([
            'status' => 'success',
            'message' => 'Berhasil Mengambil Data',
        ]);
    }
}
