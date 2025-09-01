import 'dart:async';
import '../models/LogHistory.dart';
import '../models/LogHistoryDetail.dart'; // ⬅️ model detail
import '../services/Api/Antrian/AntrianService.dart';

class HistoryController {
  static final HistoryController _instance = HistoryController._internal();
  factory HistoryController() => _instance;
  HistoryController._internal();

  final List<LogHistory> _items = [];
  final StreamController<List<LogHistory>> _antrianStreamController =
      StreamController<List<LogHistory>>.broadcast();

  final _service = AntrianService();

  Stream<List<LogHistory>> get antrianStream => _antrianStreamController.stream;
  List<LogHistory> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _notify() {
    _antrianStreamController.sink.add(List.unmodifiable(_items));
  }

  /// Ambil list history (ringkasan)
  Future<void> getHistory({String? page}) async {
    _isLoading = true;
    _error = null;
    _notify();

    try {
      final List<LogHistory> historyList =
          await _service.getListNotification(page: page);

      _items
        ..clear()
        ..addAll(historyList);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  /// Ambil detail history
  Future<List<LogHistoryDetail>> getDetailHistory({required String id}) async {
    _isLoading = true;
    _error = null;
    _notify();

    try {
      final List<LogHistoryDetail> detailHistory =
          await _service.getListNotificationDetail(idCheckout: id);
      return detailHistory;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      _notify();
    }
  }
}
