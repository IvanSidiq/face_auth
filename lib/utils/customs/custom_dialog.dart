import 'package:flutter/material.dart';

import '../../widgets/custom_alert_widget.dart';
import '../../widgets/custom_loading_dialog_widget.dart';

class CustomDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const CustomLoadingDialogWidget();
        });
  }

  static void showAlertDialog(
    BuildContext context, {
    required String title,
    required String body,
    String? cancelText,
    String? yesText,
    VoidCallback? onCancel,
    bool? withoutYes,
    required VoidCallback onYes,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertWidget(
            title: title,
            body: body,
            cancelText: cancelText,
            yesText: yesText,
            onYes: onYes,
            onCancel: onCancel,
            withoutYes: withoutYes,
          );
        });
  }
}
