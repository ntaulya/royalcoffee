<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

// Component
use App\Http\Controllers\Component\User\userController As C_User;
use App\Http\Controllers\Component\Roles\RoleController as C_Role;


// Request
use App\Http\Requests\User\RegisterValidate as V_Register;
use App\Http\Requests\User\UpdateValidate as V_Update;

// Response
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;
use App\Http\Resources\Default\Failed\ReponseForbidden as R_F_Forbidden;
use Illuminate\Support\Facades\Auth;

class userController extends Controller
{
    protected $userController,$rolesController;
    public function __construct(){
        $this->userController = new C_User;
        $this->rolesController = new C_Role;
    }
    public function registerUser(V_Register $request) {
        $value = $request->validated();
        $this->userController->create($value['nama_lengkap'],$value['email'],$value['phone'],$value['password'],false);
        return new R_Success(['message' => 'User berhasil dibuat']);
    }


    public function detailUser(Request $request){
        $value = $request->validate([
            'id' => ['nullable','string'],
        ]);
        
        $value['id'] = (is_null($value['id'])) ? null : $value['id'];
        $user = $this->userController->detail($value['id']);
        if($user == 403){
            return new R_F_Forbidden(true) ;
        }
        return new R_D_Success(['data' => $user]) ;
    }

    public function getListRole(){
        $roles = $this->rolesController->getRoles();
        return new R_D_Success(['data' => $roles]);
    }

    public function updateRole(Request $request){
        $value = $request->validate([
            'user_id' => ['required','string','exists:users,id'],
            'role' => ['required','string','exists:roles,name'],
        ]);
        $this->rolesController->setRole($value['user_id'], $value['role']);
        return new R_Success(['message' => 'Role berhasil di ubah']);
    }

    public function serachUser(Request $request){
        $value = $request->validate([
            'search' => ['nullable','strings'],
            'page' => ['nullable','numeric'],
            'limit' => ['nullable','numeric'],
        ]);
        $value = [
            'search' => (is_null($value['search'])) ? null : $value['search'],
            'page' => (is_null($value['page'])) ? null : $value['page'],
            'limit' => (is_null($value['limit'])) ? null : $value['limit']
        ];
        $user = $this->userController->search($value['search'],$value['page'],$value['limit']);
        return new R_D_Success(['data' => $user]);
    }

    public function updateUser(V_Update $request){
        $value = $request->validated(); 
        $value['user_id'] = $value['user_id'] ?? $value['user_id'];
        $status = $this->userController->updateProfile($value['user_id'],$value['nama_lengkap'],$value['email'],$value['phone'],$value['password']);
        if($status === 403){
            return new R_F_Forbidden(true) ;
        }
        return new R_Success(['message' => 'Profile berhasil di ubah']);
    }

}
