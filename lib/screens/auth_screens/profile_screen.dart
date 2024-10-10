import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lati_marvel/helpers/consts.dart';
import 'package:lati_marvel/helpers/functions_helper.dart';
import 'package:lati_marvel/models/user_model.dart';
import 'package:lati_marvel/providers/authentication_provider.dart';
import 'package:lati_marvel/widgets/clickables/main_button.dart';
import 'package:lati_marvel/widgets/inputs/text_field_widget.dart';
import 'package:lati_marvel/widgets/statics/label_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List genders = ["Male", "Female"];
  bool edit = false;
  @override
  void initState() {
    Provider.of<AuthenticationProvider>(context, listen: false)
        .getCurrentUser()
        .then((userData) {
      nameController.text = userData!.name;
      phoneController.text = userData.phone;
      genderController.text = userData.gender;
      dobController.text = userData.dob.toString().substring(0, 10);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authConsumer, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: authConsumer.busy || authConsumer.currentUser == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : authConsumer.isFailed
                ? Center(
                    child: Text("Somthing went wrong!"),
                  )
                : SafeArea(
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Container(
                                    color: Colors.black12,
                                    child: Center(
                                      child: Image.network(
                                        width: getSize(context).width * 0.1,
                                        height: getSize(context).width * 0.1,
                                        authConsumer.currentUser!.avatarUrl
                                            .toString(),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Container(
                                                width: getSize(context).width *
                                                    0.33,
                                                height: getSize(context).width *
                                                    0.33,
                                                color: Colors.black12,
                                                child: Icon(
                                                  Icons.person,
                                                  size: getSize(context).width *
                                                      0.15,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextFieldWidget(
                              isEnabled: edit,
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
                              isEnabled: edit,
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
                            PopupMenuButton(
                              enabled: edit,
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
                                if (edit)
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
                              text: edit ? "Cancel" : "Edit",
                              onPressed: () {
                                setState(() {
                                  edit = !edit;
                                });
                              },
                            ),
                            if (edit)
                              MainButton(
                                btnColor: Colors.white,
                                txtColor: mainColor,
                                text: "Save",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      edit = !edit;
                                    });
                                    Provider.of<AuthenticationProvider>(context,
                                            listen: false)
                                        .updateUserProfile(UserModel(
                                            id: authConsumer.currentUser!.id,
                                            name: nameController.text,
                                            avatarUrl: authConsumer
                                                .currentUser!.avatarUrl
                                                .toString(),
                                            phone: phoneController.text,
                                            dob: DateTime.parse(
                                                dobController.text),
                                            gender: genderController.text,
                                            createdAt: authConsumer
                                                .currentUser!.createdAt,
                                            updatedAt: authConsumer
                                                .currentUser!.updatedAt))
                                        .then((updated) {
                                      if (updated.first) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(updated.last)));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(updated.last)));
                                      }
                                    });
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
      );
    });
  }
}
