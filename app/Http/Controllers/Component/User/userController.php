<?php

namespace App\Http\Controllers\Component\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
//  model 
use App\Models\User as User;
use App\Models\Profile as Profile;
use Spatie\Permission\Models\Role as Role;



class userController extends Controller
{

    public function userRegister($nama_lengkap, $email , $no_handphone , $password, $admin = false ){ 
        $user = User::create([
            'email' => $email,
            'password' => Hash::make($password)
        ]);
        $profile = Profile::create([
            'user_id' => $user['id'],
            'nama_lengkap' => $nama_lengkap,
            'no_handphone' => $no_handphone
        ]);
        $roleName = $admin ? 'admin' : 'user';
        $user->assignRole(Role::where('name', $roleName)->where('guard_name', 'api')->first());

        return true;
    }

    public function updateProfile($id_user,$nama_lengkap = null,$email = null,$no_handphone = null,$password = null){

       $user = User::findOrFail($id_user);
       if($nama_lengkap != null){
            $user->profile->update([
                'nama_lengkap' => $nama_lengkap,
            ]);
        }
       if($no_handphone != null){
            $user->profile->update([
                'no_handphone' => $no_handphone,
            ]);
        }
        if($email != null){
            $user->update([
                'email' => $email,
            ]);
        }
        if($password != null){
            $user->update([
                'password' => Hash::make($password),
            ]);
        }
        return true;
        
    }
}
