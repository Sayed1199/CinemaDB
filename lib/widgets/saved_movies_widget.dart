
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedMoviesWidget extends StatelessWidget {
  final List<MovieModel> moviesList;
   SavedMoviesWidget({Key? key,required this.moviesList}) : super(key: key);

  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        SizedBox(
          height: MediaQuery.of(context).size.height*0.6,
          width: MediaQuery.of(context).size.width,
          child:  CupertinoScrollbar(
            child: Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moviesList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>

                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child:  Container(
                                  height: MediaQuery.of(context).size.height*0.5,
                                  width: MediaQuery.of(context).size.width*0.6,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          image:
                                          NetworkImage(imageTmdbApiLink+ moviesList[index].posterPath!)
                                      )
                                  )
                              ),
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width/2,
                            child: Center(
                              child: Obx(()=>
                                  Text(moviesList[index].title==null?'':moviesList[index].title!,
                                    maxLines: 2,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis, style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                    ),),
                              ),
                            ),),


                        ],
                      ),




                )
            ),
          ),

        ),
      ],
    );

  }
}
