<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Password;



// controller user
use App\Http\Controllers\Component\User\userController as C_User;


// model
use App\Models\PasswordResetToken as ResetPassword;

// Request
use App\Http\Requests\LoginValidate as V_Login;
use App\Http\Requests\ForgetPasswordValidate as V_Forget;
use App\Http\Requests\ForgetPasswordOTPValidate as V_Forget_OTP;
// Response
use App\Http\Resources\Default\ResponseLogin as R_Login;
use App\Http\Resources\Default\Failed\ResponseFailedLogin as R_F_login;
use App\Http\Resources\Default\ResponseSuccess as R_Success;
use App\Models\User;
use Illuminate\Support\Facades\Hash;


use App\Mail\sendOTP as OtpMail;
use Illuminate\Support\Facades\Mail;

class LoginController extends Controller
{
    public function login(V_Login $request){
        $value = $request->validated();
        // Check Kredensial
        if(Auth::attempt(['email' => $value['email'],'password' => $value['password']])){
            $user = Auth::user();
            $token['token'] = $user->createToken('login')->accessToken;
            return new R_Login($token);
        }
        $pesan = ['message' => "Email atau Password salah"];
        return new R_F_login($pesan);
    }

   


    public function forgetPassword(V_Forget $request){
        $value = $request->validated();
        $otp = rand(100000, 999999);
        ResetPassword::updateOrCreate(
            ['email' => $value['email']],
            [
                'token' => Hash::make($otp),
                'created_at' => now(),
            ]
        );
        try {
            Mail::to($value['email'])->send(new OtpMail($otp));
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengirim email: ' . $e->getMessage(),
            ], 500);
        }
        return new R_Success(['message' => "OTP Berhasil di kirimkan" ]);
    }


    public function verifyOtp(V_Forget_OTP $request){
        $value = $request->validated();
        if (!ResetPassword::isValidOtp($value['email'],$value['otp'])){
            $pesan = ['message' => "OTP Sudah kadaluarsa"];
            return new R_F_login($pesan);
        }
        $user = User::where('email',$value['email'])->first()->id;
        $status = new C_User();
        $status = $status->updateProfile($user,null,null,null,$value['password']);
        ResetPassword::where('email', $request->email)->delete();
        return new R_Success(['message' => 'Password berhasil direset']);
    }

    public function logOut(){
        if(Auth::check()){
            $user = Auth::user();
            $user = Auth::user()->token()->each(function($token){
                if(Auth::user()->id_user == $token->user_id){
                    $token->delete();
                }
            });
            return new R_Success(['message' => 'Berhasil Logout Dari Applikasi']);
        }
        return new R_F_login(['message' => 'Terjadi Kesalahan pada server']);
    }
}
