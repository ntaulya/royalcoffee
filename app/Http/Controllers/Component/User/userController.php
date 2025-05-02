<?php

namespace App\Http\Controllers\Component\User;

use App\Http\Controllers\Controller;

use Illuminate\Support\Facades\Hash;
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




    public function updateProfile($id_user = null, $nama_lengkap = null, $email = null, $no_handphone = null, $password = null)
    {
        $authUser = Auth::user();

        $targetUserId = $id_user ?? $authUser->id;
        if ($authUser->id !== $targetUserId && !$authUser->hasRole('admin')) {
            return 403;
        }

       

        $user = User::with('profile')->findOrFail($targetUserId);
        if (!$user) {
            return false;
        } 
        if ($email !== null && $email !== $user->email) {
            if (User::where('email', $email)->where('id', '!=', $targetUserId)->exists()) {
                return false;
            }
            $user->email = $email;
        }
        
        if ($password !== null) {
            $user->password = Hash::make($password);
        }
        
        $user->save();
        
        $profileData = [];
        if ($nama_lengkap !== null) {
            $profileData['nama_lengkap'] = $nama_lengkap;
        }
        if ($no_handphone !== null) {
            $profileData['no_handphone'] = $no_handphone;
        }
        
        if (!empty($profileData)) {
            $user->profile->update($profileData);
        }
        return true;
    }

    public function detail($id_user = null){
        $authUser = Auth::user();

        if (!is_null($id_user) && !$authUser->hasRole('admin') && $authUser->id != $id_user) {
           return 403; 
        }

        $user = is_null($id_user) ? $authUser : User::findOrFail($id_user);
        $data = [
            'email' => $user->email,
            'nama_lengkap' => $user->profile->nama_lengkap,
            'phone' => $user->profile->no_handphone,
            'role' => $user->getRoleNames()->toArray(),
        ];
        return $data;
    }
}
