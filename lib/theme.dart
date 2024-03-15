import 'package:flutter/material.dart';

// COLOR SCHEME
Color whiteColor = const Color(0xFFFEFDFF);
Color blackColor = const Color(0xFF0E0E0E);

Color subtitleTextColor = const Color(0xFF808080);
Color hintTextColor = const Color(0xFFBAC2C7);

Color greyBackgroundColor = const Color(0xFFE5E5E5);

Color disabledColor = const Color(0xFFC4C4C4);
Color transparentColor = Colors.transparent;

Color primaryColor50 = const Color(0xFFF3F4FD);
Color primaryColor100 = const Color(0xFFD8DCF8);
Color primaryColor200 = const Color(0xFFC6CBF4);
Color primaryColor300 = const Color(0xFFABB4F0);
Color primaryColor400 = const Color(0xFF9BA5ED);
Color primaryColor500 = const Color(0xFF828FE8);
Color primaryColor600 = const Color(0xFF7682D3);
Color primaryColor700 = const Color(0xFF5C66A5);
Color primaryColor800 = const Color(0xFF484F80);
Color primaryColor900 = const Color(0xFF373C61);

Color secondaryColor50 = const Color(0xFFFFF1F5);
Color secondaryColor100 = const Color(0xFFFED5E1);
Color secondaryColor200 = const Color(0xFFFEC0D2);
Color secondaryColor300 = const Color(0xFFFEA3BD);
Color secondaryColor400 = const Color(0xFFFD91B1);
Color secondaryColor500 = const Color(0xFFFD769D);
Color secondaryColor600 = const Color(0xFFE66B8F);
Color secondaryColor700 = const Color(0xFFB4546F);
Color secondaryColor800 = const Color(0xFF8B4156);
Color secondaryColor900 = const Color(0xFF6A3242);

Color greenLableColor = const Color(0xFF00D26E);
Color orangeLableColor = const Color(0xFFFA9F3C);

// TEXT STYLE
TextStyle primaryTextStyle = TextStyle(
  color: blackColor,
);

TextStyle headingSmallTextStyle = primaryTextStyle.copyWith(fontSize: 14);
TextStyle headingNormalTextStyle = primaryTextStyle.copyWith(fontSize: 16);
TextStyle headingMediumTextStyle = primaryTextStyle.copyWith(fontSize: 20);
TextStyle headingLargeTextStyle = primaryTextStyle.copyWith(fontSize: 24);
TextStyle headingExtraLargeTextStyle = primaryTextStyle.copyWith(fontSize: 32);

TextStyle paragraphSmallTextStyle = primaryTextStyle.copyWith(fontSize: 12);
TextStyle paragraphNormalTextStyle = primaryTextStyle.copyWith(fontSize: 14);
TextStyle paragraphLargeTextStyle = primaryTextStyle.copyWith(fontSize: 18);

TextStyle labelSmallTextStyle = primaryTextStyle.copyWith(fontSize: 10);
TextStyle labelNormalTextStyle = primaryTextStyle.copyWith(fontSize: 12);
TextStyle labelLargeTextStyle = primaryTextStyle.copyWith(fontSize: 14);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

// SHADOW
BoxShadow defaultShadow = const BoxShadow(
  color: Color(0x19000000),
  blurRadius: 10,
  offset: Offset(0, 0),
);
