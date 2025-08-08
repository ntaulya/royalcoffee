<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('carts__items', function (Blueprint $table) {
            $table->id();
            $table->string('cart_id',6);
            $table->uuid('product_id');
            $table->unsignedBigInteger('varian_id');
            $table->integer('qty');
            $table->decimal('price_at_that_time', 10, 2);
            $table->decimal('subtotal', 10, 2);
            $table->enum('status',['belum','diantarkan','sudah'])->default('belum');
            $table->timestamps();

            $table->foreign('cart_id')->references('id')->on('carts')->onDelete('cascade');
            $table->foreign('product_id')->references('id')->on('products');
            $table->foreign('varian_id')->references('id')->on('varian__products');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('carts__items');
    }
};
