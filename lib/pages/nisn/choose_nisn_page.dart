import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_auth/models/attendance.dart';
import 'package:face_auth/pages/nisn/cubit/attendance_cubit.dart';
import 'package:face_auth/pages/nisn/cubit/logout_cubit.dart';
import 'package:face_auth/pages/nisn/cubit/school_profile_cubit.dart';
import 'package:face_auth/pages/nisn/cubit/search_cubit.dart';
import 'package:face_auth/services/navigation_service.dart';
import 'package:face_auth/utils/colors.dart';
import 'package:face_auth/utils/customs/custom_text_style.dart';
import 'package:face_auth/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../helper/hooks/scroll_controller_hook.dart';
import '../../utils/function.dart';
import 'cubit/keyboard_cubit.dart';
import 'custom_image_dialog2_widget.dart';

part 'keyboard_widget.dart';

class ChooseNisnPage extends StatelessWidget {
  const ChooseNisnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SchoolProfileCubit(),
        ),
        BlocProvider(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => KeyboardCubit(),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
      ],
      child: const _ChooseNisnPage(),
    );
  }
}

class _ChooseNisnPage extends HookWidget {
  const _ChooseNisnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SchoolProfileCubit>();
    final aCubit = context.read<AttendanceCubit>();
    final kCubit = context.read<KeyboardCubit>();
    final lCubit = context.read<LogoutCubit>();

    final passwordC = useTextEditingController();

    useEffect(() {
      cubit.getSchoolProfile();
      return;
    }, [cubit]);

    final isLoadMore = useState(false);
    ScrollController scrollC = useScrollControllerLoadMore(
        isLoadMore: isLoadMore,
        callback: () async {
          await aCubit.loadMore(
            search: kCubit.keyController,
          );
        });

