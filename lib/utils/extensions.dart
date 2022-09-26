import 'package:flutter/widgets.dart';

extension UtilExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screen => mediaQuery.size;
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) {
      return '-';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get replaceDash {
    if (isEmpty) {
      return '-';
    }

    return replaceAll('-', ' ');
  }

  String get removeSpace {
    if (isEmpty) {
      return '';
    }

    return replaceAll(' ', '');
  }

  String get removeFirstBackSlash {
    if (isEmpty) {
      return '-';
    } else if (this[0] == '/') {
      return replaceFirst('/', '');
    }

    return this;
  }

  String get replaceBackSlash {
    if (isEmpty) {
      return '-';
    }

    return replaceAll('/', ' ');
  }

  String get capitalizeFirstOfEach {
    if (isEmpty) {
      return '-';
    }
    return split(" ").map((str) => str.toLowerCase().capitalize).join(" ");
  }

  String get emptyNumber {
    if (isEmpty) {
      return '0';
    }

    return this;
  }

  String get capitalizeFirstAndRemoveUnderscores {
    if (isEmpty) {
      return '-';
    }
    return split("_").map((str) => str.toLowerCase().capitalize).join(" ");
  }

  String get replacePHtml {
    if (isEmpty) {
      return ' ';
    }

    final a = replaceAll('<p>', '');
    return a.replaceAll('</p>', ' ');
  }
}
