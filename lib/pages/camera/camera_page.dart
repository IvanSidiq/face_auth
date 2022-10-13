import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:face_auth/pages/camera/cubit/face_attendance_cubit.dart';
import 'package:face_auth/pages/camera/cubit/remote_config_cubit.dart';
import 'package:face_auth/services/navigation_service.dart';
import 'package:face_auth/utils/customs/custom_dialog.dart';
import 'package:face_auth/utils/customs/custom_toast.dart';
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
import '../../widgets/face_painter.dart';
import 'cubit/camera_cubit.dart';

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
                  BlocConsumer<CameraCubit, CameraState>(
                    listener: (context, state) {
                      if (state is TfliteDataSuccess) {
                        cubit.withErrorCircle = true;
                        cubit.message = 'Wajah tidak ditemukan';
                        cubit.message2 =
                            'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker';
                        cubit.tfliteData = state.data;
                        if (cubit.tfliteData != null &&
                            cubit.faceVector != null) {
                          cubit.calculateDist();
                        }
                      }
                      if (state is CameraInitialized) {
                        cubit.isInitialized = true;
                      }
                      if (state is ImageProcessed) {
                        cubit.imagePath = state.croppedPath;
                        cubit.detectedFacePaint = cubit.detectedFace;
                        cubit.withErrorCircle = false;
                        cubit.message = 'Proses pemindaian wajah..';
                        cubit.message2 =
                            'Pertahankan posisi wajah anda hingga waktu pemindaian berakhir';
                      }
                      if (state is InitializeInterpreterSuccess) {
                        cubit.interpreter = state.interpreter;
                      }
                      if (state is NoFaceDetected) {
                        cubit.detectedFacePaint = null;
                        cubit.withErrorCircle = true;
                        cubit.message = 'Wajah tidak ditemukan';
                        cubit.message2 =
                            'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker';
                      }
                      if (state is FaceDetectedBut) {
                        cubit.detectedFacePaint = cubit.detectedFace;
                        cubit.withErrorCircle = true;
                        cubit.message = state.message;
                        cubit.message2 = state.message2;
                        if (cubit.timer == null) {
                          cubit.streamFaceReader();
                        } else {
                          if (!cubit.timer!.isActive) cubit.streamFaceReader();
                        }
                      }
                      if (state is ChangeCaptTimerValue) {
                        cubit.captValue = state.captValue;
                        if (cubit.captValue >= 1) {
                          cubit.captTimer!.cancel();
                          cubit.captValue = 0;
                          cubit.processImage(realProcess: true);
                        }
                      }
                      if (state is CalculateDistance) {
                        if (state.similarity < tCubit.threshold) {
                          if (cubit.faceCounter < 2) {
                            CustomDialog.showImageDialog(
                              context,
                              barrierDismissible: true,
                              title: 'Pemindaian gagal',
                              body:
                                  'Pemindaian wajah gagal. Anda memiliki ${2 - cubit.faceCounter} kesempatan tersisa untuk melakukan verifikasi wajah',
                              buttonText: 'Pindai Ulang',
                              onClick: () {
                                GetIt.I<NavigationServiceMain>().pop();
                                if (cubit.timer == null) {
                                  cubit.streamFaceReader();
                                } else {
                                  if (!cubit.timer!.isActive) {
                                    cubit.streamFaceReader();
                                  }
                                }
                              },
                              imageWidth: 120,
                              imageKey: 'assets/images/scan_failed.png',
                            );

                            cubit.faceCounter = cubit.faceCounter + 1;
                          } else {
                            fCubit.attendingAttendance(
                              similarityC: state.dist,
                              attendanceId: fCubit.attendanceId,
                              dateId: fCubit.dateId,
                              faceFile: File(cubit.croppedPath),
                            );
                            CustomDialog.showImageDialog(
                              context,
                              barrierDismissible: true,
                              title: 'Verifikasi gagal',
                              body:
                                  'Anda telah 3 kali gagal melakukan verifikasi wajah. Gambar wajah terakhir akan dikirimkan sebagai bukti presensi.',
                              buttonText: 'Kembali ke halaman utama',
                              onClick: () {
                                GetIt.I<NavigationServiceMain>().pop();
                                GetIt.I<NavigationServiceMain>().pop();
                              },
                              imageWidth: 120,
                              imageKey: 'assets/images/scan_failed.png',
                            );

                            cubit.faceCounter = cubit.faceCounter + 1;
                          }
                          // ulang
                        } else {
                          // sukses
                          fCubit.attendingAttendance(
                            similarityC: state.dist,
                            attendanceId: fCubit.attendanceId,
                            dateId: fCubit.dateId,
                            faceFile: File(cubit.croppedPath),
                          );
                          CustomDialog.showAnimationDialog(
                            context,
                            barrierDismissible: true,
                            title: 'Verifikasi berhasil',
                            body:
                                'Verifikasi wajah anda berhasil, terimakasih sudah melakukan absensi hari ini',
                            buttonText: 'Kembali ke halaman utama',
                            onClick: () {
                              GetIt.I<NavigationServiceMain>().pop();
                              GetIt.I<NavigationServiceMain>().pop();
                              //Change to next shit
                              // if (cubit.timer == null) {
                              //   cubit.streamFaceReader();
                              // } else {
                              //   if (!cubit.timer!.isActive) {
                              //     cubit.streamFaceReader();
                              //   }
                              // }
                            },
                            animationWidth: 260,
                            animationKey:
                                'assets/animations/check_animation.json',
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      final size = Get.size;
                      final deviceRatio = size.width / size.height;
                      return CameraWidget(
                        cameraService: cubit.cameraService,
                        isCameraInitialized: cubit.isInitialized,
                        deviceRatio: deviceRatio,
                      );
                      // BlocBuilder<CameraCubit, CameraState>(
                      //   builder: (context, state) {
                      //     if (cubit.detectedFacePaint == null) {
                      //       return Container(
                      //         width: 50,
                      //         height: 50,
                      //         color: CustomColor.primary,
                      //       );
                      //     } else {
                      //       return CustomPaint(
                      //         painter: FacePainter(
                      //           face: cubit.detectedFacePaint!,
                      //           imageSize: Size(
                      //             MediaQuery.of(context).size.width,
                      //             (MediaQuery.of(context).size.height),
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     return Container();
                      //   },
                      // ),
                    },
                  ),
                  Positioned(
                      top: 0,
                      child: Column(
                        children: [
                          Container(
                            color: CustomColor.surface,
                            width: Get.width,
                            height: 68,
                          ),
                          Gap(Get.width),
                          Container(
                            color: CustomColor.surface,
                            width: Get.width,
                            height: Get.height,
                          ),
                        ],
                      )),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6),
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
                              .border(color: CustomColor.onSurface, width: 2)
                              .withRounded(value: 12)
                              .make(),
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
                        const Gap(430),
                        BlocBuilder<CameraCubit, CameraState>(
                          builder: (context, state) {
                            return HStack([
                              cubit.withErrorCircle
                                  ? Icon(
                                      Boxicons.bx_error_circle,
                                      size: 20,
                                      color: CustomColor.onSurface,
                                    )
                                  : Container(),
                              cubit.withErrorCircle
                                  ? const Gap(8)
                                  : Container(),
                              cubit.message.text
                                  .textStyle(CustomTextStyle.labelLarge)
                                  .color(CustomColor.onSurface)
                                  .make()
                            ]);
                          },
                        ),
                        const Gap(112),
                        BlocBuilder<CameraCubit, CameraState>(
                          builder: (context, state) {
                            return cubit.message2.text.center
                                .textStyle(CustomTextStyle.labelLarge)
                                .white
                                .make()
                                .pSymmetric(h: 75);
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
                                color: CustomColor.onSurface,
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
                    bottom: 0,
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
                            .color(CustomColor.surface)
                            .topRounded(value: 16)
                            .make()
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
