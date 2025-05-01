<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


// Controller
use App\Http\Controllers\Api\User\userController as UserController;
use App\http\Controllers\Api\LoginController as Login;


// Register
Route::post('/register',[UserController::class , 'registerUser']);
Route::post('/forget_password', [Login::class,'forgetPassword']);
Route::post('/login',[Login::class,'login']);
Route::post('/verifyOtp',[Login::class,'verifyOtp']);

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:api');
