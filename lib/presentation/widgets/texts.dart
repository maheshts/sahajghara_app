import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HighlightText extends StatelessWidget {
  const HighlightText({Key? key, required this.text, this.color})
      : super(key: key);
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return Text(
      text,
      style: AppTheme.primaryFont(
          theme.textTheme.displaySmall?.copyWith(color: color)),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline({Key? key, required this.text, this.color}) : super(key: key);
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return Text(
      text,
      style: theme.textTheme.displayMedium?.copyWith(color: color),
    );
  }
}

class DrawerText extends StatelessWidget {
  const DrawerText({Key? key, required this.text, this.color})
      : super(key: key);
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(color: color),
    );
  }
}
