import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Provider/registration_provider.dart';
import '../Utils/measurements.dart';

class HeightSelector extends StatelessWidget {
  const HeightSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Select your height',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.teal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Consumer<RegistrationProvider>(
                builder: (context, reg, _) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${reg.height} cm - ${Measurement.cmToInchAndFeetText(reg.height)}',
                          style: TextStyle(
                            color: AppColor.greyShade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      HorizontalPicker(
                        minValue: 55,
                        maxValue: 272,
                        divisions: 600,
                        height: 50,
                        suffix: " cm",
                        showCursor: true,
                        backgroundColor: AppColor.transparent,
                        activeItemTextColor: AppColor.blue,
                        passiveItemsTextColor: AppColor.greyShade800,
                        onChanged: (double value) {
                          reg.height = value;
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
