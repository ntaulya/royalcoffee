<?php

namespace App\Http\Controllers\Component\Roles;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;

class RoleController extends Controller
{
    public function getRoles(){
        $roles = Role::where('guard_name','api')->get(['name']);
        return $roles;
    }
    public function setRole($user_id,$roles){
        $user = User::find($user_id);
        $user->syncRoles([$roles]);
        return true;
    }
}
