<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        // Mengambil produk sekalian dengan data kategorinya
        return response()->json(Product::with('category')->get(), 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'price' => 'required|integer',
            'stock' => 'required|integer',
        ]);

        $product = Product::create($request->all());
        return response()->json(['message' => 'Produk berhasil dibuat', 'data' => $product], 201);
    }

    public function show(Product $product)
    {
        return response()->json($product->load('category'), 200);
    }

    public function update(Request $request, Product $product)
    {
        $product->update($request->all());
        return response()->json(['message' => 'Produk berhasil diperbarui', 'data' => $product], 200);
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return response()->json(['message' => 'Produk berhasil dihapus'], 200);
    }
}