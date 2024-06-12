import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

DateFormat dateFormat = DateFormat("dd.MM.yyyy");

class PlotPage extends StatefulWidget {
  final Future<Map<String, dynamic>?> apiResult;
  final List<DateTime> dates;

  const PlotPage({super.key, required this.apiResult, required this.dates});

  @override
  State<PlotPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PlotPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.apiResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)));
          } else if (snapshot.data == null || snapshot.hasError) {
            return const Scaffold(body: Center(child: Text("за выбранный период нет информации")));
          } else {
            print(snapshot.data!);
            return Scaffold(
              appBar: AppBar(
                title: Text("${dateFormat.format(widget.dates[0])} - ${dateFormat.format(widget.dates[1])}"),
              ),
              body: Container(
                  color: Colors.black12,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Padding(padding: const EdgeInsets.all(30), child: PropertiesListWidgetClass(
                          properties: snapshot.data!['properties']
                              .map((key, value) => MapEntry<String, String>(key, value))
                              .cast<String, String>())),
                      Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
                          child: ImagesListWidgetClass(urls: List<String>.from(snapshot.data!['images'] as List))),
                    ]),
                  )),
            );
          }
        });
  }
}

class ImagesListWidgetClass extends StatelessWidget {
  final List<String> urls;

  const ImagesListWidgetClass({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height - 200,
        width: MediaQuery.sizeOf(context).width,
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeFactor: 0.5,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            enableInfiniteScroll: false,
          ),
          items: urls.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: PhotoView(
                      tightMode: true,
                      imageProvider: CachedNetworkImageProvider(item),
                    ));
              },
            );
          }).toList(),
        ));
  }
}

class PropertiesListWidgetClass extends StatelessWidget {
  final Map<String, String> properties;
  const PropertiesListWidgetClass({super.key, required this.properties});

  List<Widget> _getPropertiesList(Map<String, String> properties) {
    List<Widget> res = [];
    for (var prop in properties.entries) {
      res.add(Container(
          height: 150,
          width: 150,
          child: Card(
            child: Center(
                child: Text(
              "${prop.key}: ${prop.value}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          )));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getPropertiesList(properties),
    ));
  }
}
