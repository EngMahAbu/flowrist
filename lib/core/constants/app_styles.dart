import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppStyles {
  static final TextStyle appTitle = GoogleFonts.imFellEnglish(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: AppColors.purpleBase,
  );

  static final TextStyle regular12Roboto = GoogleFonts.roboto(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.grey,
  );

  static final TextStyle regular12Inter = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.grey,
  );

  static final TextStyle regular12Underline = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.blackBase,
    decoration: TextDecoration.underline,
  );

  static final TextStyle regular13 = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: AppColors.blackBase,
  );
  
  static final TextStyle regular13W500 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.blackBase,
  );

  static final TextStyle regular14Roboto = GoogleFonts.roboto(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.white70,
  );

  static final TextStyle regular14Inter = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.grey,
  );
  static final TextStyle regular14InterW500 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.blackBase,
  );

  static final TextStyle regular16 = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.blackBase,
  );

  static final TextStyle medium16Roboto = GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.grey,
  );

  static final TextStyle medium16Inter = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.whiteBase,
  );
  static final TextStyle medium16InterUnderline = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.purpleBase,
    decoration: TextDecoration.underline,
  );

  static final TextStyle medium18Roboto = GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColors.grey,
  );

  static final TextStyle medium18Inter = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColors.blackBase,
  );

  static final TextStyle medium20 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.blackBase,
  );

  static final TextStyle semiBold12Underline = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.blackBase,
    decoration: TextDecoration.underline,
  );
}
