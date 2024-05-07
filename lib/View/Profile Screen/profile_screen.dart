import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:non_attending/Utils/resources/app_field.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:non_attending/View/HomeScreen/homescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cnfrmPassController = TextEditingController();
  bool edit = false;
  bool info = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        leading: IconButton(
          icon: Image.asset(
              'assets/images/drawer.png'), // Replace with your image asset
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: const MyDrawer(),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 216, 167), // 43%
              Color.fromARGB(255, 223, 214, 192), // 7.74%
              Color.fromARGB(255, 231, 221, 198), // 22.45%
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 220,
                width: screenWidth,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 170,
                        width: 137,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.blue, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      "assets/images/pen.png",
                                      height: 50,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: screenWidth,
                          child: Image.asset(
                            "assets/images/line.png",
                            fit: BoxFit.fill,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: 45,
                width: screenWidth,
                color: const Color.fromARGB(255, 188, 190, 197),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          info = true;
                        });
                      },
                      child: AppText.appText("Personal Info",
                          fontSize: 19, fontWeight: FontWeight.w400),
                    ),
                    Container(
                      height: 45,
                      width: 1,
                      color: AppTheme.blackColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          info = false;
                        });
                      },
                      child: AppText.appText("Saved Files",
                          fontSize: 19, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              info == true ? profileColumn() : savedColumn()
            ],
          ),
        ),
      ),
    );
  }

  Widget profileColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppFormField(
              texthint: "Enter Name",
              controller: _nameController,
              prefixImge: "assets/images/name.png",
            ),
            CustomAppFormField(
              texthint: "",
              controller: _emailController,
              prefixImge: "assets/images/email.png",
            ),
            CustomAppFormField(
              texthint: "",
              controller: _phoneController,
              prefixImge: "assets/images/phone.png",
            ),
            CustomAppPasswordfield(
              texthint: "Enter Password",
              controller: _passController,
              prefixImge: "assets/images/passKey.png",
            ),
            CustomAppPasswordfield(
              texthint: "Confirm Password",
              controller: _cnfrmPassController,
              prefixImge: "assets/images/passKey.png",
            ),
          ],
        ),
      ),
    );
  }

  Widget savedColumn() {
    return Column(
      children: [],
    );
  }
}
