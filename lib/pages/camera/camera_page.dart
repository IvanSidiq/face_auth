import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:face_auth/pages/camera/cubit/face_attendance_cubit.dart';
import 'package:face_auth/pages/camera/cubit/remote_config_cubit.dart';
import 'package:face_auth/services/navigation_service.dart';
import 'package:face_auth/utils/customs/custom_dialog.dart';
import 'package:face_auth/widgets/camera_widget.dart';
import 'package:face_auth/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../../utils/customs/custom_text_style.dart';
import 'cubit/camera_cubit.dart';

part 'camera_widget.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CameraCubit(),
        ),
        BlocProvider(
          create: (context) => FaceAttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => RemoteConfigCubit(),
        )
      ],
      child: _CameraPage(userId: userId),
    );
  }
}

class _CameraPage extends HookWidget {
  const _CameraPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCubit>();
    final fCubit = context.read<FaceAttendanceCubit>();
    final tCubit = context.read<RemoteConfigCubit>();

    useEffect(() {
      cubit.initCamera();
      fCubit.getAttendanceData(userId);
      fCubit.getAttendanceFace(userId);
      tCubit.initGetThreshold();
      return;
    }, [cubit]);

    return WillPopScope(
      onWillPop: () async {
        cubit.dispose();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<RemoteConfigCubit, RemoteConfigState>(
            listener: (context, state) {
              if (state is GetThresholdSuccess) {
                tCubit.threshold = state.threshold;
              }
            },
            child: Material(
              child: Stack(
                children: [
                  _CameraWidget(),
                  // Positioned(
                  //     top: 0,
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           color: CustomColor.surface,
                  //           width: Get.width,
                  //           height: 68,
                  //         ),
                  //         Gap(Get.width),
                  //         Container(
                  //           color: CustomColor.surface,
                  //           width: Get.width,
                  //           height: Get.height,
                  //         ),
                  //       ],
                  //     )),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(CustomColor.surface,
                        BlendMode.srcOut), // This one will create the magic
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              backgroundBlendMode: BlendMode
                                  .dstOut), // This one will handle background + difference out
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            height: Get.width - 64,
                            width: Get.width - 64,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(Get.width),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //     top: 95,
                  //     left: 60,
                  //     child: Container(
                  //       color: CustomColor.primary,
                  //       width: 100,
                  //       height: 105,
                  //     )),
                  Positioned(
                    top: 0,
                    child: VStack(
                      [
                        const Gap(32),
                        HStack([
                          const Gap(24),
                          Icon(
                            Boxicons.bx_x,
                            size: 24,
                            color: CustomColor.onSurface,
                          )
                              .p(6)
                              .box
                              .border(color: CustomColor.surface, width: 2)
                              .withRounded(value: 12)
                              .make()
                              .onTap(() {
                            cubit.dispose();
                            GetIt.I<NavigationServiceMain>().pop();
                          }),
                          'Verifikasi Wajah'
                              .text
                              .textStyle(CustomTextStyle.titleLarge)
                              .color(Colors.white)
                              .makeCentered()
                              .expand(),
                          const Icon(
                            Boxicons.bx_x,
                            size: 24,
                            color: Colors.transparent,
                          )
                              .box
                              .p8
                              .border(color: Colors.transparent, width: 2)
                              .withRounded(value: 12)
                              .make(),
                          const Gap(24),
                        ]),
                        const Gap(425),
                        BlocBuilder<CameraCubit, CameraState>(
                          builder: (context, state) {
                            return cubit.message2.text.center
                                .textStyle(CustomTextStyle.labelLarge)
                                .color(CustomColor.onSurfaceVariant)
                                .make()
                                .pSymmetric(h: 36);
                          },
                        ),
                        const Gap(28),
                        BlocBuilder<CameraCubit, CameraState>(
                          builder: (context, state) {
                            if (cubit.withErrorCircle) {
                              return HStack([
                                const Gap(2),
                                Icon(
                                  Boxicons.bx_error_circle,
                                  size: 20,
                                  color: CustomColor.onErrorContainer,
                                ),
                                const Gap(8),
                                cubit.message.text
                                    .textStyle(CustomTextStyle.labelLarge)
                                    .color(CustomColor.onErrorContainer)
                                    .make(),
                                const Gap(6)
                              ])
                                  .p(6)
                                  .box
                                  .color(CustomColor.errorContainer)
                                  .withRounded(value: 100)
                                  .make();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ).w(Get.width),
                  ),
                  Positioned(
                    top: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        VxBox()
                            .border(
                                color: CustomColor.onSurface.withOpacity(0.5),
                                width: 2)
                            .withRounded(value: Get.width - 64)
                            .width(Get.width - 64)
                            .height(Get.width - 64)
                            .make(),
                      ],
                    ).w(Get.width),
                  ),
                  Positioned(
                    top: 103,
                    child: BlocBuilder<CameraCubit, CameraState>(
                      builder: (context, state) {
                        if (cubit.captValue != 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 6,
                                value: cubit.captValue,
                                color: CustomColor.primary,
                              )
                                  .box
                                  .width(Get.width - 70)
                                  .height(Get.width - 70)
                                  .make(),
                            ],
                          ).w(Get.width);
                        }
                        return Container();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child:
                        BlocConsumer<FaceAttendanceCubit, FaceAttendanceState>(
                      listener: (context, state) {
                        if (state is GetAttendanceDataSuccess) {
                          fCubit.name = state.attendance.name;
                          fCubit.nis = state.attendance.nis;
                          fCubit.attendanceId = state.attendance.id;
                          fCubit.dateId = state.attendance.dateId;
                          // print(fCubit.name);
                          // print(fCubit.nis);
                        }
                        if (state is GetAttendanceFaceDataSuccess) {
                          if (state.face.vector != null) {
                            fCubit.faceVector = state.face.vector!;
                            cubit.faceVector = state.face.vector!;
                          }
                        }
                        if (state is GetAttendanceDataFailed) {
                          cubit.dispose();
                          GetIt.I<NavigationServiceMain>().pop();
                          CustomDialog.showImageDialog(context,
                              title: 'Kode QR tidak ditemukan',
                              body:
                                  'Pastikan kode QR yang dipindai sudah benar. Silakan coba lagi atau gunakan NIS untuk melanjutkan presensi.',
                              buttonText: 'Pindai ulang',
                              onClick: () {
                                GetIt.I<NavigationServiceMain>()
                                    .pushNamed('/scanner')!
                                    .then((value) {
                                  if (value != null) {
                                    GetIt.I<NavigationServiceMain>().pushNamed(
                                        '/camera',
                                        args: {'userId': value});
                                  }
                                });
                              },
                              button2Text: 'Gunakan NIS',
                              onClick2: () {
                                GetIt.I<NavigationServiceMain>().pop();
                              },
                              imageWidth: 120,
                              imageKey: 'assets/images/not_found.png');
                        }
                        if (state is AttendingAttendanceSuccess) {
                          if (state.isForced) {
                            CustomDialog.showImageDialog(
                              context,
                              barrierDismissible: false,
                              title: 'Verifikasi gagal',
                              body:
                                  'Anda telah 3 kali gagal melakukan verifikasi wajah. Gambar wajah terakhir akan dikirimkan sebagai bukti presensi.',
                              buttonText: 'Kembali ke halaman utama',
                              onClick: () {
                                GetIt.I<NavigationServiceMain>().pop();
                                cubit.dispose();
                                GetIt.I<NavigationServiceMain>().pop();
                              },
                              imageWidth: 120,
                              imageKey: 'assets/images/scan_failed.png',
                            );
                          } else {
                            CustomDialog.showAnimationDialog(
                              context,
                              barrierDismissible: false,
                              title: 'Verifikasi berhasil',
                              body:
                                  'Verifikasi wajah anda berhasil, terimakasih sudah melakukan absensi hari ini',
                              buttonText: 'Kembali ke halaman utama',
                              onClick: () {
                                GetIt.I<NavigationServiceMain>().pop();
                                cubit.dispose();
                                GetIt.I<NavigationServiceMain>().pop();
                              },
                              animationWidth: 260,
                              animationKey:
                                  'assets/animations/check_animation.json',
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is GetAttendanceDataLoading) {
                          return const VStack(
                            [
                              CustomLoadingWidget(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          )
                              .p24()
                              .box
                              .color(CustomColor.surface)
                              .topRounded(value: 16)
                              .make()
                              .w(Get.width);
                        }
                        return VStack(
                          [
                            fCubit.name.text
                                .align(TextAlign.center)
                                .textStyle(CustomTextStyle.titleMedium)
                                .make(),
                            const Gap(8),
                            fCubit.nis.text
                                .align(TextAlign.center)
                                .textStyle(CustomTextStyle.bodyMedium)
                                .make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        )
                            .p24()
                            .box
                            .color(CustomColor.surface1)
                            .border(
                                color: CustomColor.onSurfaceVariant
                                    .withOpacity(0.12))
                            .withRounded(value: 16)
                            .make()
                            .p16()
                            .w(Get.width);
                      },
                    ),
                  ),
                ],
              ).backgroundColor(CustomColor.surface).w(Get.width).h(Get.height),
            ),
          ),
        ),
      ),
    );
  }
}
