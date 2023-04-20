
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      bottom: TabBar(
        tabs: [
          Tab(
            child: Column(
              children: [
                Icon(
                  Icons.format_list_bulleted_rounded ,
                  color: fColor,
                ),
                Text(
                  'All',
                  style: TextStyle(color: fColor),
                )
              ],
            ),
          ),
          Tab(
            child: Column(
              children: [
                Icon(
                  Icons.donut_large,
                  color: fColor,
                ),
                Text(
                  'Ongoing',
                  style: TextStyle(color: fColor),
                )
              ],
            ),
          ),
          Tab(
            child: Column(
              children: [
                Icon(Icons.checklist_rounded, color: fColor),
                Text('Finished',
                    style: TextStyle(color: fColor))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
