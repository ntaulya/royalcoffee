<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

use App\Models\User;
use Database\Seeders\PassportSeeder;
use Database\Seeders\RoleSeed;
use Database\Seeders\UserDump;

class AuthApiTest extends TestCase
{
    public function test_user_can_register_with_valid_data(): void
    {
        $data = [
            'nama_lengkap' => 'Unit Test Developer 2',
            'email' => "dev2@gmail.com",
            'phone' => $this->phone,
            'password' => $this->password,
        ];
        $response = $this->postJson('/api/register',$data);
        $response->assertStatus(201);
    }

    public function test_user_cannot_register_with_invalid_email(): void {

        $data = [
            'nama_lengkap' => 'Unit Test Developer 3',
            'email' => "invalid email",
            'phone' => $this->phone,
            'password' => $this->password,
        ];
        $response = $this->postJson('/api/register',$data);
        $response->assertStatus(422);
    }

    public function test_user_can_request_otp_for_forgot_password(): void{

        $response = $this->postJson('/api/forget_password', [
            'email' => $this->email,
        ]);

        $response->assertStatus(201);
    }

    
    public function test_user_can_login_with_valid_credentials(): void{
        $response = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => ['token'],
        ]);
    }

    public function test_user_cannot_login_with_invalid_credentials()
    {
        $response = $this->postJson('/api/login', [
            'email' => 'wrong@example.com',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(400);
        $response->assertJson([
            'messange' => 'email atau password salah',
        ]);
    }
    public function test_detail_user_with_login()
    {
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');
    
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/user/detail?id=');
        $response->assertStatus(200);
    }

    public function test_update_profile_with_login(){
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->patchJson("/api/user/detail",[
            'user_id' => "",
            'email' => $this->email,
            'password' => '12345678',
            'phone' => '087718611101',
            'nama_lengkap' => 'Developer Testing 1 update',
        ]);
        $response->assertStatus(201);
    }

    public function test_detail_user_cannot_view_other_user_if_not_admin()
{
    // login sebagai user biasa
    $loginResponse = $this->postJson('/api/login', [
        'email' => $this->email, // user biasa
        'password' => $this->password
    ]);

    $token = $loginResponse->json('data.token');

    // cari id user admin untuk coba akses
    $adminId = User::where('email', $this->email_admin)->first()->id;
    // test akses detail user lain
    $response = $this->withHeaders([
        'Authorization' => 'Bearer ' . $token,
    ])->getJson("/api/user/detail?id={$adminId}");
    $response->assertStatus(403);
}
}
