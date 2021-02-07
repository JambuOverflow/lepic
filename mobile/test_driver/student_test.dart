import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("CRUD Student", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Create a valid student in a class", () async {
      await driver.tap(find.text("Class B"));
      await driver.tap(find.byValueKey("createStudentButton"));
      await driver.tap(find.byValueKey("studentFirstName"));
      await driver.enterText("Ronaldo");
      await driver.tap(find.byValueKey("studentLastName"));
      await driver.enterText("Azevedo");
      await driver.tap(find.byValueKey("addStudent"));
      expect(await driver.getText(find.byValueKey("1_fullName")), "Ronaldo Azevedo");
    });
  });
}