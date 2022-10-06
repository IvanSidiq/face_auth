import 'package:flutter/material.dart';

import '../../widgets/custom_alert_widget.dart';
import '../../widgets/custom_animation_dialog_widget.dart';
import '../../widgets/custom_image_dialog_widget.dart';
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

  static void showAnimationDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String buttonText,
    required VoidCallback onClick,
    required double animationWidth,
    required String animationKey,
    bool barrierDismissible = false,
  }) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return CustomAnimationDialogWidget(
            title: title,
            body: body,
            buttonText: buttonText,
            onClick: onClick,
            animationKey: animationKey,
            animationWidth: animationWidth,
          );
        });
  }

  static void showImageDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String buttonText,
    required VoidCallback onClick,
    String? button2Text,
    VoidCallback? onClick2,
    required double imageWidth,
    required String imageKey,
    bool barrierDismissible = false,
  }) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return CustomImageWidget(
            title: title,
            body: body,
            buttonText: buttonText,
            onClick: onClick,
            button2Text: button2Text,
            onClick2: onClick2,
            imageKey: imageKey,
            imageWidth: imageWidth,
          );
        });
  }
}
