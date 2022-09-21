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
            VStack([
              Gap(12),
              'Menampilkan 10 hasil pencarian NIS'
                  .text
                  .center
                  .color(const Color(0xFF45464F))
                  .size(11)
                  .semiBold
                  .make()
                  .pOnly(left: 8),
              Gap(8),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return HStack([
                      'A'
                          .text
                          .makeCentered()
                          .box
                          .width(32)
                          .height(32)
                          .color(Color(0xFFDAE1FF))
                          .withRounded(value: 32)
                          .make(),
                      Gap(12),
                      VStack([
                        'Bondan Prakoso'.text.make(),
                        const Gap(8),
                        '123456'.text.make()
                      ]).expand(),
                      index % 2 == 0
                          ? 'Pilih'
                              .text
                              .white
                              .makeCentered()
                              .pSymmetric(v: 4, h: 10)
                              .box
                              .color(Color(0xFF2155CF))
                              .roundedLg
                              .make()
                          : 'Sudah hadir'
                              .text
                              .color(Color(0xFF1B1B1F).withOpacity(0.52))
                              .makeCentered()
                              .pSymmetric(v: 4, h: 10)
                              .box
                              .color(Color(0xFF1B1B1F).withOpacity(0.12))
                              .roundedLg
                              .make(),
                    ])
                        .box
                        .p12
                        .withRounded(value: 12)
                        .color(Colors.white)
                        .make()
                        .pOnly(top: 4, bottom: 4);
                  }).w(Get.width)
            ])
                .scrollVertical(physics: const BouncingScrollPhysics())
                .box
                .withRounded(value: 16)
                .p8
                .color(const Color(0xFF2155CF).withOpacity(0.11))
                .make()
                .px(8)
                .expand(),
            const KeyboardWidget(),
            // .box
            // .withShadow([
            //   const BoxShadow(
            //       offset: Offset(0, -4),
            //       blurRadius: 16,
            //       spreadRadius: 0,
            //       color: Color(0x1E000000))
            // ])
            // .make(),
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
