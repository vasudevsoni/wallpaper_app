import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../models/wallpaper_model.dart';
import '../widgets/widget.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoading = false;
  List<WallPaperModel> wallpapers = [];

  getCategoryWallpapers(String categoryName) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(
        'https://api.pexels.com/v1/search?query=$categoryName&per_page=5');
    var response = await http.get(url, headers: {
      'Authorization': apiKey,
    });

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> photos = jsonData['photos'];
    for (var element in photos) {
      WallPaperModel wallpaperModel = WallPaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoryWallpapers(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String category = widget.categoryName;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Category',
          style: GoogleFonts.kanit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    category,
                    style: GoogleFonts.kanit(
                      color: const Color(0xfff8bc11),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffbc4749),
                        ),
                      )
                    : wallpapersList(
                        wallpapers: wallpapers,
                        context: context,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
