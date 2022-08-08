import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaticContent extends StatelessWidget {
  const StaticContent({
    required this.readData,
    Key? key,
  }) : super(key: key);

  final Future<List<dynamic>> Function() readData;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: MediaQuery.of(context).size.height * 0.76,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
      child: FutureBuilder(
        future: readData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            ///in case it is unable to load the local file
            return const Text("Error in loading the file");
          } else if (snapshot.hasData) {
            ///converting the object into the data type
            var data = snapshot.data as List<dynamic>;
            return ListView(
              children: data.map((value) {
                var oneSection = value as Map<String, dynamic>;

                ///one section represent one topic
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: oneSection.keys.map((e) {
                    if (e == "heading") {
                      return Column(
                        children: [
                          Text(
                            oneSection[e],
                            softWrap: true,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          )
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Text(
                            oneSection[e],
                            softWrap: true,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }
                  }).toList(),
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
