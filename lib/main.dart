import 'package:cinema_db/controllers/intro_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Get.put(IntroController());
  Get.put(ThemeController());

  final prefs = await SharedPreferences.getInstance();
  final String? readPrefs = prefs.getString('mode');
  if(readPrefs != null){
    if(readPrefs=='dark'){
      print('Moide: dark');
      Get.changeTheme(ThemeData.dark());
    }else if(readPrefs=='light'){
      print('Moide: light');
      Get.changeTheme(ThemeData.light());
    }else{
    }
  }else{
    print('Moide: null');
    await prefs.setString('mode', 'dark');
    Get.changeTheme(ThemeData.dark());
    ThemeController().isDarkModeEnabled.value=true;
  }


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'CinemaDB',
      home: Scaffold(
        body: Center(
          child: LoadingWidget(),
        ),
      ),

    );
  }
}


















