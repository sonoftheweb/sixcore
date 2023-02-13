import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/app_provider.dart';

import '../../Constants/colors.dart';
import '../Routines/view.dart';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      if (appProvider.device == null) {
        return StreamBuilder(
          stream: appProvider.flutterBlue.state,
          initialData: BluetoothState.unknown,
          builder: (
            BuildContext context,
            AsyncSnapshot<BluetoothState> snapshot,
          ) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: FindDeviceScreen(provider: appProvider),
              );
            } else {
              return Column(
                children: const [
                  Center(
                    child: Text('Bluetooth is switched off.'),
                  )
                ],
              );
            }
          },
        );
      } else {
        appProvider.connectToBLE();
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text(
                      '${appProvider.device!.name} device selected',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(AppColor.error),
                      ),
                      onPressed: () async {
                        await appProvider.disconnectFromBle(reset: true);
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColor.white,
                      ),
                      label: Text(
                        'Disconnect ${appProvider.device!.name}',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Double tap a setting to trigger the test.'),
              ),
              setFrequency(context, appProvider),
              setPulseWidth(context, appProvider),
              // fatBurningModeTest(context, appProvider),
            ],
          ),
        );
      }
    });
  }

  setFrequency(BuildContext context, AppProvider provider) {
    return GestureDetector(
      onTap: () {
        print('## Set Frequency ...');
        provider.setFrequency(value: '85');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColor.blue,
            border: Border.all(
              color: AppColor.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Set Frequency',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Frequency: 85hz',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setPulseWidth(BuildContext context, AppProvider provider) {
    return GestureDetector(
      onTap: () {
        print('## Set Pulse Width ...');
        provider.setPulseWidth(value: '350');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: AppColor.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Set Pulse Width',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Pulse Width: 50mu',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
