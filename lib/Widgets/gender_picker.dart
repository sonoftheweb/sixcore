import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/registration_provider.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Select your gender',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Consumer<RegistrationProvider>(
                builder: (context, reg, _) {
                  return GestureDetector(
                    onTap: () {
                      reg.isMale = true;
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: reg.maleColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male_rounded,
                            color: reg.maleColor,
                            size: 40,
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: reg.maleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Consumer<RegistrationProvider>(
                builder: (context, reg, _) {
                  return GestureDetector(
                    onTap: () {
                      reg.isMale = false;
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: reg.femaleColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female_rounded,
                            color: reg.femaleColor,
                            size: 40,
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: reg.femaleColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
