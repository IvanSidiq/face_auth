import 'package:boxicons/boxicons.dart';
import 'package:face_auth/pages/login/cubit/validator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../../utils/customs/custom_text_style.dart';

class CustomImage2Widget extends StatelessWidget {
  const CustomImage2Widget({
    Key? key,
    required this.title,
    required this.body,
    required this.onClick,
    required this.buttonText,
    required this.imageWidth,
    required this.imageKey,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback onClick;
  final String buttonText;
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
                  .color(CustomColor.error)
                  .textStyle(CustomTextStyle.labelLarge)
                  .makeCentered()
                  .box
                  .px16
                  .color(CustomColor.surface)
                  .border(color: CustomColor.onSurfaceVariant.withOpacity(0.64))
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

class CustomImage3Widget extends StatelessWidget {
  const CustomImage3Widget({
    Key? key,
    required this.title,
    required this.body,
    required this.onClick,
    required this.buttonText,
    required this.imageWidth,
    required this.imageKey,
    required this.controller,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback onClick;
  final String buttonText;
  final double imageWidth;
  final String imageKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidatorCubit(),
      child: _CustomImage3Widget(
        title: title,
        body: body,
        onClick: onClick,
        buttonText: buttonText,
        imageKey: imageKey,
        imageWidth: imageWidth,
        controller: controller,
      ),
    );
  }
}

class _CustomImage3Widget extends StatelessWidget {
  const _CustomImage3Widget({
    Key? key,
    required this.title,
    required this.body,
    required this.onClick,
    required this.buttonText,
    required this.imageWidth,
    required this.imageKey,
    required this.controller,
  }) : super(key: key);
  final String title;
  final String body;
  final VoidCallback onClick;
  final String buttonText;
  final double imageWidth;
  final String imageKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final vCubit = context.read<ValidatorCubit>();

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
              BlocConsumer<ValidatorCubit, ValidatorState>(
                listener: (context, state) {
                  if (state is ObstructChanged) {
                    vCubit.obscureText = !(vCubit.obscureText);
                  }
                },
                builder: (context, state) {
                  return TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: vCubit.obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: Icon(
                        vCubit.obscureText
                            ? Boxicons.bx_show
                            : Boxicons.bx_hide,
                        color: CustomColor.onSurfaceVariant,
                      ).onTap(() {
                        vCubit.obscureChange();
                      }),
                      labelText: 'Password',
                    ),
                  );
                },
              ),
              const Gap(24),
              buttonText.text
                  .color(CustomColor.error)
                  .textStyle(CustomTextStyle.labelLarge)
                  .makeCentered()
                  .box
                  .px16
                  .color(CustomColor.surface)
                  .border(color: CustomColor.onSurfaceVariant.withOpacity(0.64))
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
