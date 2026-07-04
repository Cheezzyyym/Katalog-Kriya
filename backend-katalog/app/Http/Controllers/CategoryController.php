<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        return response()->json(Category::all(), 200);
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required|string|max:255']);
        $category = Category::create($request->all());
        return response()->json(['message' => 'Kategori berhasil dibuat', 'data' => $category], 201);
    }

    public function show(Category $category)
    {
        return response()->json($category, 200);
    }

    public function update(Request $request, Category $category)
    {
        $category->update($request->all());
        return response()->json(['message' => 'Kategori berhasil diperbarui', 'data' => $category], 200);
    }

    public function destroy(Category $category)
    {
        $category->delete();
        return response()->json(['message' => 'Kategori berhasil dihapus'], 200);
    }
}