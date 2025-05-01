<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;
use Propaganistas\LaravelPhone\PhoneNumber;

class RegisterValidate extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'nama_lengkap' => ['required','string'],
            'email' => ['required','email','unique:users,email'],
            'phone' => ['required','phone:id'],
            'password' => ['nullable','string'],
        ];
    }

    public function failedValidation(\Illuminate\Contracts\Validation\Validator $validator){
        throw new HttpResponseException(response()->json([
            'nama_lengkap' => "nama_lengkap wajib di isi",
            'email' => "email wajib di isi",
            'phone' => "phone wajib di isi",
            'password'=> 'password wajib di isi',
        ],422));
    }
}
