import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/colors.dart';
import '../utils/customs/custom_text_style.dart';

class CustomAnimationDialogWidget extends StatelessWidget {
  const CustomAnimationDialogWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.onClick,
    required this.buttonText,
    required this.animationWidth,
    required this.animationKey,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback onClick;
  final String buttonText;
  final double animationWidth;
  final String animationKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: WillPopScope(
          onWillPop: () async => false,
          child: VxBox(
            child: VStack(
              [
                const Gap(8),
                Lottie.asset(animationKey,
                    repeat: false, width: animationWidth, fit: BoxFit.contain),
                const Gap(24),
                title.text
                    .align(TextAlign.center)
                    .textStyle(CustomTextStyle.headlineSmall)
                    .make(),
                const Gap(16),
                body.text
                    .align(TextAlign.center)
                    .textStyle(CustomTextStyle.bodyMedium)
                    .color(CustomColor.onSurfaceVariant)
                    .make(),
                const Gap(24),
                buttonText.text
                    .color(CustomColor.onPrimary)
                    .textStyle(CustomTextStyle.labelLarge)
                    .makeCentered()
                    .box
                    .px16
                    .color(CustomColor.primary)
                    .height(40)
                    .width(Get.width)
                    .withRounded(value: 40)
                    .make()
                    .onTap(() {
                  onClick.call();
                }),
                const Gap(8),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).p24(),
          ).withRounded(value: 28).color(CustomColor.surface).make(),
        ));
  }
}
