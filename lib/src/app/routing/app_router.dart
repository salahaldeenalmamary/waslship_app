import 'package:auto_route/auto_route.dart';
import 'package:waslship/src/app/routing/global_navigator.dart';


@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: rootNavigatorKey);

  @override
  List<AutoRoute> get routes => [
       
      ];
}
