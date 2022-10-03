import 'package:face_auth/services/navigation_service.dart';
import 'package:face_auth/utils/colors.dart';
import 'package:face_auth/utils/customs/custom_dialog.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cubit/scanner_cubit.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScannerCubit(),
      child: const _ScannerScreen(),
    );
  }
}

class _ScannerScreen extends HookWidget {
  const _ScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScannerCubit>();

    late AnimationController controller;
    controller =
        useAnimationController(duration: const Duration(milliseconds: 7000))
          ..forward()
          ..addListener(() {
            if (controller.isCompleted) {
              controller.repeat();
            }
          });

    double animate(double value) =>
        1.5 * (0.5 - (0.5 - Curves.linear.transform(value)).abs());

    MobileScannerController cameraController = MobileScannerController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.surface,
        leading: BackButton(color: CustomColor.onSurface),
        elevation: 0,
        centerTitle: true,
        title: 'Pindai Code QR'.text.color(CustomColor.onSurface).make(),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return Icon(Boxicons.bx_bolt_circle,
                        size: 24, color: CustomColor.onSurface);
                  case TorchState.on:
                    return Icon(Boxicons.bxs_bolt_circle,
                        size: 24, color: CustomColor.onSurface);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: SafeArea(
        child: ZStack([
          BlocListener<ScannerCubit, ScannerState>(
            listener: (context, state) {
              if (state is ScannerSuccess) {
                GetIt.I<NavigationServiceMain>().pop(state.qrData);
              }
              if (state is ScannerFailed) {
                CustomDialog.showAlertDialog(context,
                    title: 'Konten digital tidak ditemukan',
                    body:
                        'Tidak ditemukan konten digital dari kode QR yang anda pindai, Coba untuk memindai kode QR lain',
                    cancelText: 'Kembali',
                    withoutYes: true, onCancel: () {
                  GetIt.I<NavigationServiceMain>().pop();
                  cameraController.start();
                }, onYes: () {});
              }
            },
            child: MobileScanner(
                allowDuplicates: false,
                controller: cameraController,
                onDetect: (barcode, args) async {
                  if (barcode.rawValue == null) {
                    debugPrint('Failed to scan Barcode');
                  } else {
                    cameraController.stop();
                    await cubit.processQrCode(barcode.rawValue!);
                  }
                }),
          ),
          VStack([
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, Get.height * animate(controller.value)),
                child: child,
              ),
              child: VxBox()
                  .width(Get.width)
                  .color(Colors.white)
                  .height(2)
                  .withShadow([
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    3.0,
                    0,
                  ),
                ),
              ]).make(),
            ),
            const SizedBox().expand(),
            'Pastikan kode QR anda terpindai di dalam area yang tersedia'
                .text
                .align(TextAlign.center)
                .textStyle(CustomTextStyle.bodyLarge)
                .make()
                .p24()
                .box
                .color(CustomColor.surface)
                .topRounded(value: 16)
                .make(),
          ]),
        ]),
      ),
    );
  }
}
