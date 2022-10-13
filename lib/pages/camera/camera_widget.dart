part of 'camera_page.dart';

class _CameraWidget extends StatelessWidget {
  const _CameraWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCubit>();
    final fCubit = context.read<FaceAttendanceCubit>();
    final tCubit = context.read<RemoteConfigCubit>();

    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state is CameraInitialized) {
          cubit.isInitialized = true;
        }
        if (state is InitializeInterpreterSuccess) {
          cubit.interpreter = state.interpreter;
        }
        if (state is TfliteDataSuccess) {
          cubit.withErrorCircle = true;
          cubit.message = 'Wajah tidak ditemukan';
          cubit.message2 =
              'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker';
          cubit.tfliteData = state.data;
          if (cubit.tfliteData != null && cubit.faceVector != null) {
            cubit.calculateDist();
          }
        }
        if (state is ImageProcessed) {
          cubit.imagePath = state.croppedPath;
          cubit.detectedFacePaint = cubit.detectedFace;
          cubit.withErrorCircle = false;
          cubit.message = 'Proses pemindaian wajah..';
          cubit.message2 =
              'Pertahankan posisi wajah anda hingga waktu pemindaian berakhir';
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
            // ulang
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
              // jika 3 kali ttp dikirim datanya
              fCubit.attendingAttendance(
                similarityC: state.similarity,
                attendanceId: fCubit.attendanceId,
                dateId: fCubit.dateId,
                faceFile: File(cubit.croppedPath),
              );
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

              cubit.faceCounter = cubit.faceCounter + 1;
            }
          } else {
            // sukses
            fCubit.attendingAttendance(
              similarityC: state.similarity,
              attendanceId: fCubit.attendanceId,
              dateId: fCubit.dateId,
              faceFile: File(cubit.croppedPath),
            );
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
              animationKey: 'assets/animations/check_animation.json',
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
      },
    );
  }
}
