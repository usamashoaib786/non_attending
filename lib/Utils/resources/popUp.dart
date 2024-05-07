import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';

class CustomPopupDialog extends StatelessWidget {
  final String? image;
  final String? msg1;
  final String? msg2;
  final Color? color;

  const CustomPopupDialog(
      {super.key, this.image, this.msg1, this.msg2, this.color});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 270.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.43, 0.5174, 0.6745],
            colors: [
              Color.fromARGB(255, 237, 216, 167), // 43%
              Color.fromARGB(255, 223, 214, 192), // 7.74%
              Color.fromARGB(255, 233, 216, 177), // 22.45%
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Image.asset(
                '$image',
              ),
              msg1 == null
                  ? const SizedBox.shrink()
                  : const SizedBox(
                      height: 5,
                    ),
              AppText.appText(
                '$msg1',
                textColor: color ?? AppTheme.red,
                fontSize: 23.0,
                fontWeight: FontWeight.w800,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText.appText(
                '$msg2',
                textColor: color ?? AppTheme.red,
                textAlign: TextAlign.center,
                fontSize: 19.0,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
