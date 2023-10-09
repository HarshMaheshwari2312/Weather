import 'dart:developer';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:weathercast/constants/constants.dart';
import 'package:weathercast/logic/models/weather_model.dart';
import 'package:weathercast/logic/services/call_to_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "");
  Future<WeatherModel>? _myData;
  @override
  void initState() {
    setState(() {
      _myData = getData(true, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(100, 65, 89, 224),
                      Color.fromARGB(255, 83, 50, 215),
                      Color.fromARGB(255, 80, 88, 177),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimSearchBar(
                        rtl: true,
                        width: 400,
                        color: Color(0xffffb56b),
                        textController: textController,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 26,
                        ),
                        onSuffixTap: () async {
                          textController.text == ""
                              ? log("No city entered")
                              : setState(() {
                                  _myData = getData(false, textController.text);
                                });

                          FocusScope.of(context).unfocus();
                          textController.clear();
                        },
                        style: f14RblackLetterSpacing2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.city,
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,// Adjust the font size as needed
                                color: Colors.white,
                                // Add other text style properties if needed
                              ),
                            ),
                            SizedBox(height: 25), // Add spacing between temperature and wind speed
                            const Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,// Adjust the font size as needed
                                color: Colors.white,
                                // Add other text style properties if needed
                              ),
                            ),
                            SizedBox(height:10),
                            Text(
                              data.desc,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,// Adjust the font size as needed
                                color: Colors.white,
                                // Add other text style properties if needed
                              ),
                            ),
                            SizedBox(height: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 25), // Add spacing between temperature and wind speed
                                const Text(
                                  "Temperature",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,// Adjust the font size as needed
                                    color: Colors.white,
                                    // Add other text style properties if needed
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${data.temp}°C",
                                  style: f42Rwhitebold,
                                ),
                                SizedBox(height: 25), // Add spacing between temperature and wind speed
                                const Text(
                                  "Wind Speed",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,// Adjust the font size as needed
                                    color: Colors.white,
                                    // Add other text style properties if needed
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${data.windSpeed} km/h", // You can format it as needed
                                  style: f42Rwhitebold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}
