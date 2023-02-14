import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/registration_provider.dart';
import 'package:sixcore/Widgets/button.dart';
import 'package:sixcore/Widgets/number_picker/numberpicker.dart';

import '../../../Constants/colors.dart';
import '../../../Utils/snackbar.dart';
import '../../../Widgets/gender_picker.dart';
import '../../../Widgets/height_selector.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegistrationProvider>(
      create: (context) => RegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register a new account'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const GenderSelector(),
                  const HeightSelector(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Current weight',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 35,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.teal,
                              ),
                              child: Consumer<RegistrationProvider>(
                                builder: (context, reg, _) {
                                  return Column(
                                    children: [
                                      Text('${reg.weight}kg',
                                          style: TextStyle(
                                            color: AppColor.greyShade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(height: 20),
                                      NumberPicker(
                                        minValue: 25,
                                        maxValue: 150,
                                        value: reg.weight,
                                        axis: Axis.horizontal,
                                        itemHeight: 20,
                                        itemWidth: 32,
                                        itemCount: 5,
                                        textStyle: TextStyle(
                                          color: AppColor.greyShade800,
                                          fontSize: 11,
                                        ),
                                        selectedTextStyle: TextStyle(
                                          color: AppColor.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        haptics: true,
                                        onChanged: (value) {
                                          reg.weight = value;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Age',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 35,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.teal,
                              ),
                              child: Consumer<RegistrationProvider>(
                                builder: (context, reg, _) {
                                  return Column(
                                    children: [
                                      Text('${reg.age}',
                                          style: TextStyle(
                                            color: AppColor.greyShade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(height: 20),
                                      NumberPicker(
                                        minValue: 20,
                                        maxValue: 50,
                                        value: reg.age,
                                        axis: Axis.horizontal,
                                        itemHeight: 20,
                                        itemWidth: 32,
                                        itemCount: 5,
                                        textStyle: TextStyle(
                                          color: AppColor.greyShade800,
                                          fontSize: 11,
                                        ),
                                        selectedTextStyle: TextStyle(
                                          color: AppColor.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        haptics: true,
                                        onChanged: (value) {
                                          reg.age = value;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _nameField(),
                  const SizedBox(height: 20.0),
                  _emailField(),
                  const SizedBox(height: 20.0),
                  _passwordField(),
                  const SizedBox(height: 20.0),
                  Consumer<RegistrationProvider>(
                    builder: (context, reg, _) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (reg.responseMessage != '') {
                          warningMessage(
                            message: reg.responseMessage,
                            context: context,
                          );
                          reg.clearMessage();
                        }
                      });
                      return StatefulButton(
                        onTap: () {
                          if (_name.text.isEmpty ||
                              _email.text.isEmpty ||
                              _password.text.isEmpty) {
                            errorMessage(
                              message: 'All fields are required',
                              context: context,
                            );
                          } else {
                            reg.name = _name.text.trim();
                            reg.email = _email.text.trim();
                            reg.password = _password.text.trim();
                            reg.signUp(context: context);
                          }
                        },
                        label: 'Register',
                        isLoading: reg.isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      controller: _name,
      style: TextStyle(color: AppColor.blue),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.supervised_user_circle),
        hintText: 'Your full name',
      ),
    );
  }

  _emailField() {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: AppColor.blue),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email_rounded),
        hintText: 'Your email address',
      ),
    );
  }

  _passwordField() {
    return TextFormField(
      controller: _password,
      obscureText: true,
      style: TextStyle(color: AppColor.blue),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.password_rounded),
        hintText: 'Your password',
      ),
    );
  }
}
