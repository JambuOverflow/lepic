import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_logged_in_user_use_case.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:moor/moor.dart';

import 'database.dart';

void populateDatabaseWithExample() async {
  final Database database = GetIt.instance.get<Database>();

  final GetLoggedInUserCase getLoggedInUserCase =
      GetIt.instance.get<GetLoggedInUserCase>();
  final NoParams noParams = NoParams();
  final userOutput = await getLoggedInUserCase(noParams);
  User user;
  userOutput.fold((l) => null, (r) {
    user = r;
  });

  final ClassroomModelsCompanion classroom1 = ClassroomModelsCompanion(
      grade: Value(1),
      name: Value("A"),
      tutorId: Value(user.localId),
      deleted: Value(false),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final ClassroomModelsCompanion classroom2 = ClassroomModelsCompanion(
      grade: Value(1),
      name: Value("B"),
      deleted: Value(false),
      tutorId: Value(user.localId),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final ClassroomModelsCompanion classroom3 = ClassroomModelsCompanion(
      grade: Value(2),
      name: Value("A"),
      deleted: Value(false),
      tutorId: Value(user.localId),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final StudentModelsCompanion student1 = StudentModelsCompanion(
    firstName: Value("Paul"),
    lastName: Value("Philips"),
    classroomId: Value(1),
  );

  final StudentModelsCompanion student2 = StudentModelsCompanion(
    firstName: Value("Vanessa"),
    lastName: Value("Isabel"),
    classroomId: Value(1),
  );

  final StudentModelsCompanion student3 = StudentModelsCompanion(
    firstName: Value("Victor"),
    lastName: Value("Singer"),
    classroomId: Value(2),
  );

  Future<String> loadAsset(String name) async {
    return await rootBundle.loadString(name);
  }

  final String pot = await loadAsset('assets/texts/pot.txt');
  final String fox = await loadAsset('assets/texts/fox.txt');
  final String lionShare = await loadAsset('assets/texts/lion_share.txt');
  final String ant = await loadAsset('assets/texts/ant_and_grasshopper.txt');
  final String turtle = await loadAsset('assets/texts/turtle.txt');

  final String title1 = "The Earthen Pot and The Brass Pot";
  final TextModelsCompanion text1 = TextModelsCompanion(
    title: Value(title1),
    tutorId: Value(user.localId),
    body: Value(pot),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 1)),
  );

  final TextModelsCompanion text2 = TextModelsCompanion(
    title: Value(title1),
    tutorId: Value(user.localId),
    body: Value(pot),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 1)),
  );

  final String title2 = "The Fox and The Grapes";
  final TextModelsCompanion text3 = TextModelsCompanion(
    title: Value(title2),
    tutorId: Value(user.localId),
    body: Value(fox),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 2)),
  );

  final TextModelsCompanion text4 = TextModelsCompanion(
    title: Value(title2),
    tutorId: Value(user.localId),
    body: Value(fox),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 2)),
  );

  final String title3 = "The Lion's Share";
  final TextModelsCompanion text5 = TextModelsCompanion(
    title: Value(title3),
    tutorId: Value(user.localId),
    body: Value(lionShare),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 3)),
  );

  final TextModelsCompanion text6 = TextModelsCompanion(
    title: Value(title3),
    tutorId: Value(user.localId),
    body: Value(lionShare),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 3)),
  );

  final String title4 = "The Ant and the Grasshopper";
  final TextModelsCompanion text7 = TextModelsCompanion(
    title: Value(title4),
    tutorId: Value(user.localId),
    body: Value(ant),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 4)),
  );

  final TextModelsCompanion text8 = TextModelsCompanion(
    title: Value(title4),
    tutorId: Value(user.localId),
    body: Value(ant),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 4)),
  );

  final String title5 = "Tortoise and The Hare";
  final TextModelsCompanion text9 = TextModelsCompanion(
    title: Value(title5),
    tutorId: Value(user.localId),
    body: Value(turtle),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 5)),
  );

  final TextModelsCompanion text10 = TextModelsCompanion(
    title: Value(title5),
    tutorId: Value(user.localId),
    body: Value(turtle),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 5)),
  );

  await database.insertClassroom(classroom1);
  await database.insertClassroom(classroom3);
  await database.insertClassroom(classroom2);
  await database.insertStudent(student1);
  await database.insertStudent(student2);
  await database.insertStudent(student3);
  await database.insertText(text1);
  await database.insertText(text2);
  await database.insertText(text3);
  await database.insertText(text4);
  await database.insertText(text5);
  await database.insertText(text6);
  await database.insertText(text7);
  await database.insertText(text8);
  await database.insertText(text9);
  await database.insertText(text10);

  Future<Uint8List> loadAudio(String name) async {
    ByteData byteData = await rootBundle.load(name);
    return byteData.buffer.asUint8List();
  }

  final Uint8List takeshiGrasshopper =
      await loadAudio("assets/audios/grasshopper.ogg");
  final Uint8List takeshiFox = await loadAudio("assets/audios/fox.ogg");
  final Uint8List takeshiLion = await loadAudio("assets/audios/lion_share.ogg");
  final Uint8List takeshiPot = await loadAudio("assets/audios/pot.ogg");
  final Uint8List takeshiTurtle = await loadAudio("assets/audios/turtle.ogg");

  final Uint8List isabelaGrasshopper =
      await loadAudio("assets/audios/ant_isabela.ogg");
  final Uint8List isabelaFox = await loadAudio("assets/audios/fox_isabela.ogg");
  final Uint8List isabelaLion =
      await loadAudio("assets/audios/lion_isabela.ogg");
  final Uint8List isabelaPot = await loadAudio("assets/audios/pot_isabela.ogg");
  final Uint8List isabelaTurtle =
      await loadAudio("assets/audios/turtle_isabela.ogg");

  final AudioModel takaGrasshopperAudio = AudioModel(
    audioData: takeshiGrasshopper,
    localId: 1,
    title: "Grasshopper",
    audioDurationInSeconds: 59,
    studentId: 1,
    textId: 7,
  );

  final AudioModel takeshiFoxAudio = AudioModel(
    audioData: takeshiFox,
    localId: 2,
    title: "The Fox and The Grapes",
    audioDurationInSeconds: 84,
    studentId: 1,
    textId: 3,
  );

  final AudioModel takeshiLionAudio = AudioModel(
    audioData: takeshiLion,
    localId: 3,
    title: "Lion's Share",
    audioDurationInSeconds: 87,
    studentId: 1,
    textId: 5,
  );

  final AudioModel takeshiPotAudio = AudioModel(
    audioData: takeshiPot,
    localId: 4,
    title: "The Earthen Pot and The Brass Pot",
    audioDurationInSeconds: 63,
    studentId: 1,
    textId: 1,
  );

  final AudioModel takeshiTurtleAudio = AudioModel(
    audioData: takeshiTurtle,
    localId: 5,
    title: "Tortoise and The Hare",
    audioDurationInSeconds: 59,
    studentId: 1,
    textId: 9,
  );

  final AudioModel isabelaGrasshopperAudio = AudioModel(
    audioData: isabelaGrasshopper,
    localId: 6,
    title: "Grasshopper",
    audioDurationInSeconds: 95,
    studentId: 2,
    textId: 8,
  );

  final AudioModel isabelaFoxAudio = AudioModel(
    audioData: isabelaFox,
    localId: 7,
    title: "The Fox and The Grapes",
    audioDurationInSeconds: 118,
    studentId: 2,
    textId: 4,
  );

  final AudioModel isabelaLionAudio = AudioModel(
    audioData: isabelaLion,
    localId: 8,
    title: "Lion's Share",
    audioDurationInSeconds: 131,
    studentId: 2,
    textId: 6,
  );

  final AudioModel isabelaPotAudio = AudioModel(
    audioData: isabelaPot,
    localId: 9,
    title: "The Earthen Pot and The Brass Pot",
    audioDurationInSeconds: 98,
    studentId: 2,
    textId: 2,
  );

  final AudioModel isabelaTurtleAudio = AudioModel(
    audioData: isabelaTurtle,
    localId: 10,
    title: "Tortoise and The Hare",
    audioDurationInSeconds: 136,
    studentId: 2,
    textId: 10,
  );

  await database.insertAudio(takeshiTurtleAudio);
  await database.insertAudio(takeshiPotAudio);
  await database.insertAudio(takaGrasshopperAudio);
  await database.insertAudio(takeshiLionAudio);
  await database.insertAudio(takeshiFoxAudio);

  await database.insertAudio(isabelaTurtleAudio);
  await database.insertAudio(isabelaPotAudio);
  await database.insertAudio(isabelaGrasshopperAudio);
  await database.insertAudio(isabelaLionAudio);
  await database.insertAudio(isabelaFoxAudio);

  //takeshi corrections
  final CorrectionModel correction1 =
      CorrectionModel(localId: 1, textId: 1, studentId: 1);
  final CorrectionModel correction2 =
      CorrectionModel(localId: 2, textId: 3, studentId: 1);
  final CorrectionModel correction3 =
      CorrectionModel(localId: 3, textId: 5, studentId: 1);
  final CorrectionModel correction4 =
      CorrectionModel(localId: 4, textId: 7, studentId: 1);
  final CorrectionModel correction5 =
      CorrectionModel(localId: 5, textId: 9, studentId: 1);

  await database.insertCorrection(correction1);
  await database.insertCorrection(correction2);
  await database.insertCorrection(correction3);
  await database.insertCorrection(correction4);
  await database.insertCorrection(correction5);

  final List<int> mistakeErrorList = [130, 220, 75, 1];

  var mistakeLocalId = 0;
  for (var i = 1; i < 5; i++) {
    final int numErrors = mistakeErrorList[i - 1];
    var list = new List<int>.generate(numErrors, (int index) => index);
    list.shuffle();
    for (var j = 0; j < numErrors; j++) {
      final MistakeModel mistakeModel = MistakeModel(
        commentary: "",
        localId: mistakeLocalId,
        wordIndex: list[j],
        correctionId: i,
      );
      await database.insertMistake(mistakeModel);
      mistakeLocalId += 1;
    }
  }

  final CorrectionModel correction6 =
      CorrectionModel(localId: 6, textId: 2, studentId: 2);
  final CorrectionModel correction7 =
      CorrectionModel(localId: 7, textId: 4, studentId: 2);
  final CorrectionModel correction8 =
      CorrectionModel(localId: 8, textId: 6, studentId: 2);
  final CorrectionModel correction9 =
      CorrectionModel(localId: 9, textId: 8, studentId: 2);
  final CorrectionModel correction10 =
      CorrectionModel(localId: 10, textId: 10, studentId: 2);

  await database.insertCorrection(correction6);
  await database.insertCorrection(correction7);
  await database.insertCorrection(correction8);
  await database.insertCorrection(correction9);
  await database.insertCorrection(correction10);

  final List<int> mistakeErrorList2 = [3, 1, 2, 1, 2];

  for (var i = 6; i < 11; i++) {
    final int numErrors = mistakeErrorList2[i - 6];
    var list = new List<int>.generate(130, (int index) => index);
    list.shuffle();
    for (var j = 0; j < numErrors; j++) {
      final MistakeModel mistakeModel = MistakeModel(
        commentary: "",
        localId: mistakeLocalId,
        wordIndex: list[j],
        correctionId: i,
      );
      await database.insertMistake(mistakeModel);
      mistakeLocalId += 1;
    }
  }
}
