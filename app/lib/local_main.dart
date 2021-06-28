import 'package:stripe_upgrade/locator.dart';
import 'package:stripe_upgrade/main.dart';

void main() async {
  await run(locatorInitializer: setupLocalLocator);
}
