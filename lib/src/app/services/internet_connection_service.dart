
import '../../imports/packages_imports.dart';

class InternetConnectionService {
  InternetConnectionService();

  final InternetConnection internetConnection = InternetConnection();

  Future<bool> hasConnection() async =>
      await internetConnection.hasInternetAccess;
}
