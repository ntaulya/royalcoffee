<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

use Spatie\Permission\Models\Role as Roles;
use Spatie\Permission\Models\Permission as Permission;

class RoleSeed extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $roles = ['admin','user'];
        $permissions = ['api'];
        foreach ($roles as $roleName) {
            foreach ($permissions as $guardName) {
                // Cek apakah role sudah ada
                $role = Roles::firstOrCreate(
                    ['name' => $roleName, 'guard_name' => $guardName]
                );
            }
        }
    }
}
