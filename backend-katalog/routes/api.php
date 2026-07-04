<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProductController;

// Route Autentikasi (Publik)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Route yang Diproteksi JWT
Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // Otomatis membuat route index, store, show, update, destroy
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('products', ProductController::class);
});