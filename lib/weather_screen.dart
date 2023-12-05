import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/scrollforecast.dart';
import 'package:http/http.dart' as http;
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

        //in api left side always string for names right side values differ
  Future<Map<String,dynamic>> currentweather()async{
    try{
      String cityname = "Mumbai";
    final res =  await http.get(
      Uri.parse(
      "http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openweatherapikey"
      )
    );
    final data = jsonDecode(res.body);//used to decode the content in api
    if(data['cod']!= '200'){
      throw "unexpected error occured";
    }
    // setState(() {
    //  temp=  data['list'][0]['main']['temp'];
    // });
    return data;

    }catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  AppBar(
      title: const Text(
        'Weather App',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
            });
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),

      body:  //for loading                       snapshot is state or progress
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: currentweather(),
          builder: (context, snapshot) {
            print(snapshot);
            print(snapshot.runtimeType);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive()); //adopts for ios/android
            }
            if(snapshot.error != null){
              return Center(child: Text(snapshot.error.toString()));   //or    Text("${snapshot.error}")
            }

            final data = snapshot.data!;
            final currentweatherdata = data['list'][0];
            final currenttemp = data['list'][0]['main']['temp'];
            final currentsky = data['list'][0]['weather'][0]['main'];
            final currentpressure = currentweatherdata["main"]["pressure"];
            final currentwindspeed = currentweatherdata["wind"]["speed"];
            final currenthumidity = currentweatherdata["main"]["humidity"];
            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: double.infinity,
                child: Card(elevation: 10,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child:   Column(children: [Text("$currenttemp°K",style: const TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                      Icon(currentsky == "Clouds" || currentsky == "Rain" ? Icons.cloud : Icons.sunny,size: 64),
                      Text("$currentsky",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold))],),
                    ),
                  ),
                ),)),
                
                const SizedBox(height: 20),


                  //.............................hourly forecast.....................................


                const Text("Hourly Forecast",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,color: Colors.white),),

                const SizedBox(height: 8),

              // SingleChildScrollView(scrollDirection: Axis.horizontal,
              //     child: Row(children: [
              //      for(int i=0;i<5;i++)
              //         Scrollcard(time: data["list"][i+1]['dt'].toString()
              //         ,icon: data['list'][i+1]['weather'][0]['main']=="Clouds" ||  data['list'][i+1]['weather'][0]['main'] == "Rain" ? Icons.cloud:Icons.sunny,
              //         temperature:data["list"][i+1]['dt']['main']['temp'].toString()),

              //     //  Scrollcard(time: "4.00",icon: Icons.sunny,temperature: "300.2"),
              //     //  Scrollcard(time: "5.00",icon: Icons.sunny,temperature: "300.1"),
              //     //  Scrollcard(time: "6.00",icon: Icons.cloud,temperature: "301.2"),
              //     //  Scrollcard(time: "7.00",icon: Icons.cloud,temperature: "301.2"),
              //     ],),
              //   )  ,
                // SizedBox(
                // height: 120,

                  SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return Scrollcard(
                        time: DateFormat.j().format(time),
                        temperature: hourlyTemp,
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
      const SizedBox(height: 20),


              //........................................Additional Information..........................................


                const Text("Additional Information",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,color: Colors.white),),

                  SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                  Addinfo(icon: Icons.water_drop,iconColor: Color.fromARGB(255, 147, 192, 229), label: 'Humidity',value: "$currenthumidity",),
                  Addinfo(icon: Icons.air,iconColor: Color.fromARGB(255, 204, 217, 240), label: 'WindSpeed',value: "$currentwindspeed",),
                  Addinfo(icon: Icons.beach_access,iconColor: const Color.fromARGB(255, 82, 110, 125), label: 'Pressure',value: "$currentpressure",),


                  ],) ,
                ],
            ),
            );
            },
          ),
      )
    );
  }
}






