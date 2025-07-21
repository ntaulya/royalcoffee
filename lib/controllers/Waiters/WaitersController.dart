import 'package:flutter/material.dart';
import '../../models/Waiter/WaiterItem.dart';
import '../../services/Api/Waiters/WaitersService.dart';

class WaitersController extends ChangeNotifier {
  final WaitersService _service = WaitersService();

  List<WaiterItem> _list = [];
  bool _loading = false;
  String? _error;

  List<WaiterItem> get dapurList => _list;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchDapur() async {
    _setLoading(true);

    try {
      _list = await _service.getWaitersList(); // ✅ sesuai
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  Future<void> updatePesananStatus(String idCheckout, String idVarian) async {
    try {
      await _service.updateStatusPesanan(
        idCheckout: idCheckout,
        idVarian: idVarian,
      );
      await fetchDapur(); // refresh
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
