import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/utils/additional_info.dart';
import 'package:weather_app/utils/hourly_forcast_cards.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  double currentTemp = 0;
  String currentSkyCondition = '';
  double currentWindSpeed = 0;
  double currentHumidity = 0;
  double currentPressure = 0;

  TextEditingController cityController = TextEditingController();

  String cityName = 'London';
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    //try will catch any errors
    try {
      String apiKey = 'd2a9dcc49206fd45a213e200400c6ae9';

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          currentTemp = (data['main']['temp'] - 273.15);
          isLoading = false;
          currentSkyCondition = data['weather'][0]['main'];
          currentPressure = data['main']['pressure'] / 100;
          currentHumidity = data['main']['humidity'].toDouble();
          currentWindSpeed = data['wind']['speed'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }

      final hourlyResponse = await http.get(Uri.parse(
          'api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'));

      if (hourlyResponse.statusCode == 200) {
        final hourlyData = jsonDecode(hourlyResponse.body);

        print(hourlyData);
      } else {
        print('Error: ${response.statusCode}');
      }

    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName[0].toUpperCase() + cityName.substring(1),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              getCurrentWeather();

              print('Refresh');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Text('${currentTemp.toStringAsFixed(2)} °C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              )),
                          Icon(
                            currentSkyCondition == 'Clouds' ||
                                    currentSkyCondition == 'Mist' ||
                                    currentSkyCondition == 'Rain'
                                ? Icons.cloud
                                : Icons.wb_sunny,
                            size: 64,
                            color: currentSkyCondition == 'Clouds' ||
                                    currentSkyCondition == 'Mist' ||
                                    currentSkyCondition == 'Rain'
                                ? const Color.fromARGB(255, 48, 105, 133)
                                : const Color.fromARGB(255, 150, 115, 27),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            currentSkyCondition,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Hourly Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForcastCard(),
                        HourlyForcastCard(),
                        HourlyForcastCard(),
                        HourlyForcastCard(),
                        HourlyForcastCard(),
                        HourlyForcastCard()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Additional Info',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdditionalInfo(
                        title: 'Wind',
                        value: currentWindSpeed.toStringAsFixed(2),
                        icon: Icons.air,
                      
                      ),
                      AdditionalInfo(
                        title: 'Humidity',
                        value: currentHumidity.toStringAsFixed(2),
                        icon: Icons.water,
                      
                      ),
                      AdditionalInfo(
                        title: 'Pressure',
                        value: currentPressure.toStringAsFixed(2),
                        icon: Icons.arrow_downward,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Change Location'),
                                content: TextField(
                                  controller: cityController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter City Name'),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        cityName = cityController.text;
                                        isLoading = true;
                                      });
                                      getCurrentWeather();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              );
                            });
                      },
                      child: const Text(
                        'Change Location',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
