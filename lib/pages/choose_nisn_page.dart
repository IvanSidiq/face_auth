import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'keyboard_widget.dart';

class ChooseNisnPage extends StatelessWidget {
  const ChooseNisnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBFF),
      body: SafeArea(
        child: ZStack([
          VStack([
            HStack([
              Gap(24), //TODO logo sekolah
              'Absensi SMA N 1 Surakarta'
                  .text
                  .center
                  .size(16)
                  .semiBold
                  .make()
                  .expand(),
              Image.asset(
                'assets/icons/icon.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ]).p16(),
            ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return VStack([
                        'Bondan Prakoso'.text.make(),
                        const Gap(8),
                        '123456'.text.make()
                      ])
                          .box
                          .p12
                          .withRounded(value: 8)
                          .color(Colors.white)
                          .border(color: Colors.black12)
                          .make()
                          .pOnly(top: 4, bottom: 4);
                    })
                .w(Get.width)
                .box
                .withRounded(value: 16)
                .p8
                .color(const Color(0xFF2155CF).withOpacity(0.11))
                .make()
                .px(8)
                .expand(),
            const KeyboardWidget()
                .box
                // .withShadow([
                //   const BoxShadow(
                //       offset: Offset(0, -4),
                //       blurRadius: 16,
                //       spreadRadius: 0,
                //       color: Color(0x1E000000))
                // ])
                .make(),
          ]),
          // DraggableScrollableSheet(
          //   maxChildSize: 0.55,
          //   minChildSize: 120 / Get.height,
          //   initialChildSize: 120 / Get.height,
          //   snap: true,
          //   builder: (BuildContext context, ScrollController scrollController) {
          //     return SingleChildScrollView(
          //         controller: scrollController,
          //         child: const KeyboardWidget()
          //             .box
          //             .withShadow([
          //               const BoxShadow(
          //                   offset: Offset(0, -4),
          //                   blurRadius: 16,
          //                   spreadRadius: 0,
          //                   color: Color(0x1E000000))
          //             ])
          //             .make()
          //             .pOnly(top: 20));
          //   },
          // ),
        ]),
      ),
    );
  }
}
