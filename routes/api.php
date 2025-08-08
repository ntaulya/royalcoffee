<?php

use App\Http\Controllers\Api\LoginController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


// Controller
use App\Http\Controllers\Api\User\userController as UserController;
use App\Http\Controllers\Api\LoginController as Login;
use App\Http\Controllers\Api\Product\KategoriController as KategoriController;
use App\Http\Controllers\Api\Product\ProductController as ProductController;
use App\Http\Controllers\Api\Product\LogProductController as LogProductController;
use App\Http\Controllers\Api\Product\CheckoutController as CheckoutProductController;
use App\Http\Controllers\Api\Dapur\DapurController as DapurController;
use App\Http\Controllers\Api\Waiter\WaitersController as WaitersController;
use App\Http\Controllers\Api\Product\PajakController as PajakController;
use App\Http\Controllers\Api\Product\CheckAntrianController as AntrianController;

// Register
Route::post('/register',[UserController::class , 'registerUser']);
Route::post('/forget_password', [Login::class,'forgetPassword']);
Route::post('/login',[Login::class,'login']);
Route::post('/verifyOtp',[Login::class,'verifyOtp']);



Route::group(['middleware' => ['auth:api']],function(){
    Route::get('/logout',[Login::class,'logOut']);
    Route::group(['prefix' => "user"],function(){
        Route::get('/',[UserController::class,'serachUser'])->middleware('role:admin');
        Route::get('/roles',[UserController::class,'getListRole'])->middleware('role:admin');
        Route::post('/update/roles',[UserController::class,'updateRole'])->middleware('role:admin');
        Route::get('/detail',[UserController::class,'detailUser']);
        Route::patch('/detail',[UserController::class,'updateUser']);
    });


    Route::group(['prefix' => "product"],function(){
        Route::post('/create',[ProductController::class,'createProduct'])->middleware(['role:admin']);
        Route::delete('/create',[ProductController::class,'deleteProduct'])->middleware('role:admin');
        Route::patch('/status',[ProductController::class,'updateStatusProduct'])->middleware('role:admin');
        Route::patch('/stock',[ProductController::class,'addStockProduct'])->middleware('role:admin');
        Route::post('/',[ProductController::class,'updateProduct'])->middleware('role:admin');
        
        Route::group(['prefix' => "log"],function(){
            Route::get('/',[LogProductController::class,'logVarian'])->middleware('role:admin');
            Route::delete('/',[LogProductController::class,'deleteLogVarian'])->middleware('role:admin');
        });

        Route::get("/checkOrder",[CheckoutProductController::class,'getChecklistPembayaran'])->middleware('role:admin');
        Route::group(["prefix" => "pajak"], function(){
            Route::get('/',[PajakController::class,'getPajak']);
        });
        Route::get('/',[ProductController::class,'searchProduct']);
        Route::group(['prefix' => "carts"],function(){
            Route::post("/",[CheckoutProductController::class,'createCheckout']);
            Route::delete("/item",[CheckoutProductController::class,'deleteItem'])->middleware('role:admin');
            Route::delete('/delete',[CheckoutProductController::class,'batalkanPesanan'])->middleware(('role:admin'));
            Route::patch('/confirm',[CheckoutProductController::class,'confirmationPembayaran'])->middleware('role:admin');
        });
        Route::get("/checkOrder/history",[CheckoutProductController::class,'historyPembayaran']);
        Route::get('/history',[AntrianController::class,'listAntrian']);

        Route::group(['prefix' => 'dapur'],function(){
            Route::get('/',[DapurController::class,'listDapur'])->middleware('role:admin');
            Route::patch('/',[DapurController::class,'updateListDapur'])->middleware('role:admin');
        });
         Route::group(['prefix' => 'waiters'],function(){
            Route::get('/',[WaitersController::class,'listWaiter'])->middleware('role:admin');
            Route::patch('/',[WaitersController::class,'updatelistWaiter'])->middleware('role:admin');
        });

        
    });
});


Route::group(["prefix" => "categori"], function(){
    Route::get('/',[KategoriController::class,'searchCategori']);
});





