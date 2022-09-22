import 'package:boxicons/boxicons.dart';
import 'package:face_auth/pages/login/cubit/validator_cubit.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidatorCubit(),
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends HookWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vCubit = context.read<ValidatorCubit>();

    final emailC = useTextEditingController();
    final passwordC = useTextEditingController();

    return Scaffold(
      body: VStack(
        [
          const VStack([]).expand(),
          VStack([
            'Selamat Datang'
                .text
                .textStyle(CustomTextStyle.titleLarge)
                .makeCentered()
                .w(Get.width),
            const Gap(12),
            'Masukkan email dan kata sandi untuk melanjutkan'
                .text
                .textStyle(CustomTextStyle.bodyMedium)
                .makeCentered()
                .w(Get.width),
            const Gap(32),
            BlocBuilder<ValidatorCubit, ValidatorState>(
              builder: (context, state) {
                return TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    vCubit.showEmailNotValid = false;
                    vCubit.borderColor = CustomColor.primary;
                    vCubit.textColor = value.isEmptyOrNull
                        ? CustomColor.onSecondaryContainer
                        : CustomColor.primary;

                    vCubit.validateChangeState();
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: vCubit.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: vCubit.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: vCubit.textColor)),
                );
              },
            ),
            BlocBuilder<ValidatorCubit, ValidatorState>(
              builder: (context, state) {
                if (vCubit.showEmailNotValid) {
                  return 'Email tidak valid'
                      .text
                      .color(CustomColor.error)
                      .textStyle(CustomTextStyle.bodyMedium)
                      .make()
                      .pOnly(left: 12);
                }
                return Container();
              },
            ),
            const Gap(12),
            BlocConsumer<ValidatorCubit, ValidatorState>(
              listener: (context, state) {
                if (state is ObstructChanged) {
                  vCubit.obscureText = !vCubit.obscureText;
                }
                if (state is ValidateEmail) {
                  if (state.emailIsValid) {
                    //TODO login
                  } else {
                    vCubit.showEmailNotValid = true;
                    vCubit.borderColor = CustomColor.error;
                    vCubit.textColor = CustomColor.error;
                  }
                }
              },
              builder: (context, state) {
                return TextField(
                  controller: passwordC,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: vCubit.obscureText,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(
                      vCubit.obscureText
                          ? Boxicons.bxs_show
                          : Boxicons.bxs_hide,
                      color: CustomColor.onSurfaceVariant,
                    ).onTap(() {
                      vCubit.obscureChange();
                    }),
                    labelText: 'Password',
                  ),
                );
              },
            ),
          ]).px24(),
          const Gap(32),
          'Masuk'
              .text
              .color(CustomColor.surface)
              .textStyle(CustomTextStyle.labelLarge)
              .makeCentered()
              .py(10)
              .box
              .color(CustomColor.primary)
              .withRounded(value: 100)
              .height(40)
              .width(Get.width)
              .make()
              .onTap(() {
            vCubit.validateEmail(emailC.text);
          }).px24(),
          const Gap(24),
        ],
        crossAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
