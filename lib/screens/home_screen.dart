import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

import '../data/data.dart';
import '../models/categories_model.dart';
import '../models/wallpaper_model.dart';
import '../widgets/widget.dart';
import '../screens/search_screen.dart';
import '../screens/category_screen.dart';
import '../screens/image_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  List<CategoriesModel> categories = [];
  List<WallPaperModel> wallpapers = [];

  getTrendingWallpapers() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('https://api.pexels.com/v1/curated?per_page=15');
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wallsy ',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.kanit(
                            color: const Color(0xfff8bc11),
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff222323),
                            border: Border.all(
                              color: const Color(0xfff8bc11),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '4K',
                              style: GoogleFonts.kanit(
                                color: const Color(0xfff8bc11),
                                fontSize: 22,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Wallpapers',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.kanit(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff222323),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for wallpapers...',
                          hintStyle: GoogleFonts.kanit(
                            color: const Color(0xff606268),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchScreen(
                                  searchQuery: searchController.text,
                                );
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enter something to search'),
                            ),
                          );
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Color(0xff686c75),
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Color(0xff686c75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      imgUrl: categories[index].imageUrl,
                      title: categories[index].categoryName,
                    );
                  },
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Curated wallpapers for you ',
                      style: GoogleFonts.kanit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Icon(
                      Ionicons.heart,
                      color: Color(0xfff8bc11),
                      size: 20,
                    ),
                  ],
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
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  const CategoryTile({
    Key? key,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CategoryScreen(categoryName: title);
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    shadows: <Shadow>[
                      const Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 10.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
