import 'package:cinema_db/controllers/save_series_controller.dart';
import 'package:cinema_db/controllers/saved_movies_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/widgets/saved_movies_widget.dart';
import 'package:cinema_db/widgets/saved_series_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with SingleTickerProviderStateMixin{

  SaveMoviesController savedMoviesController = Get.put(SaveMoviesController());
  SaveSeriesController savedSeriesController = Get.put(SaveSeriesController());
  ThemeController themeController = Get.put(ThemeController());
  List<String> pages = ['Movies','Series'];
  late TabController tabController;

  int currentTabIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: pages.length,vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body: CustomScrollView(
        slivers: [
          SliverAppBar(
              leading: IconButton(onPressed: (){
                Get.back();
              }, icon: Icon(CupertinoIcons.left_chevron,color: Colors.blue,size: 30,)),
              elevation: 0.0,
              pinned: true,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text('Saved',style: TextStyle(fontSize: 22,
                  color: themeController.isDarkModeEnabled.value==false?Colors.black:Colors.white),),
          bottom: TabBar(
            onTap: (index){
              print('Index: ${index}');
              setState(() {
                currentTabIndex=index;
              });
            },
            controller: tabController,
            tabs: pages.map((e) {
              return Tab(child: Text(e,style: TextStyle(color: Colors.cyan,fontSize: 20),),);
            }).toList(),
          ),
          ),

          SliverFillRemaining(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: currentTabIndex==0? Builder(
                    builder: (context){
                      print('curIndex: ${currentTabIndex}');
                      savedMoviesController.getSavedMovies();
                      return Obx(()=>
                      savedMoviesController.savedMoviesList.value==null?
                          Center(
                            child: CircularProgressIndicator(),
                          ):savedMoviesController.savedMoviesList.value!.isNotEmpty?Center(
                            child: Container(
                        child: SavedMoviesWidget(moviesList: savedMoviesController.savedMoviesList.value!),
                      ),
                          ):Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset('assets/images/empty0.jpg')),
                              ),
                              SizedBox(height: 20,),
                              Text('no Saved Movies...',style: TextStyle(fontSize: 22),),
                            ],
                          ),
                        ),
                      ),
                      );
                    }
                ):Builder(
                    builder: (context){
                      savedSeriesController.getSavedSeries();
                      return Obx(()=>
                      savedSeriesController.savedSeriesList.value==null?
                      Center(
                        child: CircularProgressIndicator(),
                      ):savedSeriesController.savedSeriesList.value!.isNotEmpty?Center(
                        child: Container(
                          child: SavedSeriesWidget(seriesList: savedSeriesController.savedSeriesList.value!),
                        ),
                      ):Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(currentTabIndex==0? 'assets/images/empty0.jpg': 'assets/images/empty1.jpg')),
                              ),
                              SizedBox(height: 20,),
                              Text(currentTabIndex==0? 'no Saved Movies...':'No Saved Series...',style: TextStyle(fontSize: 22),),
                            ],
                          ),
                        ),
                      ),
                      );
                    }
                ),
              ),
            ),
          )

        ],
      ),

    );
  }
}
