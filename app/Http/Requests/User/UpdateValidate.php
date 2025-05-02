<?php

namespace App\Http\Requests\User;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class UpdateValidate extends FormRequest
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
            'user_id' => ['nullable','string'],
            'nama_lengkap' => ['nullable','string'],
            'email' => ['nullable','email'],
            'phone' => ['nullable','phone:id'],
            'password' => ['nullable','string','min:8'],
        ];
    }
    public function messages(): array
    {
        return [
            'nama_lengkap.required' => "nama_lengkap wajib di isi",
            'phone.required' => "phone wajib di isi",
            'password.required'=> 'password wajib di isi',
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format tidak sesuai',
        ];
    }
    public function failedValidation(Validator $validator)
    {
        $errors = $validator->errors();

        throw new HttpResponseException(response()->json([
            'status' => false,
            'message' => $errors->first(), 
        ], 422)); 
    }
}
