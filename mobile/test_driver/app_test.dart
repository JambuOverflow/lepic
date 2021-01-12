import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Signup Test - ", () {
    FlutterDriver driver;
        
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Login an account properly validated", () async {
      await driver.tap(find.byValueKey("userLoginField"));
      await driver.enterText("vitornovaes.cantao@gmail.com");
      await driver.tap(find.byValueKey("userPasswordField"));
      await driver.enterText("ABCdef123");
      await driver.tap(find.byValueKey("loginButton"));
    });
  });
}
