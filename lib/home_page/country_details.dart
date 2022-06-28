import 'package:flutter/material.dart';

import '../model/model.dart';
import '../utils/api.dart';
class CountryDetails extends StatefulWidget {
  const CountryDetails({Key? key, required this.ccode}) : super(key: key);
  final String ccode;

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  List<Country> countries = [];
  Country? selectedCountry;
  Future<List<Country>>? future;




Widget countryDetailsWidget(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  if (snapshot.hasError) {
    return const Center(
      child: Text("Unable to fetch country data"),
    );
  }
  Country country = snapshot.data;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 10),
      Center(child: Text(country.emoji.toString(), style: const TextStyle(fontSize: 100),)),
      const SizedBox(height: 20,),
      Text(country.name.toUpperCase(), textAlign:TextAlign.center,style: const TextStyle(
        fontSize: 30, fontWeight: FontWeight.w500, letterSpacing: 1,height: 1.5,
        color: Colors.indigo
      ),),
      SizedBox(height: 20,),
      Text(country.native.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,fontSize: 30),),
      SizedBox(height: 20,),
      Text(country.currency.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.indigo ),),
      SizedBox(height: 20,),
      Text(country.capital.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.indigo),),
      SizedBox(height: 20,),
      Text(country.code.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.indigo),),


      
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text("Country Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<Country>(
                future: getCountry(widget.ccode),
                builder: (context, snapshot) {
                  return countryDetailsWidget(context, snapshot);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


