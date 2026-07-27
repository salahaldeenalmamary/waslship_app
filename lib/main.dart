import 'package:waslship/src/app.dart';
import 'src/imports/imports.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();

  await AppConfig.init();

  FlutterNativeSplash.remove();

  runApp(
    LocalizationWrapper(
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}
