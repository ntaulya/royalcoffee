<?php

namespace App\Http\Requests\CheckOut;

use Illuminate\Foundation\Http\FormRequest;

class DeletePesanan extends FormRequest
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
            'id_checkout' => ['required','string','exists:carts,id'],
            'password' => ['required','string','min:8'],
        ];
    }
}
