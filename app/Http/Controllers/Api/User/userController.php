<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

// Component
use App\Http\Controllers\Component\User\userController As C_User;


// Request
use App\Http\Requests\User\RegisterValidate as V_Register;


// Response
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;

class userController extends Controller
{
    protected $userController;
    public function __construct(C_User $controller){
        $this->userController = $controller;
    }
    public function registerUser(V_Register $request) {
        $value = $request->validated();
        $this->userController->create($value['nama_lengkap'],$value['email'],$value['phone'],$value['password'],false);
        return new R_Success(['message' => 'User berhasil dibuat']);
    }


    public function detailUser(Request $request){
        $value = $request->validate([
            'id' => ['nullable','string','exists:users,id'],
        ]);
        $value['id'] = (is_null($value['id'])) ? null : $value['id'];
        $user = $this->userController->detail($value['id']);
        return new R_D_Success(['data' => $user]) ;
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
}
