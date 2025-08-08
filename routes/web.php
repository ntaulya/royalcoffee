<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Route\GambarController as PrivateImageController;


use Illuminate\Support\Facades\Mail;

Route::middleware('auth:api')->get('/image/{filename}', [PrivateImageController::class, 'getImage']);

Route::get('/',function(){ 
    return abort(404);
});


