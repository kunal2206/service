import 'package:carousel_slider/carousel_slider.dart';
import 'package:fixpals_app/app/core/constants/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({
    required this.carouselUrl,
    Key? key,
  }) : super(key: key);

  final List<String> carouselUrl;

  @override
  Widget build(BuildContext context) {
    Rx<String> currentSlideUrl = "".obs;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Stack(children: [
        carouselUrl.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: cafeAuLait,
                  ),
                ),
              )
            : CarouselSlider(
                items: carouselUrl.map((url) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              url,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.25,
                    viewportFraction: 1,
                    autoPlay: true,
                    onPageChanged: (index, reason) =>
                        currentSlideUrl.value = carouselUrl[index]),
              ),
        Positioned(
          bottom: 10.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselUrl
                  .map(
                    (dotUrl) => Container(
                      height: MediaQuery.of(context).size.height * 0.015,
                      width: MediaQuery.of(context).size.height * 0.015,
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.015),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: currentSlideUrl.value == dotUrl
                            ? Colors.amber
                            : Colors.grey,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ]),
    );
  }
}
