import 'package:flutter/material.dart';
import 'color.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = true;

  set setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;

  get getprimerycolor => isDark ? darkPrimeryColor : primeryColor;

  get getbackcolor => isDark ? darkbackColor : lightbackColor;

  get getprimerydarkcolor => isDark ? primerydarkColor : primerylightColor;

  get getdarkscolor => isDark ? lightColor : darkColor;

  get getdarkgreycolor => isDark ? darkgreyColor : greyColor;

  get getdarkwhitecolor => isDark ? darkwhiteColor : lightwhiteColor;

  get getbluecolor => isDark ? darkblueColor : blueColor;

  get gettabcolor => isDark ? darktabColor : tabColor;

  get gettabwhitecolor => isDark ? darktabwhiteColor : lighttabwhiteColor;

  get getpurplcolor => isDark ? darkpurpulColor : purpulColor;

  get getgreycolor => isDark ? darktabwhiteColor : lighttabwhiteColor;

  get getwhite => isDark ? primerydarkColor : lightColor;

  get getorangeprimerycolor => isDark ? orangedark : orange;

  get getorangedarkcolor => isDark ? orangedark : orangedark;

  get getlightbackColorhome => isDark ? lightbackColorhome : lightbackColorhome;

  get getprimerycolorlogin => isDark ? darkPrimeryColorLogin : primeryColor;


  get gettableclaro => isDark ? gettableoscuro1 : gettableclaro1;
  get gettableoscuro => isDark ? gettableoscuro2 : gettableclaro2;


  get gettabwhitecolorlogin => isDark ? darktabwhiteColorLogin : lighttabwhiteColor;

}
