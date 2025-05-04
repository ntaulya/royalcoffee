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
                'nama_product' => ["required","string","max:255"],
                'harga_product' => ["required","integer","min:0"],
                'description_product' => ["required","string"],
                'kategori_id' => ["required","string","exists:kategoris,id"],
                'varian_product.*' => ["required","array","min:1"],
                'varian_product.*.nama_varian' => ["required","string","max:100"],
                'varian_product.*.harga_varian' => ["required","integer","min:0"],
                'varian_product.*.stock_varian' => ["required","integer","min:0"],
                'varian_product.*.is_primary' => ["required","in:true,false"],
                'varian_product.*.image_varian' => ["required","image","mimes:png,jpg,jpeg","max:2048"]
            ];
    }
    public function messages(): array
    {
        return [
            'varian_product.required' => 'Minimal harus ada satu varian produk',
            'varian_product.*.nama_varian.required' => 'Nama varian wajib diisi',
            'varian_product.*.harga_varian.image' => 'File varian harus berupa gambar',
        ];
    }
}
