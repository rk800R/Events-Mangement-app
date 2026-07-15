import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/calendar/screens/home_screen.dart';
import 'features/events/screens/event_detail_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'providers/event_provider.dart';
import 'providers/settings_provider.dart';

class HarmoniCalApp extends StatelessWidget {
  const HarmoniCalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            onGenerateRoute: (routeSettings) {
              final uri = Uri.parse(routeSettings.name ?? '/');
              if (uri.path == '/settings') {
                return MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                );
              }
              if (uri.pathSegments.length == 2 &&
                  uri.pathSegments[0] == 'event') {
                return MaterialPageRoute(
                  builder: (_) =>
                      EventDetailScreen(eventId: uri.pathSegments[1]),
                );
              }
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
