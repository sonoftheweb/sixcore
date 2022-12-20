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

  Future<void> disconnectFromBle() async {
    await _device!.disconnect();
  }

  sendCommandsToBoard() {
    // This triggers the light toggle on device
    if (_writeServiceCharacteristics != null) {
      _writeServiceCharacteristics!
          .write([0xa8, 0x10, 0xB8]).then((Object? value) {
        print('Blinking light command sent');
        print(value);
      });
    } else {
      print(
          "Waiting for device to set _writeServiceCharacteristics in provider. Device is quite slow");
    }
  }

  sendCustomCommandsToBoard({
    required String start,
    required String command,
    required String crc,
    required String value,
    required String channel,
  }) {
    int intStart = int.parse(start);
    int intCommand = int.parse(command);
    int intCrc = int.parse(crc);
    int? intValue = value.isNotEmpty ? int.parse(value) : null;
    int? intChannel = channel.isNotEmpty ? int.parse(channel) : null;

    // has no value and channel (simple light triggers)
    List<int> bleCommands = [];
    if (intValue == null && intChannel == null) {
      bleCommands = [intStart, intCommand, intCrc];
    }

    // has value
    if (intChannel == null && intValue != null) {
      bleCommands = [intStart, intCommand, intValue, intCrc];
    }

    // has value and channel
    if (intChannel != null && intValue != null) {
      bleCommands = [intStart, intCommand, intChannel, intValue, intCrc];
    }

    if (bleCommands.isNotEmpty) {
      _writeServiceCharacteristics!
          .write(bleCommands)
          .then((Object? callbackValue) {
        print(bleCommands);
        print('Value returned: $callbackValue');
      });
    }
  }
}
