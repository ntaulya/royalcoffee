<?php

namespace App\Http\Requests\Product;

use Illuminate\Foundation\Http\FormRequest;

class CreateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'nama_product' => ['required','string'],
            'harga_product' => ['required','numeric'],
            'description_product' => ['required'],
            'stock' => ['required','numeric'],
            'kategori_id' => ['required','exists:kategoris,id'],
            'image' => ["required","image","mimes:png","max:2048"],
        ];
    }
    public function messages(): array
    {
        return [
            'image.required' => 'Gambar harus diunggah.',
            'image.image' => 'File harus berupa gambar.',
            'image.mimes' => 'Format gambar harus PNG.',
            'image.max' => 'Ukuran gambar maksimal 2MB.',
        ];
    }
}
