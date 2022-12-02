import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sixcore/Constants/devices_and_services.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _device;
  bool _btScanRan = false;
  BluetoothService? _writeService;
  BluetoothService? _notifyService;
  BluetoothCharacteristic? _writeServiceCharacteristics;
  BluetoothCharacteristic? _notifyServiceCharacteristics;

  bool get isLoading => _isLoading;
  bool get btScanRan => _btScanRan;
  FlutterBluePlus get flutterBlue => _flutterBlue;
  BluetoothDevice? get device => _device;
  BluetoothService? get writeService => _writeService;
  BluetoothService? get notifyService => _notifyService;
  BluetoothCharacteristic? get writeServiceCharacteristics =>
      _writeServiceCharacteristics;
  BluetoothCharacteristic? get notifyServiceCharacteristics =>
      _notifyServiceCharacteristics;

  set device(BluetoothDevice? bluetoothDevice) {
    _device = bluetoothDevice;
    notifyListeners();
  }

  beginScanning() {
    _isLoading = true;
    notifyListeners();
    flutterBlue.startScan(timeout: const Duration(seconds: 10)).then((_) {
      _isLoading = false;
      _btScanRan = true;
      notifyListeners();
    });
  }

  Future<void> connectToBLE() async {
    await _device!.connect();

    if (_writeService == null ||
        _notifyService == null &&
            _writeServiceCharacteristics == null &&
            _notifyServiceCharacteristics == null) {
      List<BluetoothService> services = await _device!.discoverServices();

      _writeService = services
          .where((s) => s.uuid.toString() == writeServiceConst)
          .toList()
          .first;

      _notifyService = services
          .where((s) => s.uuid.toString() == notifyServiceConst)
          .toList()
          .first;

      _writeServiceCharacteristics = _writeService!.characteristics
          .where((c) => c.uuid.toString() == writeServiceCharacteristicsConst)
          .toList()
          .first;

      _notifyServiceCharacteristics = _notifyService!.characteristics
          .where((c) => c.uuid.toString() == notifyServiceCharacteristicsConst)
          .toList()
          .first;
    }
  }

  Future<void> disconnectFromBle() async {
    await _device!.disconnect();
  }

  sendCommandsToBoard() async {
    // This triggers the light toggle on device
    // await writeServiceCharsFound!.write([0xa8, 0x10, 0xB8]);
    await _writeServiceCharacteristics!.write([168, 16, 184]);
  }
}
