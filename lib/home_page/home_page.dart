
import 'package:country_directory/home_page/country_details.dart';
import 'package:flutter/material.dart';
import '../utils/api.dart';
import '../model/final_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var countries;

  var searchedCountry = [];
  var searchIndexPosition = [];
  Future<void> searchResults(String query)async {
    searchIndexPosition.clear();
    List dummySearchList = [];
    dummySearchList.addAll(countries);
    if(query.isNotEmpty) {
      List dummyListData = [];
      for (var item in dummySearchList){
        if(item.name.toString().toLowerCase().contains(query.toLowerCase()))   {
          setState(() {
            dummyListData.add(item);
          });
          setState(() {
            searchedCountry.clear();
            searchedCountry.addAll(dummyListData);
            searchIndexPosition.clear();
            for(var i=0; i<searchedCountry.length; i++){
              final index = dummySearchList.indexWhere((element) =>
              element.name == searchedCountry[i].name);
              searchIndexPosition.add(index);
              debugPrint(index.toString());
            }
            if(searchIndexPosition.isEmpty){


            }else{

            }
          }
          );
          searchedCountry.clear();
          for(var i=0; i<searchIndexPosition.length; i++){
            searchedCountry.add(countries[int.parse(searchIndexPosition[i].toString())]);
          }
          return;
      }
      }
    }else {
      setState(() {
        searchedCountry.clear();
      });
    }
  }

  Future<List<Country>> future = getAllCountries();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text("Country Directory"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter country name',
                ),
                onChanged: (value) {
                  searchResults(value); },
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: future,
                builder: (context, snapshot) {
                  return pickCountriesWidget(context, snapshot);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget pickCountriesWidget(BuildContext context,
      AsyncSnapshot<List<Country>> snapshot) {
    countries = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      return searchedCountry.isEmpty?ListView.builder(
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index){
            Country project = snapshot.data![index];
            snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CountryDetails(ccode: project.code!,)));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(
                          color: Colors.white54, // Set border color
                          width: 2.0),   // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8.0)), // Set rounded corner radius
                      boxShadow: const [
                        BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                       children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFFFFF),
                          child: Text(project.code.toString()),

                        ),
                        const SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.name.toString(),style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                            // Text(project.code.toString(),style: const TextStyle(fontStyle: FontStyle.italic),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }):ListView.builder(
          itemCount: searchedCountry.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index){
            Country project = searchedCountry[index];
            snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CountryDetails(ccode: project.code!,)));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(
                          color: Colors.white54, // Set border color
                          width: 2.0),   // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8.0)), // Set rounded corner radius
                      boxShadow: const [
                        BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFFFFF),
                          child: Text(project.code.toString()),

                        ),
                        const SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.name.toString(),style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                            // Text(project.code.toString(),style: const TextStyle(fontStyle: FontStyle.italic),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });

    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}



