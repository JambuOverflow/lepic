import 'dart:io';

String fixture(String name) =>
    File('./integration_test/fixture/$name.json').readAsStringSync();
