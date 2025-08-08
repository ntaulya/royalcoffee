<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class SetupDevCommand extends Command
{
   protected $signature = 'setup:dev';
    protected $description = 'Fresh migrate, seed, and setup Passport for development';

    public function handle()
    {
        $this->info('🔑 Running key:generate');
        $this->call('key:generate');
        $this->info('⚙️ Running migrate:fresh --seed...');
        $this->call('migrate:fresh', ['--seed' => true]);

        $this->info('🔑 Running passport:key --force...');
        $this->call('passport:key', ['--force' => true]);

        $this->info('📱 Creating personal access client...');
        $this->call('passport:client', ['--personal' => true]);
        $this->info('✅ Setup complete!');
    }
}
