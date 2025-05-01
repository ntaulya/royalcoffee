<?php

namespace App\Http\Controllers\Component\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
//  model 
use App\Models\User as User;
use App\Models\Profile as Profile;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Auth;
use Spatie\Permission\Models\Role as Role;




class userController extends Controller
{
    public function search($search = null , $page = 1 , $limit = 10 ){
        $user = User::with(['profile' => function(Builder $q) {
            $q->select(['user_id', 'nama_lengkap']);
        }])->select(['id']);
        $data = $user->paginate($limit);
        $data = $data->getCollection()->transform(function ($user){
            return [
                'id' => $user->id,
                'nama_lengkap' => $user->profile->nama_lengkap,
            ];
        });
        return $data;
    }

    public function create($nama_lengkap, $email , $no_handphone , $password, $admin = false ){ 
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

    public function detail($id_user = null){
        if(is_null($id_user)){
            $user = Auth::user();
        }else{
            $user = User::findOrFail($id_user);
        }
        $dataUser = [
            'email' => $user->email,
            'nama_lengkap' => $user->profile->nama_lengkap,
            'phone' => $user->profile->no_handphone,
            'role' => $user->getRoleNames()->toArray(),
        ];
        return $dataUser;
    }
}
