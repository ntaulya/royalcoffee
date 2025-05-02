<?php

namespace Tests\Feature;

use App\Models\User;
use Tests\TestCase;

class UserTest extends TestCase
{
    protected $token;
    /**
     * A basic feature test example.
     */
    protected function setUp(): void
    {
        parent::setUp();
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email_admin,
            'password' => $this->password,
        ]);
        $loginResponse->assertStatus(200);
        $this->token = $loginResponse->json('data.token');
        // Jalankan seeder umum
    }    

    public function test_search_user_with_admin_role(): void
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/user?search=&page=&limit=');
        $response->assertStatus(200);
    }

    public function test_search_user_cannot_view_other_user_if_not_admin(): void
    {
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');
    
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/user?search=&page=&limit=');
        $response->assertStatus(403);
    }
    public function test_detail_user_can_view_other_user_with_admin()
    {
        $adminId = User::where('email', $this->email)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/user/detail?id={$adminId}");
        $response->assertStatus(200);
    }

    public function test_roles_user_can_view_with_admin()
    {
        $adminId = User::where('email', $this->email)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/user/roles");
        $response->assertStatus(200);
    }

    public function test_roles_user_cannot_view_if_not_admin(): void {
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');
    
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/user/roles');
        $response->assertStatus(403); 
    }

    public function test_update_roles_with_admin(){
        $adminId = User::where('email', $this->email)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/user/roles",[
            'user_id' => $adminId,
            'roles' => "admin",
        ]);
        $response->assertStatus(200);
    }
    public function test_update_roles_cannot_with_user(){
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');

        $adminId = User::where('email', $this->email)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson("/api/user/roles",[
            'user_id' => $adminId,
            'roles' => "admin",
        ]);
        $response->assertStatus(403);
    }

    public function test_update_profile_user_with_admin(){
        $adminId = User::where('email', $this->email)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->patchJson("/api/user/detail",[
            'user_id' => $adminId,
            'email' => $this->email,
            'password' => '12345678',
            'phone' => '087718611101',
            'nama_lengkap' => 'Developer Testing 1 update',
        ]);
        $response->assertStatus(201);
    }
    public function test_update_profile_user_cannot_update_with_user(){
        $loginResponse = $this->postJson('/api/login', [
            'email' => $this->email,
            'password' => $this->password,
        ]);
    
        $loginResponse->assertStatus(200);
        $token = $loginResponse->json('data.token');

        $adminId = User::where('email', $this->email_admin)->first()->id;
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->patchJson("/api/user/detail",[
            'user_id' => $adminId,
            'email' => $this->email_admin,
            'password' => '12345678',
            'phone' => '087718611101',
            'nama_lengkap' => 'Admin Testing 1 update',
        ]);
        $response->assertStatus(403);
    }
}
