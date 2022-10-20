part of 'camera_page.dart';

class _CameraMessagesWidget extends StatelessWidget {
  const _CameraMessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CameraCubit>();
    return Positioned(
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
    );
  }
}
