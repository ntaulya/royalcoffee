import 'package:flutter/material.dart';
import '../../models/Antrian/Antrian.dart';
import '../../services/Api/Antrian/AntrianService.dart';

class AntrianController extends ChangeNotifier {
  final AntrianService _service = AntrianService();

  List<Antrian> _list = [];
  bool _loading = false;
  String? _error;

  List<Antrian> get antreanList => _list;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchAntrean({bool? section}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _service.getAntreanList(section: section);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
