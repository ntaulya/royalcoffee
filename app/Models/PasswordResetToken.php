<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Hash;

class PasswordResetToken extends Model
{
    protected $table = 'password_reset_tokens';
    public $timestamps = false;

    protected $fillable = ['email', 'token', 'created_at'];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public static function isValidOtp($email, $otp)
    {
        $record = self::where('email', $email)->first();

        if (!$record || !Hash::check($otp, $record->token)) {
            return false;
        }

        // Validasi expired 10 menit
        return $record->created_at > Carbon::now()->subMinutes(10);
    }
}
