import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("CRUD class", () {
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

    test("Create a class with a valid name and grade", () async {
      await driver.tap(find.text("Classrooms"));
      await driver.tap(find.byValueKey("createClass"));
      await driver.tap(find.byValueKey("classNameField"));
      await driver.enterText("Class A");
      await driver.tap(find.byValueKey("classGradeField"));
      await driver.enterText("1");
      await driver.tap(find.text("Add"));
      expect(await driver.getText(find.byValueKey("classCounter")),
          "Total classes:1");
    });

    test("Update a class and check if the informations were properly updated",
        () async {
      await driver.tap(find.byValueKey("updateClassButton"));
      await driver.tap(find.byValueKey("classNameField"));
      await driver.enterText("Class R");
      await driver.tap(find.byValueKey("classGradeField"));
      await driver.enterText("9");
      await driver.tap(find.text("Update"));
      expect(await driver.getText(find.byValueKey("currentName")), "Class R");
      expect(await driver.getText(find.byValueKey("currentGrade")), "Grade: 9");
    });
  });
}
