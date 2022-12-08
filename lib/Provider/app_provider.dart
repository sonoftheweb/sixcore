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

  void connectToBLE() {
    _device!.connect().then((_) {
      _device!.discoverServices().then((List<BluetoothService> services) {
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
            .where(
                (c) => c.uuid.toString() == notifyServiceCharacteristicsConst)
            .toList()
            .first;
      });
    });
  }

  Future<void> disconnectFromBle() async {
    await _device!.disconnect();
  }

  sendCommandsToBoard() {
    // This triggers the light toggle on device
    _writeServiceCharacteristics!
        .write([0xa8, 0x10, 0xB8]).then((Object? value) {
      print('Blinking light command sent');
      print(value);
    });
    // await _writeServiceCharacteristics!.write([168, 16, 184]);
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
    if (intValue == null && intChannel == null) {
      _writeServiceCharacteristics!.write(
        [intStart, intCommand, intCrc],
      ).then((Object? callbackValue) {
        print(
          'Started with $start, executed command $intCommand:$command with value $intValue:$value and CRC $intCrc:$crc sent to device!',
        );
        print('Value returned: $callbackValue');
      });
    }

    // has value
    if (intChannel == null && intValue != null) {
      _writeServiceCharacteristics!
          .write([intStart, intCommand, intValue, intCrc]).then(
              (Object? callbackValue) {
        print(
            'Started with $start, executed command $intCommand:$command with value $intValue:$value and CRC $intCrc:$crc sent to device!');
        print('Value returned: $callbackValue');
      });
    }

    // has value and channel
    if (intChannel != null && intValue != null) {
      _writeServiceCharacteristics!
          .write([intStart, intCommand, intChannel, intValue, intCrc]).then(
              (Object? callbackValue) {
        print(
            'Started with $start, executed command $intCommand:$command with value $intValue:$value and CRC $intCrc:$crc sent to device!');
        print('Value returned: $callbackValue');
      });
    }
  }
}
