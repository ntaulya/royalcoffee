<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Laravel\Passport\ClientRepository;

class PassportSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $clientRepository = new ClientRepository();

        $clientRepository->createPersonalAccessClient(
            null, // user_id
            'Test Personal Access Client',
            'http://localhost'
        );
    }
}
