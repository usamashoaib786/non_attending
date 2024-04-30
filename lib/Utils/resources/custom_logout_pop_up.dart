import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';


showLogOutALert(BuildContext context, {controller}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: SingleChildScrollView(
            child: Container(
              // width: 100,
              // height: 500,
              decoration: BoxDecoration(
                color: const Color(0xFFB38ADE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Are you sure, you want\nto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.33,
                          ),
                        ),
                        TextSpan(
                          text: ' Log out?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.33,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 2,
                      // color: AppTheme.primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.33,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: AppTheme.whiteColor,
                      ),
                      const Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.33,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ));
    },
  );
}
