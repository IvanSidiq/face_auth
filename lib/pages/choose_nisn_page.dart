import 'package:face_auth/utils/colors.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
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
      backgroundColor: CustomColor.surface,
      body: SafeArea(
        child: ZStack([
          VStack([
            HStack([
              const Gap(24), //TODO logo sekolah
              'Absensi SMA N 1 Surakarta'
                  .text
                  .textStyle(CustomTextStyle.titleMedium)
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
              const Gap(12),
              'Menampilkan 10 hasil pencarian NIS'
                  .text
                  .center
                  .textStyle(CustomTextStyle.labelSmall)
                  .color(CustomColor.onSurfaceVariant)
                  .size(11)
                  .semiBold
                  .make()
                  .pOnly(left: 8),
              const Gap(8),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final isChoosable = index % 2 == 0;
                    return HStack([
                      'A'
                          .text
                          .color(CustomColor.primary
                              .withOpacity(isChoosable ? 1 : 0.36))
                          .semiBold
                          .size(16)
                          .makeCentered()
                          .box
                          .width(32)
                          .height(32)
                          .color(CustomColor.primaryContainer
                              .withOpacity(isChoosable ? 1 : 0.36))
                          .withRounded(value: 32)
                          .make(),
                      const Gap(12),
                      VStack([
                        'Bondan Prakoso'
                            .text
                            .textStyle(CustomTextStyle.bodyMedium)
                            .color(CustomColor.onSurface
                                .withOpacity(isChoosable ? 1 : 0.36))
                            .make(),
                        const Gap(8),
                        '123456'
                            .text
                            .textStyle(CustomTextStyle.labelMedium)
                            .color(CustomColor.onSurfaceVariant
                                .withOpacity(isChoosable ? 0.6 : 0.36))
                            .make()
                      ]).expand(),
                      isChoosable
                          ? 'Pilih'
                              .text
                              .color(CustomColor.surface)
                              .textStyle(CustomTextStyle.labelSmall)
                              .makeCentered()
                              .pSymmetric(v: 4, h: 10)
                              .box
                              .color(CustomColor.primary
                                  .withOpacity(isChoosable ? 1 : 0.36))
                              .roundedLg
                              .make()
                          : 'Sudah hadir'
                              .text
                              .textStyle(CustomTextStyle.labelSmall)
                              .color(CustomColor.onSurface
                                  .withOpacity(isChoosable ? 0.52 : 0.36))
                              .makeCentered()
                              .pSymmetric(v: 4, h: 10)
                              .box
                              .color(CustomColor.onSurface.withOpacity(0.12))
                              .roundedLg
                              .make(),
                    ])
                        .box
                        .p12
                        .withRounded(value: 12)
                        .color(CustomColor.surface)
                        .make()
                        .pOnly(top: 4, bottom: 4);
                  }).w(Get.width)
            ])
                .scrollVertical(physics: const BouncingScrollPhysics())
                .box
                .withRounded(value: 16)
                .p8
                .color(CustomColor.surface3)
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
