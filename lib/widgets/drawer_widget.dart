import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/screens/home_movies_screen.dart';
import 'package:cinema_db/screens/saved_screen.dart';
import 'package:cinema_db/screens/series_screen.dart';
import 'package:cinema_db/screens/test_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ThemeController themeController = Get.put(ThemeController());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(35),bottomRight: Radius.circular(70)),
        child: Drawer(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: (){
                      Get.offAll(()=>HomeMoviesScreen());
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.cyan
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                            }, icon:Icon(FontAwesomeIcons.home),iconSize: 30,),
                            SizedBox(width: 10,),
                            Text('Home',style: TextStyle(fontSize: 22),),
                          ],
                        ))),

                  SizedBox(height: 20,),

                  GestureDetector(
                      onTap: (){
                        Get.offAll(()=>SeriesScreen());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.blue
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(onPressed: (){
                                //Get.to(HomeScreen());
                              }, icon:Icon(FontAwesomeIcons.photoVideo),iconSize: 30,),
                              SizedBox(width: 10,),
                              Text('Series',style: TextStyle(fontSize: 22),),
                            ],
                          ))),
                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: (){
                      themeController.isDarkModeEnabled.value = !themeController.isDarkModeEnabled.value;
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.pink
                        ),
                        child:
                        Obx(()=> Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){}, icon: themeController.isDarkModeEnabled.value==true? Icon(FontAwesomeIcons.solidSun,):
                            Icon(FontAwesomeIcons.moon),iconSize: 30,),
                            Text(themeController.modeText,style: TextStyle(fontSize: 22),),
                          ],
                        ))),
                  ),

                  SizedBox(height: 20,),



                  GestureDetector(
                    onTap: (){
                      Get.to(()=>SavedScreen(),transition: Transition.fadeIn,curve: Curves.easeInOutSine);
                      //Get.to(()=>TestScreen());
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.orange
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.bookmark),iconSize: 30,),
                            Text('Saved',style: TextStyle(fontSize: 22),),
                          ],
                        )),
                  ),





                ],

            ),
          ),
        ),

      ),
    );
  }
}