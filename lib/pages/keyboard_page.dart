import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cubit/keyboard_cubit.dart';

class KeyboardPage extends StatelessWidget {
  const KeyboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KeyboardCubit(),
      child: const _KeyboardPage(),
    );
  }
}

class _KeyboardPage extends HookWidget {
  const _KeyboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KeyboardCubit>();

    return Scaffold(
      appBar: AppBar(title: 'This is keyboard'.text.make()),
      body: VStack([
        Container().expand(),
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
            return cubit.keyController.text.center.size(28).make();
          },
        ).w(Get.width),
        SizedBox(height: 20),
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
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 20,
            ),
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
              Icon(
                Icons.backspace_outlined,
                size: 24,
              ).box.height(52).color(Colors.transparent).make().onTap(() {
                cubit.reduceNum();
              }).expand()
            ]).w(Get.width),
          ],
          crossAlignment: CrossAxisAlignment.center,
        ),
        const SizedBox(
          height: 30,
        ),
      ]),
    );
  }
}
