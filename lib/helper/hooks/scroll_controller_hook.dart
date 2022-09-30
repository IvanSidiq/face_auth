import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useScrollControllerLoadMore({
  List<Object>? keys,
  required ValueNotifier<bool> isLoadMore,
  required Function() callback,
}) {
  return use(_ScrollControllerLoadMoreHook(
    isLoadMore: isLoadMore,
    callback: callback,
    keys: keys,
  ));
}

class _ScrollControllerLoadMoreHook extends Hook<ScrollController> {
  const _ScrollControllerLoadMoreHook({
    required this.isLoadMore,
    required this.callback,
    List<Object>? keys,
  }) : super(keys: keys);

  final ValueNotifier<bool> isLoadMore;
  final Function() callback;

  @override
  HookState<ScrollController, Hook<ScrollController>> createState() =>
      _ScrollControllerLoadMoreHookState();
}

class _ScrollControllerLoadMoreHookState
    extends HookState<ScrollController, _ScrollControllerLoadMoreHook> {
  late ScrollController controller;
  bool isCanLoadMore = true;

  @override
  void initHook() {
    controller = ScrollController();

    controller.addListener(() async {
      final max = controller.position.maxScrollExtent;
      final current = controller.position.pixels;
      if (max - current > 120) {
        isCanLoadMore = true;
      } else if (max - current <= 0 && isCanLoadMore) {
        isCanLoadMore = false;
        hook.isLoadMore.value = true;
        await hook.callback();
        hook.isLoadMore.value = false;
      }
    });
  }

  @override
  ScrollController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();
}
