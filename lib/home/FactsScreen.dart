import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:voter_grievance_redressal/home/FactsScreenPages.dart';

class FactsScreen extends StatefulWidget {
  @override
  _FactsScreenState createState() => _FactsScreenState();
}


class _FactsScreenState extends State<FactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return FactsScreenPages(index:index);
            },
            itemCount: 3,
            pagination: new SwiperPagination(),
            viewportFraction: 0.95,
            scale: 0.5,
//            itemWidth: 370.0,
//            itemHeight: 700.0,
//            layout: SwiperLayout.STACK,
          ),
        ),
      ),
    );
  }
}
