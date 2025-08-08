<?php

namespace App\Http\Resources\Default\Failed;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ResponseFailedLogin extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'status' => false,
            'message' => $this['message'],
        ];
    }
    public function withResponse($request, $response)
    {
        $response->setStatusCode(401);
    }
}
