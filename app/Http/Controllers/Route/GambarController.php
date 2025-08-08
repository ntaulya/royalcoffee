<?php

namespace App\Http\Controllers\Route;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class GambarController extends Controller
{
    public function getImage($filename)
    {
        // Cek apakah user terautentikasi via Passport
        if(!Auth::check()){
            return abort(404);
        }
        $user = auth('api')->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Path ke file privat
        $path = storage_path('app/private/product/' . $filename);


        if (!file_exists($path)) {
            return response()->json(['message' => 'File not found'], 404);
        }

        // Return file secara langsung (image/png, image/jpeg, dll)
        return response()->file($path);
    }
}
