import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/colors.dart';
import '../utils/customs/custom_text_style.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.onClick,
    required this.buttonText,
    this.onClick2,
    this.button2Text,
    required this.imageWidth,
    required this.imageKey,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback onClick;
  final String buttonText;
  final VoidCallback? onClick2;
  final String? button2Text;
  final double imageWidth;
  final String imageKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: VxBox(
          child: VStack(
            [
              const Gap(8),
              Image.asset(
                imageKey,
                width: imageWidth,
                fit: BoxFit.contain,
              ),
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
              (button2Text == null) ? Container() : const Gap(8),
              (onClick2 == null || button2Text == null)
                  ? Container()
                  : button2Text!.text
                      .color(CustomColor.primary)
                      .textStyle(CustomTextStyle.labelLarge)
                      .make()
                      .pSymmetric(v: 10, h: 16)
                      .box
                      .color(Colors.transparent)
                      .make()
                      .onTap(() {
                      onClick2!.call();
                    }),
              const Gap(8),
            ],
            crossAlignment: CrossAxisAlignment.center,
          ).p24(),
        )
            // .withRounded(value: 28)
            // .color(CustomColor.surface2)
            // .make()
            // .box
            .withRounded(value: 28)
            .color(CustomColor.surface)
            .make());
  }
}
