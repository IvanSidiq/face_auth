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
        },
        builder: (context, state) {
          if (cubit.keyController != '') {
            return cubit.keyController.text.center.size(28).make();
          } else {
            return 'NISN'.text.color(Colors.black26).center.size(28).make();
          }
        },
      ).w(Get.width),
      const Gap(8),
      const Divider(
        thickness: 1,
        color: Colors.black12,
      ).px(16),
      const Gap(20),
      VStack(
        [
          HStack([
            '1'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('1');
            }).expand(),
            '2'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('2');
            }).expand(),
            '3'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('3');
            }).expand()
          ]).w(Get.width),
          const Gap(20),
          HStack([
            '4'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('4');
            }).expand(),
            '5'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('5');
            }).expand(),
            '6'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('6');
            }).expand()
          ]).w(Get.width),
          const Gap(20),
          HStack([
            '7'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('7');
            }).expand(),
            '8'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('8');
            }).expand(),
            '9'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('9');
            }).expand()
          ]).w(Get.width),
          const Gap(20),
          HStack([
            ' '
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {})
                .expand(),
            '0'
                .text
                .size(24)
                .makeCentered()
                .box
                .height(52)
                .color(Colors.transparent)
                .make()
                .onTap(() {
              cubit.addNum('0');
            }).expand(),
            const Icon(
              Icons.backspace_outlined,
              size: 24,
            ).box.height(52).color(Colors.transparent).make().onTap(() {
              cubit.reduceNum();
            }).expand()
          ]).w(Get.width),
        ],
        crossAlignment: CrossAxisAlignment.center,
      ),
      const Gap(30),
    ]).box.color(Colors.white).topRounded(value: 16).make();
  }
}
