import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Signup screen", () {
    final firstNameField = find.byValueKey("firstNameField");
    final signUpButton = find.byValueKey("signUpButton");
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("first name test", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(signUpButton);
        await driver.waitFor(signUpButton);
        await driver.tap(firstNameField);
        await driver.enterText("Arthur");
        await driver.waitFor(find.text("Arthur"));
      });
    });
  });
}
