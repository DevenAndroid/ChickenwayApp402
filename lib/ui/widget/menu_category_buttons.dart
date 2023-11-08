import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controller/menu_controller.dart';

class MenuButtonsList extends StatefulWidget {
  const MenuButtonsList({Key? key}) : super(key: key);

  @override
  State<MenuButtonsList> createState() => _MenuButtonsListState();
}

class _MenuButtonsListState extends State<MenuButtonsList> {
  final menuController = Get.put(ProductsMenuController());
  @override
  void initState() {
    super.initState();
    menuController.autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal,
        suggestedRowHeight: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (menuController.selectedIndex.value > 0) {}
      return SizedBox(
        height: 45,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            controller: menuController.autoScrollController!,
            scrollDirection: Axis.horizontal,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: menuController.forMenuScreen.entries.length,
            itemBuilder: (context, index) {
              return AutoScrollTag(
                controller: menuController.autoScrollController!,
                index: index,
                key: ValueKey(index),
                highlightColor: Colors.transparent,
                child: menuButtons(
                    menuController.selectedIndex.value == index, index),
              );
            }),
      );
    });
  }

  Padding menuButtons(bool selected, int index) {
    final menu = menuController.forMenuScreen.entries.toList()[index].value;
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Container(
        decoration: BoxDecoration(
            border: selected
                ? const Border(
                    bottom: BorderSide(color: Colors.red, width: 2.4))
                : null),
        child: InkWell(
          onTap: () async {
            final keyContext = menu.menuKeyLower.currentContext;
            if (keyContext != null) {
              Scrollable.ensureVisible(keyContext,
                      curve: Curves.ease,
                      alignment: .02,
                      duration: const Duration(seconds: 1))
                  .then((value) {
                menuController.selectedIndex.value = index;
              });
            }
          },
          child: Row(
            children: [
              if (selected)
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    menu.iconCate.toString(),
                    width: 20,
                    height: 20,
                  ),
                ),
              SizedBox(
                width: selected ? 4 : 2,
              ),
              Text(menu.name.toString(),
                  style: GoogleFonts.poppins(
                      decorationThickness: 3,
                      height: 1.2,
                      color: selected ? Colors.red : const Color(0xff555555),
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
