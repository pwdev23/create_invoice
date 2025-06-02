import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common.dart';
import 'providers.dart';
import 'routes.dart';
import 'theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).locale;

    return MaterialApp(
      title: 'Create Invoice',
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
