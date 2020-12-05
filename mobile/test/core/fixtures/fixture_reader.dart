import 'dart:io';

String fixture(String name) =>
    File('./test/core/fixtures/$name.json').readAsStringSync();
