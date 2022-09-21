import 'dart:io';

import 'package:face_auth/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/colors.dart';
import '../widgets/FacePainter.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  }
                  if (state is InitializeInterpreterSuccess) {
                    cubit.interpreter = state.interpreter;
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 3 / 4,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraWidget(
                            cameraService: cubit.cameraService,
                            isCameraInitialized: cubit.isInitialized,
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
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<CameraCubit, CameraState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return ((cubit.savedUser != null)
                              ? '${cubit.savedUser!}\'s face'
                              : 'No saved profile')
                          .text
                          .make();
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (cubit.tfliteData != null) {
                        showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: TextField(
                                            decoration: InputDecoration(
                                                label: 'Name'.text.make()),
                                            onSubmitted: (val) {
                                              Navigator.pop(context, val);
                                            })
                                        .box
                                        .p16
                                        .color(CustomColor.surface)
                                        .rounded
                                        .make(),
                                  );
                                })
                            .then((value) =>
                                cubit.saveData(cubit.tfliteData!, value));
                      }
                    },
                    child:
                        'Save Profile'.text.white.make().box.p16.blue500.make(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<CameraCubit, CameraState>(
                listener: (context, state) {
                  if (state is CalculateDistance) {
                    cubit.currDist = state.dist;
                    cubit.similarity = state.similarity;
                    cubit.minkowskiDist = state.minkowski;
                  }
                },
                builder: (context, state) {
                  return VStack(
                    [
                      'Distance similarity : ${cubit.currDist.toStringAsFixed(2)}'
                          .text
                          .make()
                          .box
                          .p16
                          .green100
                          .make(),
                      const SizedBox(height: 16),
                      'Cosine Similarity : ${cubit.similarity.toStringAsFixed(2)}'
                          .text
                          .make()
                          .box
                          .p16
                          .green100
                          .make(),
                      const SizedBox(height: 16),
                      'Minkowski Similarity : ${cubit.minkowskiDist.toStringAsFixed(2)}'
                          .text
                          .make()
                          .box
                          .p16
                          .green100
                          .make(),
                      const SizedBox(height: 16),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  );
                },
              ),
              const SizedBox(height: 16),
              HStack([
                BlocBuilder<CameraCubit, CameraState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: cubit.imagePath != null
                          ? Image.file(
                              File(cubit.imagePath!),
                              fit: BoxFit.contain,
                            )
                          : Container(),
                    );
                  },
                ),
                // const SizedBox(width: 10),
                // BlocBuilder<CameraCubit, CameraState>(
                //   builder: (context, state) {
                //     return SizedBox(
                //       width: 50,
                //       height: 50,
                //       child: cubit.userSavedPath != null
                //           ? Image.file(
                //               File(cubit.userSavedPath!),
                //               fit: BoxFit.contain,
                //             )
                //           : Container(),
                //     );
                //   },
                // ),
                // const SizedBox(width: 10),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
