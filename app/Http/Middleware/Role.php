<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class Role
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next,$roles): Response
    {
        $acceptHeader = $request->header('Accept');
        if (strpos($acceptHeader, 'application/json') === false) {
            return response()->json(['message' => 'Accept header must be application/json'], 403);
        }
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }
        // Cek role user
        if (!$user->hasAnyRole($roles)) {
            return response()->json(['message' => 'Forbidden. Anda tidak punya akses.'], 403);
        }

        return $next($request);
    }
}
