import 'package:flutter/material.dart';
import 'package:gg_tv/styles.dart';

class MiscWidgets {
  static SnackBar baseSnackbar(
      {required String message, bool success = false, bool info = false}) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: (success || info) ? Colors.purple : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          if (success) Icon(Icons.check_rounded, color: Colors.white),
          if (info) Icon(Icons.info_outline_rounded, color: Colors.white),
          if (!success) Icon(Icons.warning_amber_rounded, color: Colors.white),
          Text(
            message,
            style: AppStyles.giga18Text.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
