import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../model/final_model.dart';
class CountryDetails extends StatefulWidget {
  const CountryDetails({Key? key, required this.ccode}) : super(key: key);
  final String ccode;
  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
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

  return Card(
    elevation:10,
    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Colors.lightBlueAccent,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Center(child: Text(country.emoji.toString(), style: const TextStyle(fontSize: 100),)),
        const SizedBox(height: 20,),
        Text("NAME : "+country.name!.toUpperCase(), textAlign:TextAlign.center,style: const TextStyle(
          fontSize: 30, fontWeight: FontWeight.w500, letterSpacing: 1,height: 1.5,
          color: Colors.indigo
        ),),
        const SizedBox(height: 10,),
        Text("NATIVE : "+country.native.toString(),style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 30),),
        const SizedBox(height: 10,),
        Text("CURRENCY : "+country.currency.toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.indigo ),),
        const SizedBox(height: 10,),
        Text("CAPITAL : "+country.capital.toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.indigo),),
        const SizedBox(height: 10,),
        Text("CODE : "+country.code.toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.indigo),),
        const SizedBox(height: 10,),
        Text("PHONE : "+country.phone.toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.indigo),),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,

          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: country.languages!.length,
              itemBuilder: (BuildContext ctx2, index2){
                Languages lang = country.languages![index2];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Center(
                      child: Card(
                        color: Colors.yellow.shade700,
                        child: Text("    LANGUAGE : "+
                          lang.name.toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.indigo),),
                      ),
                    ),
                    ),
                  );
              }),
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
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


