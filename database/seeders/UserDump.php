<?php

namespace Database\Seeders;

use App\Models\Profile;
use Spatie\Permission\Models\Role as Roles;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
class UserDump extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'email' => 'dev@gmail.com',
                'password' => '12345678',
                'phone' => '087718611101',
                'nama_lengkap' => 'Developer Testing 1',
                'role' => 'user'
            ],
            [
                'email' => 'alfadjri28@gmail.com',
                'password' => '12345678',
                'phone' => '087718611102',
                'nama_lengkap' => 'Admin Testing 1',
                'role' => 'admin'
            ]
        ];

        foreach ($users as $data) {
            $user = User::updateOrCreate(
                ['email' => $data['email']],
                ['password' => Hash::make($data['password'])]
            );

            Profile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'nama_lengkap' => $data['nama_lengkap'],
                    'no_handphone' => $data['phone']
                ]
            );

            $role = Roles::where('name', $data['role'])->where('guard_name', 'api')->first();
            if ($role) {
                $user->syncRoles([$role]);
            }
        }
    }
}
