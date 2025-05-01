<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

use App\Models\User;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    protected $email = "alfadjri28@gmail.com";
    protected $password = "12345678";
    protected $phone = "087718611101";
    /**
     * A basic feature test example.
     */
    protected function setUp(): void
    {
        parent::setUp();
        // Jalankan passport:install hanya saat testing
        $this->artisan('passport:client --personal');

    }
    public function test_user_can_register_with_valid_data(): void
    {
        $data = [
            'nama_lengkap' => 'Unit Test Developer 1',
            'email' => $this->email,
            'phone' => $this->phone,
            'password' => $this->password,
        ];
        $response = $this->postJson('/api/register',$data);
        $response->assertStatus(201);
    }

    public function test_user_cannot_register_with_invalid_email(): void {

        $data = [
            'nama_lengkap' => 'Unit Test Developer 1',
            'email' => "invalid email",
            'phone' => $this->phone,
            'password' => $this->password,
        ];
        $response = $this->postJson('/api/register',$data);
        $response->assertStatus(422);
    }

    public function test_user_can_request_otp_for_forgot_password(): void{
        $user = User::factory()->create(['email' => $this->email]);

        $response = $this->postJson('/api/forget_password', [
            'email' => $user->email,
        ]);

        $response->assertStatus(201);
    }

    
    public function test_user_can_login_with_valid_credentials(): void{
        $user = User::factory()->create([
            'email' => $this->email,
            'password' => $this->password,
        ]);

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
}
