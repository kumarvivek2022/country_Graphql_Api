import 'package:country_directory/home_page/country_details.dart';
import 'package:country_directory/provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/api.dart';
import '../model/final_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? selectedLanguage;
  dynamic countries;
  dynamic allLanguage;
  Future<void> searchResults(String query, List savedCountry,
      List searchedItemsIndexPosition, List searchedItems) async {
    searchedItems.clear(); //to clear searched list items index
    searchedItemsIndexPosition.clear();
    List dummyList = [];  // initialise a dummy list
    dummyList.addAll(savedCountry); // to store all countries data on dummy list
    if (query.isNotEmpty) {
      List dummyListData = []; // to store list searched data for runtime if query is not empty
      for (var searchedCountry in dummyList) {
        if (searchedCountry.code.toString().toLowerCase() ==
            query.toLowerCase()) {
          dummyListData.add(searchedCountry); // to store searched data on the dummy list data
        }
      }
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems(dummyListData);
      Provider.of<CountryProvider>(context, listen: false).getIndexPosition([]);
      for (var i = 0; i < searchedItems.length; i++) {
        final index = dummyList.indexWhere(
                (element) => // to check the index of element
            element.code == searchedItems[i].code); // to match the element index with searched item index
        Provider.of<CountryProvider>(context, listen: false).getIndexPosition([index]);
      }
      if (searchedItemsIndexPosition.isEmpty) {
        // to check if the list is empty
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No country with this country code"),
        ));
      } else {
        const Text("Country found with this code");
      } // to clear the searched item list
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
      for (var i = 0; i < searchedItemsIndexPosition.length; i++) {
        Provider.of<CountryProvider>(context, listen: false).getSelectedItems([
          savedCountry[int.parse(searchedItemsIndexPosition[i].toString())]
        ]);
      }
    } else {
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
    }
  }


  Future<void> filterItem(String query, List searchedItemsIndexPosition,
      dynamic savedCountry,List searchedItems) async {
    print("Q: "+query.toString());
    print("searchedItemsIndexPosition: "+searchedItemsIndexPosition.toString());
    print("savedcountry: "+savedCountry.toString());

    searchedItems.clear();
    searchedItemsIndexPosition.clear();
    List dummySearchList = [];
    dummySearchList.addAll(savedCountry);
    if (kDebugMode) {
      print('printing data - '+dummySearchList.toString());
    }
    if(query.isNotEmpty) {
      List dummyListData = [];
      for (var item in dummySearchList) {
        debugPrint("data - "+ item.languages.toString());
        for(var i=0; i<item.languages.length; i++) {
          Languages lang = item.languages![i];
          if(lang.name.toString().toLowerCase()==query.toLowerCase()) {
            // setState(() {
              dummyListData.add(item);
            // });
          }
        }
      }
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems(dummyListData);
      Provider.of<CountryProvider>(context, listen: false).getIndexPosition([]);

      searchedItems.clear();
        searchedItems.addAll(dummyListData);
        searchedItemsIndexPosition.clear();
        for(var i=0; i<searchedItems.length; i++){
          final index = dummySearchList.indexWhere((element) =>
          element.code == searchedItems[i].code);
         // searchedItemsIndexPosition.add(index);
          Provider.of<CountryProvider>(context, listen: false).getIndexPosition([index]);
        }

      // searchedItems.clear();
      for(var i=0; i<searchedItemsIndexPosition.length; i++){
        Provider.of<CountryProvider>(context, listen: false).getSelectedItems;
        searchedItems.add(countries[int.parse(searchedItemsIndexPosition[i].toString())]);
      }
      return;
    } else {
      // setState(() {
      //   searchedItems.clear();
      // });
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
    }
  }

  void _modalBottomSheet(AsyncSnapshot<List<Languages>> snapshot,
      dynamic savedCountries, String? selectedLanguage, List searchedItemsIndexPosition, List searchedItems) {
    var languageList = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            children: List.generate(
                languageList!.length,
                    (index) {
                  Languages lang = languageList[index];
                  languageList.sort((a, b) => a.name!.compareTo(b.name!));
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        if(selectedLanguage.toString()!=lang.name.toString()) {
                           filterItem(lang.name.toString(),searchedItemsIndexPosition,savedCountries,searchedItems );
                          Provider.of<CountryProvider>(context, listen: false).addSelectedLanguage(lang.name.toString());
                        }else{
                          Provider.of<CountryProvider>(context, listen: false).addSelectedLanguage(null);
                          // setState(() {
                          //   searchedItemsIndexPosition.clear();
                          //   searchedItems.clear();
                          // });
                        }
                        Navigator.pop(context);
                      },
                      child: Text(lang.name.toString(), style: TextStyle(color: selectedLanguage.toString()!=lang.name.toString()?Colors.blue:Colors.red),),
                    ),
                  );
                }

            )
        );
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Loading")));
    }
  }
  Future<List<Languages>> futureLang = getAllLanguages();
  Future<List<Country>> future = getAllCountries();
  @override
  Widget build(BuildContext context) {
    final storedCountry = Provider.of<CountryProvider>(context).allCountryList;
    final selectedLanguage= Provider.of<CountryProvider>(context).selectedLanguage;
    final searchedItems= Provider.of<CountryProvider>(context).searchedItems;
    final searchedItemsIndexPosition= Provider.of<CountryProvider>(context).searchedItemsIndexPosition;
    debugPrint(storedCountry.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text("Country Directory"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 Expanded(
                   child: TextField(
                     decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Enter country name',
                     ),
                     onChanged: (value) {
                       searchResults(value, storedCountry, searchedItemsIndexPosition,
                           searchedItems); },
                   ),
                 ),
                 FutureBuilder<List<Languages>>(
                   future: futureLang,
                   builder: (context, snapshot) {
                     return Stack(
                       children: [
                         IconButton(
                             onPressed: (){
                               _modalBottomSheet(snapshot, storedCountry, selectedLanguage,searchedItemsIndexPosition,searchedItems);
                             },
                             icon: const Icon(Icons.sort)),
                         if(selectedLanguage!=null)
                         const Positioned( //<-- SEE HERE
                           right: 0,
                           top: 0,
                           child: Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),),
                         )
                       ],
                     );
                   },
                 ),
               ],
             ),
            if(selectedLanguage!=null)
             const SizedBox(height: 10,),
             if(selectedLanguage!=null)
               Text("Selected Language - "+selectedLanguage.toString()),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: future,
                builder: (context, snapshot) {
                  return pickCountriesWidget(context, snapshot, searchedItems);
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
      AsyncSnapshot<List<Country>> snapshot, List searchedItems) {
    if (snapshot.connectionState == ConnectionState.done) {
      Provider.of<CountryProvider>(context, listen: false).addCountries(snapshot);
      return searchedItems.isEmpty ? ListView.builder(
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index) {
            Country project = snapshot.data![index];
            snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CountryDetails(ccode: project.code!,)));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(
                          color: Colors.white54, // Set border color
                          width: 2.0), // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8.0)), // Set rounded corner radius
                      boxShadow: const [
                        BoxShadow(blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
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
                            Text(project.name.toString(),
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),),
                            // Text(project.code.toString(),style: const TextStyle(fontStyle: FontStyle.italic),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }) : ListView.builder(
          itemCount: searchedItems.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index) {
            Country project = searchedItems[index];
            snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CountryDetails(ccode: project.code!,)));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(
                          color: Colors.white54, // Set border color
                          width: 2.0), // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8.0)), // Set rounded corner radius
                      boxShadow: const [
                        BoxShadow(blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
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
                            Text(project.name.toString(),
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),),
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
    else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}




