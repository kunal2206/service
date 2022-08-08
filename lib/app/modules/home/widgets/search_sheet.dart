import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../data/models/service.dart';
import '../../../global_widgets/popular_searches.dart';
import '../../../global_widgets/search_results.dart';

class SearchSheet extends StatelessWidget {
  const SearchSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: lightOrange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel_outlined, color: white),
                      ),
                    ],
                  ),
                ),
              ),
              searchArea(context),
              SizedBox(
                height: constraints.maxHeight * 0.78,
                width: constraints.maxWidth,
                child: LayoutBuilder(builder: ((context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: SearchResults()),
                        PopularSearches(),
                      ],
                    ),
                  );
                })),
              ),
            ],
          );
        }));
  }

  Widget searchArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
      child: TextFormField(
        //controller: textController,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Search any service',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(40, 20, 20, 20),
          suffixIcon: const Icon(
            Icons.search_rounded,
            color: dark,
            size: 22,
          ),
        ),
        style: Theme.of(context).textTheme.bodyText1,
        onFieldSubmitted: (value) {
          fetchSearchResults(value);
        },
      ),
    );
  }
}
