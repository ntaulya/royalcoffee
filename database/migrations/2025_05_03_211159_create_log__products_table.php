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
        Schema::create('log__products', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('variant_id');
            $table->foreign('variant_id')->references('id')->on('varian__products')->onDelete('cascade');
            $table->uuid('user_id');
            $table->foreign('user_id')->references('id')->on('users');
            $table->enum('status_upload',['in','out','adjust']);
            $table->integer('qty_change');
            $table->text("note")->nullable(true );
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('log__products');
    }
};
