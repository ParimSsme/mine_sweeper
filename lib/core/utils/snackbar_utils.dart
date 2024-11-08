import 'package:alerter/alerter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class SnackbarUtils {

  /// Display a success snackbar
  static void showSuccessSnackbar({
    String title = "Success",
    required String message,
  }) {
    final context = Get.context;
    if (context != null) {
      Alerter.show(
        context,
        title: title,
        message: message,
        backgroundColor: AppColors.success,
        iconColor: AppColors.onPrimary,
        textColor: AppColors.onPrimary,
        icon: Icons.check_circle,
        position: OverlayPosition.bottom,
      );
    }
  }

  /// Display an error snackbar
  static void showErrorSnackbar({
    String title = "Error",
    required String message,
  }) {
    final context = Get.context;
    if (context != null) {
      Alerter.show(
        context,
        title: title,
        message: message,
        backgroundColor: AppColors.error,
        iconColor: AppColors.onPrimary,
        textColor: AppColors.onPrimary,
        icon: Icons.cancel_rounded,
        position: OverlayPosition.bottom,
      );
    }
  }
}
