import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_controller.dart';

class ThemeSetting extends ConsumerWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return SwitchListTile(
      secondary:
          Icon(dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
      title: const Text('Dark mode'),
      subtitle: Text(dark ? 'Dark theme enabled' : 'Light theme enabled'),
      value: dark,
      onChanged: (enabled) async {
        try {
          await ref.read(themeModeProvider.notifier).setDarkMode(enabled);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Unable to save theme. Please try again.')),
            );
          }
        }
      },
    );
  }
}
