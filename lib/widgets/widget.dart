import 'package:flutter/material.dart';

import '../models/wallpaper_model.dart';
import '../screens/image_screen.dart';

Widget wallpapersList({required List<WallPaperModel> wallpapers, context}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 20,
    ),
    child: GridView.count(
      shrinkWrap: true,
      childAspectRatio: 0.6,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: wallpapers.map((wall) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ExpandImage(
                      imgUrl: wall.src!.portrait.toString(),
                      photographerId: wall.photographerId.toString(),
                      photographerName: wall.photographerName.toString(),
                      photographerUrl: wall.photgrapherUrl.toString(),
                      altText: wall.altText.toString(),
                    );
                  },
                ),
              );
            },
            child: Hero(
              tag: wall.src!.portrait.toString(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  wall.src!.portrait.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
