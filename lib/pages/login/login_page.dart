import 'package:boxicons/boxicons.dart';
import 'package:face_auth/pages/login/cubit/login_cubit.dart';
import 'package:face_auth/pages/login/cubit/validator_cubit.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/navigation_service.dart';
import '../../utils/colors.dart';
import 'cubit/button_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ValidatorCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => ButtonCubit(),
        ),
      ],
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends HookWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vCubit = context.read<ValidatorCubit>();
    final bCubit = context.read<ButtonCubit>();
    final cubit = context.read<LoginCubit>();

    final emailC = useTextEditingController();
    final passwordC = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: VStack(
          [
            VStack([
              const Gap(52),
              Image.asset(
                'assets/icons/icon.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const Gap(44),
              'Selamat Datang'
                  .text
                  .textStyle(CustomTextStyle.titleLarge)
                  .make(),
              const Gap(12),
              'Masukkan email dan kata sandi untuk melanjutkan'
                  .text
                  .textStyle(CustomTextStyle.bodyMedium)
                  .make(),
              const Gap(32),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginFailed) {
                    return HStack(
                      [
                        const Gap(2),
                        Icon(
                          Icons.error_outline,
                          color: CustomColor.error,
                          size: 20,
                        ),
                        const Gap(12),
                        Expanded(
                          child:
                              'Email atau kata sandi yang Anda masukkan salah.'
                                  .text
                                  .color(CustomColor.error)
                                  .textStyle(CustomTextStyle.bodyMedium)
                                  .make()
                                  .pOnly(top: 4, right: 16),
                        ),
                      ],
                      alignment: MainAxisAlignment.center,
                      crossAlignment: CrossAxisAlignment.center,
                    ).pOnly(bottom: 32);
                  }
                  if (state is LoginSuccess) {
                    GetIt.I<NavigationServiceMain>()
                        .pushReplacementNamed('/choose_nisn');
                  }
                  return const Gap(8);
                },
              ),
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

                      if (emailC.text.isNotEmptyAndNotNull &&
                          passwordC.text.isNotEmptyAndNotNull) {
                        bCubit.changeButtonState(true);
                      } else {
                        bCubit.changeButtonState(false);
                      }
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
              const Gap(24),
              BlocConsumer<ValidatorCubit, ValidatorState>(
                listener: (context, state) {
                  if (state is ObstructChanged) {
                    vCubit.obscureText = !vCubit.obscureText;
                  }
                  if (state is ValidateEmail) {
                    if (state.emailIsValid) {
                      cubit.login(emailC.text, passwordC.text);
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
                    onChanged: (value) {
                      if (emailC.text.isNotEmptyAndNotNull &&
                          passwordC.text.isNotEmptyAndNotNull) {
                        bCubit.changeButtonState(true);
                      } else {
                        bCubit.changeButtonState(false);
                      }
                    },
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
            ]).px24().scrollVertical().expand(),
            BlocConsumer<ButtonCubit, ButtonState>(
              listener: (context, state) {
                if (state is ChangeButtonState) {
                  if (state.value) {
                    vCubit.isLoginable = true;
                    vCubit.backgroundButtonColor = CustomColor.primary;
                    vCubit.textButtonColor = CustomColor.onPrimary;
                  } else {
                    vCubit.isLoginable = false;
                    vCubit.backgroundButtonColor =
                        CustomColor.onSurface.withOpacity(0.12);
                    vCubit.textButtonColor =
                        CustomColor.onSurface.withOpacity(0.52);
                  }
                }
              },
              builder: (context, state) {
                return BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return CircularProgressIndicator(
                        color: CustomColor.onSurface.withOpacity(0.38),
                        strokeWidth: 2,
                      )
                          .w(18)
                          .h(18)
                          .centered()
                          .py(10)
                          .box
                          .color(CustomColor.onSurface.withOpacity(0.12))
                          .withRounded(value: 100)
                          .height(40)
                          .width(Get.width)
                          .make()
                          .px24();
                    }
                    return GestureDetector(
                      onTap: () {
                        if (vCubit.isLoginable) {
                          vCubit.validateEmail(emailC.text);
                        }
                      },
                      child: 'Masuk'
                          .text
                          .color(vCubit.textButtonColor)
                          .textStyle(CustomTextStyle.labelLarge)
                          .makeCentered()
                          .py(10)
                          .box
                          .color(vCubit.backgroundButtonColor)
                          .withRounded(value: 100)
                          .height(40)
                          .width(Get.width)
                          .make()
                          .px24(),
                    );
                  },
                );
              },
            ),
            const Gap(24),
          ],
          crossAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
