<?php

namespace App\Http\Controllers\Component\Product;

use App\Http\Controllers\Controller;
use App\Models\Carts;
use App\Models\cart_waiting as ListCarts;
use Illuminate\Support\Facades\URL;

class CheckAntrianController extends Controller
{
    public function getlist($limit = 10 , $section = null )
    {
        $twoMinutesAgo = now()->subMinutes(2);
        if (!is_null($section)) {
            $carts = Carts::whereDate('updated_at', today())
                ->orderBy('created_at', 'desc')
                ->paginate($limit);
        } else {
            $carts = Carts::where(function ($query) use ($twoMinutesAgo) {
                    $query->where('status_pemesanan', 'processing')
                        ->orWhere(function ($q) use ($twoMinutesAgo) {
                            $q->where('status_pemesanan', 'done')
                                ->where('updated_at', '>=', $twoMinutesAgo);
                        });
                })
                ->orderBy('created_at', 'asc')
                ->paginate($limit);
        }

        $carts->setCollection(
            $carts->getCollection()->transform(function ($item) {
                return [
                    'id_checkout' => $item->id,
                    'nama_user' => $item->user->profile->nama_lengkap ?? '-',
                    'proces' => $item->logs->status ?? '-',
                    'tipe_pemesanan' => $item->tipe_pemesanan,
                    'create_at' => $item->updated_at,
                ];
            })
        );


        return $carts;
    }

    public function getListDapur($limit = 10)
    {
        return $this->getFilteredList($limit, 'dapur');
    }

    public function updateListDapur($id_checkout, $id_varian)
    {
        return $this->updateItemStatus($id_checkout, $id_varian, 'diantarkan', 'waiters');
    }

    public function getListWaiters($limit = 10)
    {
        return $this->getFilteredList($limit, 'waiters');
    }

    public function updateListWaiters($id_checkout, $id_varian)
    {
        return $this->updateItemStatus($id_checkout, $id_varian, 'sudah', 'selesai');
    }

    protected function getFilteredList($limit, $view)
    {
        $carts = ListCarts::whereHas('cart.items', function ($query) use ($view) {
            if ($view === 'dapur') {
                $query->whereNotIn('status', ['diantrakan', 'sudah']);
            } elseif ($view === 'waiters') {
                $query->whereNotIn('status', ['belum', 'sudah']);
            }
        })->orderBy('updated_at', 'asc')->paginate($limit);


        $carts->setCollection(
            $carts->getCollection()->map(function ($item) use ($view) {
                return $this->detailItem($view, $item);
            })
        );

        return $carts;
    }

    protected function updateItemStatus($id_checkout, $id_varian, $newStatus, $nextStatus)
    {
        $cart = Carts::find($id_checkout);
        if (!$cart) return false;

        $updated = $cart->items()->where('varian_id', $id_varian)->update(['status' => $newStatus]);
        if (!$updated) return false;

        $total = $cart->items()->count();
        $done = $cart->items()->where('status', $newStatus)->count();

        if ($total === $done) {
            $cart->logs?->update(['status' => $nextStatus]);
            $cart->update(['status_pemesanan' => 'done']);
        }

        return true;
    }

    protected function detailItem($view, $item)
    {
        $productList = [];

        foreach ($item->cart->items as $cartItem) {
            if (
                ($view === 'dapur' && $cartItem->status === 'diantarkan') ||
                ($view === 'waiters' && ($cartItem->status === 'belum' || $cartItem->status === 'sudah'))
            ) {
                continue;
            }

            $productList[] = [
                'id_checkout' => $item->cart_id,
                'id_varian' => $cartItem->varian_id,
                'nama_pemesan' => $item->cart->user->profile->nama_lengkap ?? '-',
                'nama_product' => $cartItem->product->nama_product ?? '-',
                'nama_varian' => $cartItem->varian->nama_varian ?? '-',
                'status_pemesanan' => $cartItem->cart->tipe_pemesanan,
                'note' => $cartItem->cart->notes,
                'status' => $cartItem->status,
                'image_path' => URL::to('image/' . basename($cartItem->varian->images->image_name ?? 'default.jpg')),
                'item' => $cartItem->qty,
                'create_at' => $cartItem->updated_at,
            ];
        }

        return $productList;
    }

}
