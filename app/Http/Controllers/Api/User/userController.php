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

class userController extends Controller
{
    protected $userController;
    public function __construct(C_User $controller){
        $this->userController = $controller;
    }
    public function registerUser(V_Register $request) {
        $value = $request->validated();
        $this->userController->userRegister($value['nama_lengkap'],$value['email'],$value['phone'],$value['password'],false);
        $pesan = ['message' => 'User berhasil dibuat'];
        return new R_Success($pesan);
    }
}
