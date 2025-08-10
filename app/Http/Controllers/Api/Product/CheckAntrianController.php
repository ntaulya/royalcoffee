<?php

namespace App\Http\Controllers\Api\Product;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Component\Product\CheckAntrianController as C_Antrian;
use App\Http\Resources\Default\ReponseSuccessWithData as R_D_Success;
use Illuminate\Http\Request;

class CheckAntrianController extends Controller
{
    protected C_Antrian $antrian;

    public function __construct()
    {
        $this->antrian = new C_Antrian();
    }

    public function listAntrian(Request $request)
    {
        $value = $request->validate([
            'section' => ['nullable','in:true,false'],
        ]);
       $value['section'] = filter_var($value['section'] ?? null, FILTER_VALIDATE_BOOLEAN) ?: null;
        return new R_D_Success(['data' => $this->antrian->getlist(section: $value['section'])]);
    }

    public function listDapur()
    {
        return new R_D_Success(['data' => $this->antrian->getListDapur()]);
    }

    public function updateListDapur(Request $request)
    {
        $success = $this->antrian->updateListDapur(
            $request->id_checkout,
            $request->id_varian
        );

        return new R_D_Success(['success' => $success]);
    }

    public function listWaiters()
    {
        return new R_D_Success(['data' => $this->antrian->getListWaiters()]);
    }

    public function updateListWaiters(Request $request)
    {
        $success = $this->antrian->updateListWaiters(
            $request->id_checkout,
            $request->id_varian
        );

        return new R_D_Success(['success' => $success]);
    }
}
