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
        Schema::create('carts', function (Blueprint $table) {
           $table->string('id', 6)->primary()->unique(); // short uuid
            $table->uuid('user_id');
            $table->foreign('user_id')->references('id')->on('users');
            $table->enum('tipe_pemesanan', ['dine_in', 'take_away']);
            $table->enum('metode_pembayaran', ['qris', 'tunai'])->nullable();
            $table->enum('status_pemesanan', ['waiting', 'processing', 'done', 'cancelled']);
            $table->decimal('total_before_tax', 10, 2);
            $table->decimal('tax_percent', 5, 2)->default(12.00);
            $table->decimal('total_after_tax', 10, 2)->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('carts');
    }
};
