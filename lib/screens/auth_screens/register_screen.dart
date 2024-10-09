import 'package:flutter/material.dart';
import 'package:lati_marvel/helpers/consts.dart';
import 'package:lati_marvel/helpers/functions_helper.dart';
import 'package:lati_marvel/providers/authentication_provider.dart';
import 'package:lati_marvel/widgets/clickables/main_button.dart';
import 'package:lati_marvel/widgets/inputs/text_field_widget.dart';
import 'package:lati_marvel/widgets/statics/label_widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool hidePassword = false;

  List genders = ["Male", "Female"];
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authConsumer, child) {
      return Scaffold(
        body: Center(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LabelWidget(label: "Create Account to see Movies!"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Image.asset("assets/marvelLogo.png",
                          width: getSize(context).width * 0.8),
                    ),
                    TextFieldWidget(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is Required!";
                        }

                        if (value.length < 2) {
                          return "Enter Valid Name!";
                        }

                        return null;
                      },
                      hint: 'User name',
                      label: 'User name',
                    ),
                    TextFieldWidget(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone is Required!";
                        }

                        if (value.length != 10) {
                          return "Enter Valid Phone!";
                        }

                        return null;
                      },
                      hint: 'Enter Phone Number',
                      label: 'Phone',
                    ),
                    TextFieldWidget(
                      suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 16,
                        ),
                      ),
                      obSecure: hidePassword,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is Required!";
                        }

                        if (value.length < 8) {
                          return "Password Must be 8 charachters at least";
                        }

                        return null;
                      },
                      hint: 'Enter Password',
                      label: 'Password',
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return List<PopupMenuItem>.from(
                            genders.map((e) => PopupMenuItem(
                                  onTap: () {
                                    setState(() {
                                      genderController.text = e;
                                    });
                                  },
                                  child: Text(e),
                                ))).toList();
                      },
                      child: TextFieldWidget(
                        isEnabled: false,
                        controller: genderController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Gender is Required!";
                          }

                          return null;
                        },
                        hint: 'Gender',
                        label: 'Gender',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime(1997),
                                lastDate: DateTime(2006))
                            .then((selectedDate) {
                          setState(() {
                            dobController.text = selectedDate!
                                .toIso8601String()
                                .substring(0, 10);
                          });
                        });
                      },
                      child: TextFieldWidget(
                        isEnabled: false,
                        controller: dobController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "DOB is Required!";
                          }

                          return null;
                        },
                        hint: 'DOB',
                        label: 'DOB',
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    MainButton(
                      text: "Create!",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .register({
                            "name": nameController.text,
                            "phone": phoneController.text,
                            "password": passwordController.text,
                            "gender": genderController.text.toLowerCase(),
                            "DOB": dobController.text
                          }).then((created) {
                            if (created.first) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(created.last),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(created.last),
                              ));
                            }
                          });
                        }
                      },
                      // inProgress: authConsumer.busy
                    ),
                    MainButton(
                      text: "Already Have Account?, Login",
                      txtColor: mainColor,
                      btnColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
