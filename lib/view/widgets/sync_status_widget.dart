import 'package:flutter/material.dart';
import 'package:putevod/external/sync_service.dart';
import 'package:putevod/external/offline_storage.dart';

class SyncStatusWidget extends StatefulWidget {
  const SyncStatusWidget({super.key});

  @override
  State<SyncStatusWidget> createState() => _SyncStatusWidgetState();
}

class _SyncStatusWidgetState extends State<SyncStatusWidget> {
  String _syncStatus = '';
  bool _hasConnection = true;
  int _pendingOperations = 0;

  @override
  void initState() {
    super.initState();
    _initSyncService();
    _updateStatus();
  }

  void _initSyncService() {
    // Слушаем изменения статуса синхронизации
    SyncService.instance.onSyncStatusChanged = (status) {
      if (mounted) {
        setState(() {
          _syncStatus = status;
        });
      }
    };

    // Слушаем конфликты версий
    SyncService.instance.onConflictDetected = (message) {
      if (mounted) {
        _showConflictDialog(message);
      }
    };
  }

  Future<void> _updateStatus() async {
    final hasConnection = await OfflineStorage.hasConnection();
    final pendingOperations = SyncService.instance.pendingOperationsCount;
    
    if (mounted) {
      setState(() {
        _hasConnection = hasConnection;
        _pendingOperations = pendingOperations;
      });
    }
  }

  void _showConflictDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Конфликт версий'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SyncService.instance.forceSync();
            },
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_pendingOperations > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _pendingOperations.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              SyncService.instance.forceSync();
              _updateStatus();
            },
            child: const Icon(
              Icons.refresh,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!_hasConnection) {
      return Colors.red;
    } else if (SyncService.instance.isSyncing) {
      return Colors.orange;
    } else if (_pendingOperations > 0) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  IconData _getStatusIcon() {
    if (!_hasConnection) {
      return Icons.wifi_off;
    } else if (SyncService.instance.isSyncing) {
      return Icons.sync;
    } else if (_pendingOperations > 0) {
      return Icons.cloud_upload;
    } else {
      return Icons.cloud_done;
    }
  }

  String _getStatusText() {
    if (!_hasConnection) {
      return 'Оффлайн';
    } else if (SyncService.instance.isSyncing) {
      return _syncStatus.isNotEmpty ? _syncStatus : 'Синхронизация...';
    } else if (_pendingOperations > 0) {
      return 'Есть изменения';
    } else {
      return 'Синхронизировано';
    }
  }
} 