<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Profile;
use Laravel\Passport\Client;
class DevSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Seed a default user
        $user = User::factory()->create([
            'email' => 'dev@example.com',
            'password' => bcrypt('password'),
        ]);

        Profile::factory()->create([
            'user_id' => $user->id,
            'nama_lengkap' => "Developer 1  Testing",
            'no_hnadphone' => "08771861101",
        ]);
        

        // Seed a personal access client
        Client::create([
            'id' => $user->id,
            'name' => 'Local Personal Access Client',
            'secret' => 'dummy-secret',
            'personal_access_client' => true,
            'password_client' => false,
            'revoked' => false,
        ]);
    }
}
