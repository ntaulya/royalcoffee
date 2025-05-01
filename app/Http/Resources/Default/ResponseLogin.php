<?php

namespace App\Http\Resources\Default;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ResponseLogin extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
                'status' => "success",
                'message' => "User berhasil di buat",
                'data' => [
                    'token' => $this['token'],
                ]
        ];
    }
    public function withResponse($request, $response)
    {
        $response->setStatusCode(200);
    }
}
