import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:sahajghara/presentation/theme/theme_controller.dart';
import 'package:sahajghara/presentation/widgets/theme_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

final previewKey = GlobalKey();

class TestApp extends ConsumerWidget {
  const TestApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ref.watch(themeModeProvider),
        home: Builder(
            builder: (context) => RepaintBoundary(
                key: previewKey,
                child: Scaffold(
                  appBar: AppBar(title: const Text('My Profile')),
                  body: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        Card(
                            child: Column(children: [
                          const ListTile(title: Text('Appearance')),
                          const ThemeSetting(),
                        ])),
                        const SizedBox(height: 16),
                        Text('SahajGhara',
                            style: Theme.of(context).textTheme.titleLarge),
                        const TextField(
                            decoration:
                                InputDecoration(labelText: 'Your name')),
                      ])),
                ))),
      );
}

void main() {
  testWidgets('home box outlines remain visible against dark surfaces',
      (tester) async {
    late Color border;
    late Color background;
    late Color button;
    Future<void> render(ThemeData theme) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Builder(builder: (context) {
          background = AppTheme.surface(context, Colors.white);
          border = AppTheme.outline(context, const Color(0xFFEAEAEA));
          button = AppTheme.raisedSurface(context, const Color(0xFFEAEAEA));
          return Scaffold(body: Container(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: border),
            ),
          ));
        }),
      ));
      await tester.pumpAndSettle();
    }

    await render(AppTheme.darkTheme);
    final contrast = (border.computeLuminance() + 0.05) /
        (background.computeLuminance() + 0.05);
    expect(contrast, greaterThanOrEqualTo(3));
    expect(button, isNot(background));

    await render(AppTheme.lightTheme);
    expect(background, Colors.white);
    expect(border, const Color(0xFFEAEAEA));
    expect(button, const Color(0xFFEAEAEA));
  });

  test('saved theme is restored and updates persist', () async {
    SharedPreferences.setMockInitialValues({themePreferenceKey: 'dark'});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
        overrides: [themePreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(container.dispose);
    expect(container.read(themeModeProvider), ThemeMode.dark);
    await container.read(themeModeProvider.notifier).setDarkMode(false);
    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(prefs.getString(themePreferenceKey), 'light');
    final restored = ThemeModeController(prefs);
    addTearDown(restored.dispose);
    expect(restored.state, ThemeMode.light);
  });

  test('missing or invalid preference defaults to light', () async {
    SharedPreferences.setMockInitialValues({themePreferenceKey: 'invalid'});
    final controller =
        ThemeModeController(await SharedPreferences.getInstance());
    addTearDown(controller.dispose);
    expect(controller.state, ThemeMode.light);
  });

  testWidgets(
      'profile switch updates theme immediately and can return to light',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [themePreferencesProvider.overrideWithValue(prefs)],
      child: const TestApp(),
    ));
    await tester.pumpAndSettle();
    final setting = find.byType(ThemeSetting);
    expect(Theme.of(tester.element(setting)).brightness, Brightness.light);
    expect(find.text('Light theme enabled'), findsOneWidget);
    Future<void> capture(String name) async {
      await tester.runAsync(() async {
        final boundary = previewKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('build/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('theme_light');
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(setting)).brightness, Brightness.dark);
    expect(find.text('Dark theme enabled'), findsOneWidget);
    expect(prefs.getString(themePreferenceKey), 'dark');
    await capture('theme_dark');
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(setting)).brightness, Brightness.light);
    expect(prefs.getString(themePreferenceKey), 'light');
    expect(tester.takeException(), isNull);
  });
}
