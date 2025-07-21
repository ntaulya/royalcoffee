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
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _service.getDapurList(); // metode dari DapurService
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
