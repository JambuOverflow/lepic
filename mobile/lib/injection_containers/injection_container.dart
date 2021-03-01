import 'classroom_injection_container.dart' as classroomSl;
import 'student_injection_container.dart' as studentSl;
import 'text_injection_container.dart' as textSl;
import './audio_injection_container.dart' as audioSl;
import './correction_container.dart' as correctionSl;
import './user_injection_container.dart' as userSl;
import './statistic_injection_container.dart' as statisticSl;

void setUpServiceLocator() {
  userSl.init();
  classroomSl.init();
  studentSl.init();
  textSl.init();
  audioSl.init();
  correctionSl.init();
  statisticSl.init();
}
