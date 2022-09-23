import 'package:face_auth/services/navigation_service.dart';
import 'package:face_auth/utils/colors.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomAlertWidget extends StatelessWidget {
  const CustomAlertWidget({
    Key? key,
    required this.title,
    required this.body,
    this.onCancel,
    required this.onYes,
    this.cancelText = 'Cancel',
    this.yesText = 'Yes',
    this.withoutYes = false,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback? onCancel;
  final VoidCallback onYes;
  final String? cancelText;
  final String? yesText;
  final bool? withoutYes;

  @override
  Widget build(BuildContext context) {
    VoidCallback cancel;
    if (onCancel == null) {
      cancel = () {
        GetIt.I<NavigationServiceMain>().pop();
      };
    } else {
      cancel = onCancel!;
    }
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: VxBox(
          child: VStack([
            title.text.textStyle(CustomTextStyle.headlineSmall).make(),
            const Gap(16),
            body.text.textStyle(CustomTextStyle.bodyMedium).make(),
            const Gap(24),
            HStack(
              [
                const SizedBox().expand(),
                cancelText!.text
                    .color(CustomColor.primary)
                    .textStyle(CustomTextStyle.labelLarge)
                    .make()
                    .pSymmetric(v: 10, h: 16)
                    .box
                    .color(Colors.transparent)
                    .make()
                    .onTap(cancel),
                withoutYes! ? Container() : const Gap(8),
                withoutYes!
                    ? Container()
                    : yesText!.text
                        .color(CustomColor.primary)
                        .textStyle(CustomTextStyle.labelLarge)
                        .make()
                        .pSymmetric(v: 10, h: 16)
                        .box
                        .color(Colors.transparent)
                        .make()
                        .onTap(onYes),
              ],
            ),
          ]).p24(),
        )
            .withRounded(value: 28)
            .color(CustomColor.surface2)
            .make()
            .box
            .withRounded(value: 28)
            .color(CustomColor.surface)
            .make());
  }
}
