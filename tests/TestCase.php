<?php

namespace Tests;

use Database\Seeders\PassportSeeder;
use Database\Seeders\RoleSeed;
use Database\Seeders\UserDump;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
abstract class TestCase extends BaseTestCase
{
    use RefreshDatabase;

    protected $email = "dev@gmail.com";
    protected $email_admin = "alfadjri28@gmail.com";
    protected $password = "12345678";
    protected $phone = "087718611101";
    protected function setUp(): void
    {
        parent::setUp();

        // Jalankan seeder umum
        $this->seed(PassportSeeder::class);
        $this->seed(RoleSeed::class);
        $this->seed(UserDump::class);
    }
}
