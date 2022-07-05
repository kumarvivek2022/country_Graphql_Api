import 'package:flutter/material.dart';

import '../model/final_model.dart';
class CountryProvider extends ChangeNotifier{
  List allCountryList = [];
  String? selectedLanguage;
  List searchedItems = [];
  List searchedItemsIndexPosition = [];



   void addCountries(AsyncSnapshot<List<Country>> snapshot){
     allCountryList = snapshot.data!;
     notifyListeners();
   }
   void addSelectedLanguage(String? value){
     selectedLanguage = value;
     notifyListeners();
   }
  void getSelectedItems(List value) {
    searchedItems.addAll(value);
    notifyListeners();
  }
  void getIndexPosition(List value) {
    searchedItemsIndexPosition = value;
    notifyListeners();
  }


}
