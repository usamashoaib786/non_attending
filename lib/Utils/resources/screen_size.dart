import 'package:flutter/material.dart';

class ScreenSize {
  final BuildContext context;
  final double scalorValue;

  ScreenSize(this.context, {this.scalorValue=0.0});

  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenHeightMethod1 => (MediaQuery.of(context).size.height/100)*scalorValue;
  double get screenHeightMethod2 => MediaQuery.of(context).size.height *scalorValue;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenWidthMethod1 => (MediaQuery.of(context).size.width/100)*scalorValue;
  double get screenWidthMethod2 => MediaQuery.of(context).size.width *scalorValue;
  customAutoAdjustScreenHeight(){
    final height = MediaQuery.of(context).size.height;
    double smallHeight =  0.001;
    double smallHeight1 =  0.008;
    double smallHeight2 =  0.01;
    double smallHeight3 =  0.012;
    double smallHeight4 =  0.014;
    double smallHeight5 =  0.014;
    double smallHeight6 =  0.016;
    double smallHeight7 =  0.018;
    double smallHeight8 =  0.02;
    double smallHeight9 =  0.024;
    if(height >= 199 && height <= 239){
      return smallHeight;
    } else if(height >= 240 && height <= 319){
      return smallHeight1;
    }else if(height >= 320 && height <= 479){
      return smallHeight2;
    }else if (height >= 480 && height <= 519){
      return smallHeight3;
    } else if (height >= 520 && height <= 639){
      return smallHeight4;
    } else if (height >= 640 && height <= 719){
      return smallHeight5;
    } else if (height >= 720 && height <= 767){
      return smallHeight6;
    } else if (height >= 768 && height <= 799){
      return smallHeight7;
    } else if (height >= 800 && height <= 819){
      return smallHeight8;
    }
    else if(height >= 820 && height <= 899){
      return smallHeight9;
    }
    else{
      return 0.02;
    }
  }
}

class ScreenAdjusters{
  static Widget sizedBoxHeight(context,{double scalorValue = 0.0}){
    return SizedBox(height: ScreenSize(context,scalorValue: scalorValue).screenHeightMethod1,);
  }
  static Widget sizedBoxWidth(context,{double scalorValue = 0.0}){
    return SizedBox(width: ScreenSize(context,scalorValue: scalorValue).screenWidthMethod1,);
  }
  static Widget sizedBoxHeight2(context,{double scalorValue = 0.0}){
    return SizedBox(height: ScreenSize(context,scalorValue: scalorValue).screenHeightMethod2,);
  }
  static Widget sizedBoxWidth2(context,{double scalorValue = 0.0}){
    return SizedBox(width: ScreenSize(context,scalorValue: scalorValue).screenWidthMethod2,);
  }

}