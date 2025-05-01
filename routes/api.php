<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


// Controller
use App\Http\Controllers\Api\User\userController as UserController;
use App\http\Controllers\Api\LoginController as Login;
use App\Http\Controllers\Api\Product\KategoriController as KategoriController;
use App\Http\Controllers\Api\Product\ProductController as ProductController;


// Register
Route::post('/register',[UserController::class , 'registerUser']);
Route::post('/forget_password', [Login::class,'forgetPassword']);
Route::post('/login',[Login::class,'login']);
Route::post('/verifyOtp',[Login::class,'verifyOtp']);



Route::group(['middleware' => ['auth:api']],function(){
    Route::group(['prefix' => "user"],function(){
        Route::get('/',[UserController::class,'serachUser']);
        Route::get('/detail',[UserController::class,'detailUser']);
    });
    Route::group(['prefix' => "product"],function(){
        Route::post('/create',[ProductController::class,'createProduct'])->middleware(['role:admin']);
    });
});


Route::group(["prefix" => "categori"], function(){
    Route::get('/',[KategoriController::class,'searchCategori']);
});