    return Scaffold(
      backgroundColor: CustomColor.surface,
      body: SafeArea(
        child: BlocConsumer<SchoolProfileCubit, SchoolProfileState>(
          listener: (context, state) {
            if (state is GetSchoolProfileSuccess) {
              // aCubit.initialLoad();
            }
          },
          builder: (context, state) {
            if (state is GetSchoolProfileSuccess) {
              final logo = state.school.logo;
              return VStack([
                HStack([
                  BlocListener<LogoutCubit, LogoutState>(
                    listener: (context, state) {
                      if (state is ClickedCounts) {
                        if (lCubit.clickedCounts < 7) {
                          lCubit.clickedCounts = lCubit.clickedCounts + 1;
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return CustomImage2Widget(
                                    title: 'Keluar dari aplikasi',
                                    body:
                                        'Anda perlu melakukan login kembali untuk dapat menggunakan aplikasi presensi pada perangkat ini',
                                    buttonText: 'Lanjutkan',
                                    onClick: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return CustomImage3Widget(
                                                title: 'Keluar dari aplikasi',
                                                body:
                                                    'Masukkan kata sandi untuk keluar dari aplikasi presensi pada perangkat ini',
                                                buttonText: 'Logout',
                                                controller: passwordC,
                                                onClick: () {
                                                  lCubit.logout(passwordC.text);
                                                },
                                                imageWidth: 120,
                                                imageKey:
                                                    'assets/images/logout.png');
                                          });
                                    },
                                    imageWidth: 120,
                                    imageKey: 'assets/images/logout.png');
                              });
                        }
                      }
                    },
                    child: CachedNetworkImage(
                      imageUrl: getImage(logo),
                      imageBuilder: (context, image) {
                        return VxBox()
                            .bgImage(DecorationImage(
                                image: image, fit: BoxFit.contain))
                            .height(24)
                            .width(24)
                            .color(Colors.transparent)
                            .make();
                      },
                      errorWidget: (context, url, error) {
                        return Icon(
                          Boxicons.bx_image_alt,
                          size: 24,
                          color: CustomColor.onSurfaceVariant.withOpacity(0.38),
                        ).centered();
                      },
                      placeholder: (context, url) {
                        return const SizedBox(width: 24, height: 24);
                      },
                    ),
                  ).onTap(() {
                    lCubit.tryLogout();
                  }),
                  state.school.name.text
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
                BlocConsumer<AttendanceCubit, AttendanceState>(
                  listener: (context, state) {
                    aCubit.attendanceCount =
                        (state.props[1] as List<Attendance>).length;
                  },
                  builder: (context, state) {
                    if (state is AttendanceSuccess) {
                      final List<Attendance> attendances =
                          state.props[1] as List<Attendance>;
                      if (attendances.isEmpty) {
                        return VStack(
                          [
                            Image.asset(
                              'assets/images/nisn_init.png',
                              width: 136,
                              height: 136,
                              fit: BoxFit.contain,
                            ).centered(),
                            const Gap(32),
                            'Maaf tidak ditemukan data yang anda cari'
                                .text
                                .align(TextAlign.center)
                                .make()
                                .px(60),
                            const Gap(13.5),
                          ],
                          alignment: MainAxisAlignment.end,
                        );
                      }
                      if (kCubit.keyController == '') {
                        return VStack(
                          [
                            Image.asset(
                              'assets/images/nisn_init.png',
                              width: 136,
                              height: 136,
                              fit: BoxFit.contain,
                            ).centered(),
                            const Gap(32),
                            'Masukkan NIS atau pindai kode QR Anda untuk melakukan presensi'
                                .text
                                .align(TextAlign.center)
                                .make()
                                .px(60),
                            const Gap(13.5),
                          ],
                          alignment: MainAxisAlignment.end,
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: VStack([
                          const Gap(12),
                          aCubit.attendanceCount == 0
                              ? Container()
                              : 'Menampilkan ${aCubit.attendanceCount} hasil pencarian NIS'
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
                              itemCount: isLoadMore.value
                                  ? attendances.length + 1
                                  : attendances.length,
                              itemBuilder: (context, index) {
                                if (isLoadMore.value &&
                                    index == attendances.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: CustomLoadingWidget(),
                                  );
                                }
                                final isChoosable =
                                    (attendances[index].status == 0);
                                return HStack([
                                  attendances[index]
                                      .name[0]
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
                                    attendances[index]
                                        .name
                                        .text
                                        .textStyle(CustomTextStyle.bodyMedium)
                                        .color(CustomColor.onSurface
                                            .withOpacity(
                                                isChoosable ? 1 : 0.36))
                                        .make(),
                                    const Gap(4),
                                    attendances[index]
                                        .nis
                                        .text
                                        .textStyle(CustomTextStyle.labelMedium)
                                        .color(CustomColor.onSurfaceVariant
                                            .withOpacity(
                                                isChoosable ? 0.6 : 0.36))
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
                                              .withOpacity(
                                                  isChoosable ? 1 : 0.36))
                                          .roundedLg
                                          .make()
                                      : 'Sudah hadir'
                                          .text
                                          .textStyle(CustomTextStyle.labelSmall)
                                          .color(CustomColor.onSurface
                                              .withOpacity(
                                                  isChoosable ? 0.52 : 0.36))
                                          .makeCentered()
                                          .pSymmetric(v: 4, h: 10)
                                          .box
                                          .color(CustomColor.onSurface
                                              .withOpacity(0.12))
                                          .roundedLg
                                          .make(),
                                ])
                                    .box
                                    .p12
                                    .withRounded(value: 12)
                                    .color(CustomColor.surface)
                                    .make()
                                    .onTap(() {
                                  if (isChoosable) {
                                    GetIt.I<NavigationServiceMain>()
                                        .pushNamed('/camera', args: {
                                      'userId': state.attendances[index].userId
                                    })!.then((value) => aCubit.initialLoad(
                                            search: kCubit.keyController));
                                  }
                                }).pOnly(top: 4, bottom: 4);
                              }),
                        ]).scrollVertical(
                          physics: const BouncingScrollPhysics(),
                          controller: scrollC,
                        ),
                      )
                          .box
                          .withRounded(value: 16)
                          .p8
                          .color(CustomColor.surface3)
                          .make()
                          .px(8);
                    }
                    if (state is AttendanceLoading) {
                      return const CustomLoadingWidget().pOnly(top: 80);
                    }
                    return VStack(
                      [
                        Image.asset(
                          'assets/images/nisn_init.png',
                          width: 136,
                          height: 136,
                          fit: BoxFit.contain,
                        ).centered(),
                        const Gap(32),
                        'Masukkan NIS atau pindai kode QR Anda untuk melakukan presensi'
                            .text
                            .align(TextAlign.center)
                            .make()
                            .px(60),
                        const Gap(13.5),
                      ],
                      alignment: MainAxisAlignment.end,
                    );
                  },
                ).w(Get.width).expand(),
                BlocListener<SearchCubit, SearchState>(
                  listener: (context, state) {
                    if (state is SearchDelay) {
                      aCubit.initialLoad(search: state.search);
                    }
                  },
                  child: const _KeyboardWidget(),
                ),
                const Gap(12),
                HStack([
                  Icon(
                    Boxicons.bx_scan,
                    size: 24,
                    color: CustomColor.surface,
                  ),
                  const Gap(12),
                  'Scan QR'
                      .text
                      .color(CustomColor.surface)
                      .textStyle(CustomTextStyle.bodyMedium)
                      .make(),
                ])
                    .centered()
                    .box
                    .height(64)
                    .color(CustomColor.primary)
                    .width(Get.width)
                    .make()
                    .onTap(() async {
                  await GetIt.I<NavigationServiceMain>()
                      .pushNamed('/scanner')!
                      .then((value) {
                    if (value != null) {
                      GetIt.I<NavigationServiceMain>()
                          .pushNamed('/camera', args: {'userId': value})!.then(
                              (value) => aCubit.initialLoad(
                                  search: kCubit.keyController));
                    }
                  });
                }),
                // .box
                // .withShadow([
                //   const BoxShadow(
                //       offset: Offset(0, -4),
                //       blurRadius: 16,
                //       spreadRadius: 0,
                //       color: Color(0x1E000000))
                // ])
                // .make(),
              ]);
            }
            return const CustomLoadingWidget().centered();
          },
        ),
      ),
    );
  }
}
