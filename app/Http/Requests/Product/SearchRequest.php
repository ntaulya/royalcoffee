<?php

namespace App\Http\Requests\Product;

use Illuminate\Foundation\Http\FormRequest;

class SearchRequest extends FormRequest
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
            'id_categori' => ['nullable','numeric','exists:kategoris,id'],
            'id_product' => ['nullable','string','exists:products,id'],
            'search' => ['nullable','string'],
            'page' => ['nullable','numeric','min:1'],
            
        ];
    }
}
