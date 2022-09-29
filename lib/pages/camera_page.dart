import 'package:face_auth/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/colors.dart';
import '../utils/customs/custom_text_style.dart';
import '../widgets/face_painter.dart';
import 'cubit/camera_cubit.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraCubit(),
      child: const _CameraPage(),
    );
  }
}

class _CameraPage extends HookWidget {
  const _CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCubit>();

    useEffect(() {
      cubit.initCamera();
      return;
    }, [cubit]);

    return WillPopScope(
      onWillPop: () async {
        cubit.dispose();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Material(
            child: Stack(
              children: [
                BlocConsumer<CameraCubit, CameraState>(
                  listener: (context, state) {
                    if (state is TfliteDataSuccess) {
                      cubit.tfliteData = state.data;
                      if (cubit.savedUser != null) {
                        cubit.calculateDist();
                      }
                    }
                    if (state is CameraInitialized) {
                      cubit.isInitialized = true;
                    }
                    if (state is ImageProcessed) {
                      cubit.imagePath = state.croppedPath;
                      cubit.message = 'Proses pemindaian wajah..';
                    }
                    if (state is InitializeInterpreterSuccess) {
                      cubit.interpreter = state.interpreter;
                    }
                    if (state is NoFaceDetected) {
                      cubit.message = 'Wajah tidak ditemukan';
                    }
                    if (state is FaceDetectedBut) {
                      cubit.message = state.message;
                    }
                  },
                  builder: (context, state) {
                    final size = Get.size;
                    final deviceRatio = size.width / size.height;
                    return SizedBox(
                      width: size.width,
                      height: size.width * 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraWidget(
                            cameraService: cubit.cameraService,
                            isCameraInitialized: cubit.isInitialized,
                            deviceRatio: deviceRatio,
                          ),
                          BlocBuilder<CameraCubit, CameraState>(
                            builder: (context, state) {
                              if (state is ImageProcessed) {
                                if (cubit.detectedFace == null) {
                                  return Container();
                                }
                                return CustomPaint(
                                  painter: FacePainter(
                                      face: cubit.detectedFace!,
                                      imageSize: Size(
                                          MediaQuery.of(context).size.width +
                                              90,
                                          (MediaQuery.of(context).size.height *
                                                  4 /
                                                  5) +
                                              40)),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6),
                      BlendMode.srcOut), // This one will create the magic
                  child: Stack(
                    fit: StackFit.expand,
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
                          margin: const EdgeInsets.only(top: 80),
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
                Positioned(
                    top: 0,
                    child: VStack(
                      [
                        const Gap(32),
                        'Verifikasi Wajah'
                            .text
                            .textStyle(CustomTextStyle.titleLarge)
                            .color(Colors.white)
                            .make(),
                        const Gap(50),
                        Lottie.asset('assets/animations/check_animation.json')
                            .w(200)
                            .h(200),
                        const Gap(100),
                        BlocBuilder<CameraCubit, CameraState>(
                          builder: (context, state) {
                            return cubit.message.text
                                .textStyle(CustomTextStyle.labelLarge)
                                .white
                                .make();
                          },
                        )
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    )).w(Get.width),
                Positioned(
                  bottom: 0,
                  child: VStack(
                    [
                      'Bondan Prakoso'
                          .text
                          .align(TextAlign.center)
                          .textStyle(CustomTextStyle.titleMedium)
                          .make(),
                      const Gap(8),
                      '1234567'
                          .text
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
                      .w(Get.width),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     BlocConsumer<CameraCubit, CameraState>(
                //       listener: (context, state) {},
                //       builder: (context, state) {
                //         return ((cubit.savedUser != null)
                //                 ? '${cubit.savedUser!}\'s face'
                //                 : 'No saved profile')
                //             .text
                //             .make();
                //       },
                //     ),
                //     const SizedBox(
                //       width: 30,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         if (cubit.tfliteData != null) {
                //           showDialog(
                //                   context: context,
                //                   builder: (context) {
                //                     return Dialog(
                //                       child: TextField(
                //                               decoration: InputDecoration(
                //                                   label: 'Name'.text.make()),
                //                               onSubmitted: (val) {
                //                                 Navigator.pop(context, val);
                //                               })
                //                           .box
                //                           .p16
                //                           .color(CustomColor.surface)
                //                           .rounded
                //                           .make(),
                //                     );
                //                   })
                //               .then((value) =>
                //                   cubit.saveData(cubit.tfliteData!, value));
                //         }
                //       },
                //       child:
                //           'Save Profile'.text.white.make().box.p16.blue500.make(),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // BlocConsumer<CameraCubit, CameraState>(
                //   listener: (context, state) {
                //     if (state is CalculateDistance) {
                //       cubit.currDist = state.dist;
                //       cubit.similarity = state.similarity;
                //       cubit.minkowskiDist = state.minkowski;
                //     }
                //   },
                //   builder: (context, state) {
                //     return VStack(
                //       [
                //         'Distance similarity : ${cubit.currDist.toStringAsFixed(2)}'
                //             .text
                //             .make()
                //             .box
                //             .p16
                //             .green100
                //             .make(),
                //         const SizedBox(height: 16),
                //         'Cosine Similarity : ${cubit.similarity.toStringAsFixed(2)}'
                //             .text
                //             .make()
                //             .box
                //             .p16
                //             .green100
                //             .make(),
                //         const SizedBox(height: 16),
                //         'Minkowski Similarity : ${cubit.minkowskiDist.toStringAsFixed(2)}'
                //             .text
                //             .make()
                //             .box
                //             .p16
                //             .green100
                //             .make(),
                //         const SizedBox(height: 16),
                //       ],
                //       crossAlignment: CrossAxisAlignment.center,
                //     );
                //   },
                // ),
                // const SizedBox(height: 16),
                // HStack([
                //   BlocBuilder<CameraCubit, CameraState>(
                //     builder: (context, state) {
                //       return SizedBox(
                //         width: 50,
                //         height: 50,
                //         child: cubit.imagePath != null
                //             ? Image.file(
                //                 File(cubit.imagePath!),
                //                 fit: BoxFit.contain,
                //               )
                //             : Container(),
                //       );
                //     },
                //   ),
                //   // const SizedBox(width: 10),
                //   // BlocBuilder<CameraCubit, CameraState>(
                //   //   builder: (context, state) {
                //   //     return SizedBox(
                //   //       width: 50,
                //   //       height: 50,
                //   //       child: cubit.userSavedPath != null
                //   //           ? Image.file(
                //   //               File(cubit.userSavedPath!),
                //   //               fit: BoxFit.contain,
                //   //             )
                //   //           : Container(),
                //   //     );
                //   //   },
                //   // ),
                //   // const SizedBox(width: 10),
                // ]),
              ],
            ).backgroundColor(CustomColor.surface).w(Get.width).h(Get.height),
          ),
        ),
      ),
    );
  }
}
