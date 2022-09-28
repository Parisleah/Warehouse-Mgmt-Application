import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImgCarousel extends StatefulWidget {
  List<String> images;

  ImgCarousel(this.images);

  @override
  State<ImgCarousel> createState() => _ImgCarouselState();
}

class _ImgCarouselState extends State<ImgCarousel> {
  int activePage = 1;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 180,
          child: PageView.builder(
              itemCount: widget.images.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                          image: AssetImage(widget.images[pagePosition]))),
                );
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(widget.images.length, activePage))
      ],
    );
  }
}
