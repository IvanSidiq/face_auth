import 'package:face_auth/utils/colors.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cubit/keyboard_cubit.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KeyboardCubit(),
      child: const _KeyboardWidget(),
    );
  }
}

class _KeyboardWidget extends HookWidget {
  const _KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KeyboardCubit>();

    return VStack([
      // Gap(20),
      // HStack(
      //   [
      //     VxBox()
      //         .height(4)
      //         .width(40)
      //         .color(const Color(0xFF45464F).withOpacity(0.12))
      //         .rounded
      //         .make(),
      //   ],
      //   alignment: MainAxisAlignment.center,
      // ).w(Get.width),
      const Gap(20),
      BlocConsumer<KeyboardCubit, KeyboardState>(
        listener: (context, state) {
          if (state is AddNum) {
            cubit.keyController = cubit.keyController + state.num;
          }
          if (state is ReduceNum) {
            if (cubit.keyController.isNotEmpty) {
              cubit.keyController = cubit.keyController
                  .substring(0, cubit.keyController.length - 1);
            }
          }
          if (state is ClearAll) {
            cubit.keyController = '';
          }
        },
        builder: (context, state) {
          if (cubit.keyController != '') {
            return cubit.keyController.text
                .textStyle(CustomTextStyle.headlineMedium)
                .center
                .size(28)
                .make()
                .px24();
          } else {
            return 'Masukkan NIS'
                .text
                .textStyle(CustomTextStyle.headlineMedium)
                .color(CustomColor.onSurfaceVariant.withOpacity(0.38))
                .center
                .size(28)
                .make();
          }
        },
      ).w(Get.width),
      const Gap(8),
      const Divider(
        thickness: 1,
        color: Colors.black12,
      ).px(24),
      const Gap(20),
      VStack(
        [
          HStack([
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('1');
                },
                child: '1'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('2');
                },
                child: '2'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('3');
                },
                child: '3'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
          ]).w(Get.width),
          HStack([
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('4');
                },
                child: '4'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('5');
                },
                child: '5'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('6');
                },
                child: '6'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
          ]).w(Get.width),
          HStack([
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('7');
                },
                child: '7'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('8');
                },
                child: '8'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('9');
                },
                child: '9'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
          ]).w(Get.width),
          HStack([
            InkWell(
              splashColor: CustomColor.onSurface.withOpacity(0.08),
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              onTap: () {},
              child: ' '.text.size(24).makeCentered().box.height(62).make(),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.addNum('0');
                },
                child: '0'.text.size(24).makeCentered().box.height(62).make(),
              ),
            ).expand(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: CustomColor.onSurface.withOpacity(0.08),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  cubit.reduceNum();
                },
                onLongPress: () {
                  cubit.clearAll();
                },
                child: Image.asset(
                  'assets/icons/delete_icon.png',
                  color: CustomColor.onSurface,
                  fit: BoxFit.contain,
                )
                    .box
                    .height(32)
                    .width(32)
                    .makeCentered()
                    .box
                    .height(62)
                    .color(Colors.transparent)
                    .make(),
              ),
            ).expand(),
          ]).w(Get.width),
        ],
        crossAlignment: CrossAxisAlignment.center,
      ).px(16),
    ]).box.color(CustomColor.surface).topRounded(value: 16).make();
  }
}
