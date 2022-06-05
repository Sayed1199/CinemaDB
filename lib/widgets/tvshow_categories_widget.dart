import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/controllers/tvshow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TvShowCategoriesWidget extends StatelessWidget {
  final List<String> categoriesList;
  TvShowCategoriesWidget({Key? key,required this.categoriesList}) : super(key: key);

  TvShowController categoryController = Get.put(TvShowController());
  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) => Obx(
              ()=> Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                categoryController.selectedCategory.value=index;

              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoriesList[index],
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: index == categoryController.selectedCategory.value
                            ?themeController.isDarkModeEnabled.value?
                        Colors.white:Colors.black
                            : themeController.isDarkModeEnabled.value?
                        Colors.white.withOpacity(0.4):
                        Colors.black.withOpacity(0.4)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical:  13),
                    height: 6,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index == categoryController.selectedCategory.value
                          ? Colors.pink
                          : themeController.isDarkModeEnabled.value?
                      Colors.white.withOpacity(0.2):
                      Colors.black.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        itemCount: categoriesList.length,
        scrollDirection: Axis.horizontal,
      ),
    );

  }
}
