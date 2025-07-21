import 'package:flutter/material.dart';
import '../../models/Dapur/DapurItem.dart';
import '../../services/Api/Dapur/DapurService.dart';

class DapurController extends ChangeNotifier {
  final DapurService _service = DapurService();

  List<DapurItem> _list = [];
  bool _loading = false;
  String? _error;

  List<DapurItem> get dapurList => _list;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchDapur() async {
    _setLoading(true);

    try {
      _list = await _service.getDapurList();
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
      await fetchDapur(); // Refresh data setelah update
    } catch (e) {
      _error = e.toString();
      notifyListeners(); // Penting hanya jika error ditampilkan
    }
  }

  // Helper agar DRY (Don’t Repeat Yourself)
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
