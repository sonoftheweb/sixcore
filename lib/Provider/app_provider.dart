import 'dart:async';
import 'dart:typed_data';

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

  Future<void> disconnectFromBle({bool reset = false}) async {
    if (_device != null) {
      BluetoothDevice? d = _device;
      if (reset == true) {
        _device = null;
        _writeService = null;
        _notifyService = null;
        _writeServiceCharacteristics = null;
        _notifyServiceCharacteristics = null;
      }
      notifyListeners();
      await d!.disconnect();
    }
  }

  sendCommandsToBoard() {
    // This triggers the light toggle on device
    if (_writeServiceCharacteristics != null) {
      _writeServiceCharacteristics!
          .write([0xa8, 0x10, 0xB8]).then((Object? value) {
        print('Blinking light command sent');
        print(value);
      });
      // _writeServiceCharacteristics!
      //     .write([0xa8, 0x02, 0x10, 0x00, 0x32, 0xdd]).then((Object? value) {
      //   print('test with unit16');
      //   print(value);
      // });
    } else {
      print(
          "Waiting for device to set _writeServiceCharacteristics in provider. Device is quite slow");
    }
  }

  sendCustomCommandsToBoard({
    required String start,
    required String command_1,
    required String command_2,
    required String command_3,
    required String command_4,
    required String crc,
  }) {
    int? intStart = int.tryParse(start);
    int? intCommand1 = int.tryParse(command_1);
    int? intCommand2 = int.tryParse(command_2);
    int? intCommand3 = int.tryParse(command_3);
    int? intCommand4 = int.tryParse(command_4);
    int? intCrc = int.tryParse(crc);

    List<int> bleCommands = [];

    if (intStart != null) {
      bleCommands.add(intStart);
    } else {
      bleCommands.add(168);
    }

    if (intCommand1 != null) {
      bleCommands.add(intCommand1);
    }

    if (intCommand2 != null) {
      bleCommands.add(intCommand2);
    }

    if (intCommand3 != null) {
      bleCommands.add(intCommand3);
    }

    if (intCommand4 != null) {
      bleCommands.add(intCommand4);
    }

    if (intCrc != null) {
      bleCommands.add(intCrc);
    } else {
      bleCommands.add(168);
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

  setFrequency({required String value}) {
    int v = int.parse(value);
    int crc = 168 + 1 + v;
    print("Command sent [168, 1, $v, $crc] to set frequency ...");
    _writeServiceCharacteristics!.write([168, 1, v, crc]).then(
        (value) => print('Value returned from setting frequency: $value ...'));
  }

  setPulseWidth({required String value}) {
    Uint8List start = intToBytes(168);
    Uint8List command = intToBytes(2);
    Uint8List channel = intToBytes(6);
    Uint8List v = intToBytes(int.parse(value));
    int addedValues = start.reduce((value, element) => value + element) +
        command.reduce((value, element) => value + element) +
        channel.reduce((value, element) => value + element) +
        v.reduce((value, element) => value + element);
    Uint8List crc = intToBytes(addedValues);

    List writableCommand = [];
    writableCommand.addAll(start);
    writableCommand.addAll(command);
    writableCommand.addAll(channel);
    writableCommand.addAll(v);
    writableCommand.add(crc[crc.length - 1]);

    List<int> fullCommand = writableCommand
        .where((number) => number != 0)
        .whereType<int>()
        .toList();

    print("Command sent $fullCommand to set pulse width ...");
    _writeServiceCharacteristics!.write(fullCommand).then(
        (value) => print('Value returned from setting pulse with: $value ...'));
  }

  Uint8List intToBytes(int integer) {
    int length = integer.toString().length;
    Uint8List ret = Uint8List(length);
    for (int i = 0; i < length; i++) {
      ret[i] = integer & 0xff;
      integer = (integer - ret[i]) ~/ 256;
    }
    return reverseList(ret);
  }

  Uint8List reverseList(Uint8List bytes) {
    Uint8List reversed = Uint8List(bytes.length);
    for (int i = bytes.length; i > 0; i--) {
      reversed[bytes.length - i] = bytes[i - 1];
    }
    return reversed;
  }

  buildActionList({
    required String pulseTimeInMilliSeconds,
    required String pauseTimeInMilliSeconds,
    required int workoutTimeInSeconds,
    required String channel,
  }) {
    Map<String, Map<String, dynamic>> actions = {};
    int workoutTimeInMilliSeconds = workoutTimeInSeconds * 1000;
    bool on = false;
    int pauseTimer = 0;
    for (int i = 0; i < workoutTimeInMilliSeconds; i++) {
      pauseTimer++;
      if (pauseTimer == int.parse(pauseTimeInMilliSeconds).toInt()) {
        on = !on;
        pauseTimer = 0;
      }
    }
    /*int timerCount = 0;
    Timer.periodic(
      Duration(seconds: workoutTimeInSeconds),
      (timer) {
        timerCount++;
        print(timerCount);

        if (timerCount >= workoutTimeInSeconds) {
          timer.cancel();
        }
      },
    );*/
  }

  setupTriggerChannels({
    required String pulseTimeInMilliSeconds,
    required String pauseTimeInMilliSeconds,
    required int workoutTimeInSeconds,
    required String channel,
  }) {
    int channelInt = int.parse(channel).toInt();
    int crcStart = 168 + 3 + channelInt;
    var workoutCounter = 0;
    bool channelOn = false;
    int channelOnCounter = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      workoutCounter++;
      print('# sec $workoutCounter in $workoutTimeInSeconds');

      Timer.periodic(
        Duration(milliseconds: int.parse(pauseTimeInMilliSeconds).toInt()),
        (delayedTimer) {
          print('# delayed $pauseTimeInMilliSeconds ms in sec $workoutCounter');

          Timer.periodic(const Duration(milliseconds: 1), (channelTimer) async {
            channelOnCounter++;

            if (channelOnCounter ==
                int.parse(pulseTimeInMilliSeconds).toInt()) {
              channelOn = !channelOn;
              channelOnCounter = 0;
            }

            if (channelOn) {
              print('# disable channel $channel');
              await _writeServiceCharacteristics!
                  .write([168, 3, channelInt, 0, crcStart + 0]).then((value) =>
                      print('Value returned from setting frequency: $value'));
            } else {
              print('# enable channel $channel');
              await _writeServiceCharacteristics!
                  .write([168, 3, channelInt, 1, crcStart + 1]).then((value) =>
                      print('Value returned from setting frequency: $value'));
            }

            if (workoutCounter >= 5) {
              channelTimer.cancel();
            }
          });

          if (workoutCounter >= 5) {
            delayedTimer.cancel();
          }
        },
      );

      if (workoutCounter >= 5) {
        timer.cancel();
      }
    });
  }
}
