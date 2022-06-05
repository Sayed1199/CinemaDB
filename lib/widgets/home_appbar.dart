import 'package:cinema_db/controllers/home_search_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/widgets/home_searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatefulWidget {
  final bool isMovie;
   HomeAppBar({Key? key,required this.isMovie}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with TickerProviderStateMixin{

  HomeSearchController searchController = Get.put(HomeSearchController());
  ThemeController themeController = Get.put(ThemeController());
  late TextEditingController textEditingController;
  String searchQuery='';
  double angle=0;
  late AnimationController clearQueryAnimController;
  late Animation<double> clearQueryAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController= TextEditingController();
    clearQueryAnimController = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    clearQueryAnimation = Tween<double>(begin: 0,end: math.pi*2).animate(clearQueryAnimController);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
    clearQueryAnimController.dispose();
  }

  void _startSearching(){
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    searchController.isSearching.value=true;
  }

  void _stopSearching() {
    _clearSearchQuery();
    searchController.isSearching.value=false;
  }

  void _clearSearchQuery() {
    textEditingController.clear();
    searchController.searchQuery.value='';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Obx(()=>
          searchController.isSearching.value==false?
        Obx(()=>
           Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text:'Cinema',style: GoogleFonts.lato(
                      fontSize: 24,color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black,
                      fontWeight: FontWeight.w400
                    )),
                    TextSpan(text:'DB',style: TextStyle(fontSize: 22,color: Colors.pink,fontWeight: FontWeight.w500)),
                  ]
              )
          ),
        ):HomeSearchbar(textEditingController: textEditingController,ismovie: widget.isMovie,),
      ),

      leading: Obx(()=>
        searchController.isSearching.value==false? IconButton(onPressed: (){
          Scaffold.of(context).openDrawer();
        }, icon: Image.asset('assets/images/menu0.png',width: 30,height: 30,
            color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black
        ),):
        AnimatedBuilder(
            animation: clearQueryAnimation,
            child: IconButton(onPressed: (){
              textEditingController.clear();
              searchController.searchQuery.value='';
            }, icon: Icon(CupertinoIcons.clear,size: 30,color: Colors.blue,)),
            builder: (context,child){
              print('Animation Started');
              return Container(
                child: Transform.rotate(angle: clearQueryAnimation.value,
                  child: Container(
                    child: child,
                  ),
                ),
              );
            }),
      ),
      actions: [
        Obx(()=>
           Padding(
            padding: const EdgeInsets.only(right: 5),
            child: searchController.isSearching.value==false? IconButton(onPressed: (){
                searchController.isSearching.value=true;
                print('Started');
                setState(() {
                  clearQueryAnimController.forward(from: 0);
                });
                _startSearching();
            }, icon: Icon(CupertinoIcons.search,color: Colors.blue,size: 30,)):
            IconButton(onPressed: (){
              searchController.isSearching.value=false;
              print('closed');
            }, icon: Icon(CupertinoIcons.right_chevron,color: Colors.red,size: 30,)),
          ),
        ),
      ]

    );
  }
}
