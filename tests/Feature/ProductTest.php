<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
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
    
}
