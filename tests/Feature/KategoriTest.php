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
    public function it_can_get_all_kategori(){
        Kategori::factory()->count(100)->create();

        $response = $this->getJson('api/categori');
        $response->assertStatus(200);
        $response->assertJson(100);
    }
}
