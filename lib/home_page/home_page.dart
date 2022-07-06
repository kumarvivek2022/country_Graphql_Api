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
      dynamic savedCountries, String? selectedLanguage, List searchedItemsIndexPosition, List searchedItems)
    {
      const TextField(
        decoration: InputDecoration(
          fillColor: Colors.grey,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)
          ),
          hintText: 'Enter country name',
        ),
      );
    var languageList = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
            itemCount: languageList!.length,
            itemBuilder: (BuildContext context, int index) {
              Languages lang = languageList[index];
              languageList.sort((a, b) => a.name!.compareTo(b.name!));

              return Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    if (selectedLanguage.toString() != lang.name.toString()) {
                      filterItem(
                          lang.name.toString(), searchedItemsIndexPosition,
                          savedCountries, searchedItems);
                      Provider.of<CountryProvider>(context, listen: false)
                          .addSelectedLanguage(lang.name.toString());
                    } else {
                      Provider.of<CountryProvider>(context, listen: false)
                          .addSelectedLanguage(null);
                      searchedItems.clear();

                    }
                    Navigator.pop(context);
                  },

                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(
                            color: Colors.white54, // Set border color
                            width: 0), // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8.0)), // Set rounded corner radius
                        boxShadow: const [
                          BoxShadow(blurRadius: 0,
                              color: Colors.white,
                              offset: Offset(1, 3))
                        ] // Make rounded corner of border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(lang.name.toString(), style: TextStyle(
                          color: selectedLanguage.toString() != lang.name.toString()
                              ? Colors.black
                              : Colors.red),),
                    ),
                  ),

                ),
              );
            });
      }
      );
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
    dynamic storedCountry = Provider.of<CountryProvider>(context).allCountryList;
    final selectedLanguage= Provider.of<CountryProvider>(context).selectedLanguage;
    final searchedItems= Provider.of<CountryProvider>(context).searchedItems;
    final searchedItemsIndexPosition= Provider.of<CountryProvider>(context).searchedItemsIndexPosition;
    debugPrint(storedCountry.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.indigo,
          title: const Text("Country Directory"),
          actions: [
            FutureBuilder<List<Languages>>(
              future: futureLang,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      IconButton(
                          onPressed: (){
                            storedCountry = Provider.of<CountryProvider>(context, listen: false).allCountryList;
                            if(storedCountry.isNotEmpty){
                              _modalBottomSheet(snapshot, storedCountry, selectedLanguage,searchedItemsIndexPosition,searchedItems);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data not loaded kindly reload")));
                            }
                          },
                          icon: const Icon(Icons.sort)),
                      if(selectedLanguage!=null)
                        const Positioned( //<-- SEE HERE
                          right: 0,
                          top: 0,
                          child: Text('1', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),),
                        )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                   child: TextField(
                     decoration: InputDecoration(
                       fillColor: Colors.grey.withOpacity(0.2),
                       filled: true,
                       enabledBorder: const OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                       ),
                       focusedBorder: const OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                       ),
                       border: const OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.transparent)
                       ),
                       hintText: 'Enter country name',
                     ),
                     onChanged: (value) {
                       Provider.of<CountryProvider>(context, listen: false).addSelectedLanguage(null);
                       searchResults(value, storedCountry, searchedItemsIndexPosition,
                           searchedItems); },
                   ),
                 ),
                const SizedBox(height: 20),
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
            if(selectedLanguage!=null)
                Positioned( //<-- SEE HERE
                  bottom: 10,
                  right: 10,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          width: MediaQuery.of(context).size.width,

                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Selected Language is - ${selectedLanguage.toString()}", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),)),
                      )),
                  ),
                )
          ],
        ),
      ),
    );
  }
  Widget pickCountriesWidget(BuildContext context,
      AsyncSnapshot<List<Country>> snapshot, List searchedItems) {
    if (snapshot.connectionState == ConnectionState.done) {
      Provider.of<CountryProvider>(context, listen: false).addCountries(snapshot);
      return searchedItems.isEmpty ?  MediaQuery.removePadding(
        removeBottom: true,
        context: context,
        removeTop: true,
        child: ListView.builder(
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.white54, // Set border color
                            width: 0), // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8.0)), // Set rounded corner radius
                        boxShadow: const [
                          BoxShadow(blurRadius: 0,
                              color: Colors.white,
                              offset: Offset(1, 3))
                        ] // Make rounded corner of border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFFFFF),
                            child: Text(project.emoji.toString()),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(project.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 10, fontWeight: FontWeight.bold),),
                                  const SizedBox(width: 50,),
                                  Text(project.capital.toString(),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal,fontStyle: FontStyle.italic),),


                                ],
                              ),
                            ),
                          ),
                          Text(project.code.toString(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ) :  MediaQuery.removePadding(
        removeBottom: true,
        removeTop: true,
        context: context,
        child: ListView.builder(
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.white54, // Set border color
                            width: 0), // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8.0)), // Set rounded corner radius
                        boxShadow: const [
                          BoxShadow(blurRadius: 0,
                              color: Colors.white,
                              offset: Offset(1, 3))
                        ] // Make rounded corner of border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFFFFF),
                            child: Text(project.emoji.toString()),
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
            }),
      );
    }
    else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}




