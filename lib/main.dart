import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/view/screen/authScreen/AuthContainer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
  // runApp(ExampleApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
      title: 'Critical X Quiz',
      defaultTransition: Transition.fadeIn,

      /* initialRoute: AuthContainer.id,
      routes: {
        AuthContainer.id: (context) => AuthContainer(),
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        QuestionScreen.id: (context) => QuestionScreen(),
        ScoreAnsExplanationScreen.id: (context) => ScoreAnsExplanationScreen(),
        CheckAnsExplanationScreen.id: (context) => CheckAnsExplanationScreen(),
        ForumScreen.id: (context) => ForumScreen(),
        ForumDiscussion.id: (context) => ForumDiscussion(),
        PostAQuestionScreen.id: (context) => PostAQuestionScreen(),
      },*/

      home: MyHomePage(),
      // home: PremiumProgressDialog(),
      builder: (BuildContext context, Widget child) {
        /// make sure that loading can be displayed in front of all other widgets
        return FlutterEasyLoading(child: child);
      },

      //    home: ForgetPasswordPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session();
  }

  session() {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      if (FirebaseAuth.instance.currentUser == null) {
        //  Get.off(AuthContainer());
        print("ok");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AuthContainer()));
      } else {
        //   Get.offAll(HomeScreen());
        AppRouter.navToHomePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
