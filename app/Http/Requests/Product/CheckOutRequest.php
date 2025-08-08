<?php

namespace App\Http\Requests\Product;

use Illuminate\Foundation\Http\FormRequest;

class CheckOutRequest extends FormRequest
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
            'product' => ['required','array','min:1'],
            'product.*.product_id' => ['required','exists:products,id'],
            'product.*.id_varian' => ['required','exists:varian__products,id'],
            'product.*.qty' => ['required','numeric','min:1'],
            'tipe_pemesanan' => ['required','in:take_away,dine_in'],
            'notes' => ['nullable','string','max:255'],
        ];
    }


     public function messages(): array
    {
        return [
            'product.required' => 'Minimal harus ada satu produk',
            'product.*.product_id.required' => 'id_product wajib di isi',
            'product.*.product_id.exists' => 'id_product wajib di isi',
            'product.*.id_varian.required' => 'id_varian wajib di isi',
            'product.*.id_varian.exists' => 'id_varian wajib di isi',
        ];
    }
}
