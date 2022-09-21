import 'package:boxicons/boxicons.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Email',
              ),
            ),
            const Gap(12),
            TextField(
              controller: passwordC,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(
                  Boxicons.bxs_show,
                  // obscure1 ? Boxicons.bxs_hide : Boxicons.bxs_show,
                  color: CustomColor.onSurfaceVariant,
                ).onTap(() {
                  // oCubit.obscure1();
                }),
                labelText: 'Password',
              ),
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
              .px24(),
          const Gap(24),
        ],
        crossAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
