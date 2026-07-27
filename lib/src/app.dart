import 'package:waslship/src/imports/imports.dart';

import 'app/routing/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      child: MaterialApp.router(
        title: 'WaslShip',
        debugShowCheckedModeBanner: false,

        routerConfig: _appRouter.config(),

        theme: buildLightTheme(primaryColorHex: '#6750A4'),
       


        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}