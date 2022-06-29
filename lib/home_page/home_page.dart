
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

  List<Countryx> countries = [];
  Countryx? selectedCountry;
  Future<List<Countryx>> future = getAllCountries();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text("Country Directory"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<List<Countryx>>(
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
      AsyncSnapshot<List<Countryx>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return ListView.builder(


          // padding: const EdgeInsets.symmetric(horizontal: 10),
          // child: DropdownButtonFormField(
          //   decoration: const InputDecoration(
          //     labelText: "Choose Country",
          //     border: OutlineInputBorder(),
          //   ),
          //   items: buildDropDownItem(countries!),
          //   value: selectedCountry,
          //   onChanged: (Country? country) {
          //     setState(() {
          //       selectedCountry = country;
          //     });
          //   },)



          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index){
            Countryx project = snapshot.data![index];
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

  // List<DropdownMenuItem<Country>> buildDropDownItem(List<Country> countries) {
  //   return countries.map((country) =>
  //       DropdownMenuItem<Country>(
  //         child: Text(country.name),
  //
  //         value: country,
  //       ))
  //       .toList();
  // }

  // Widget countryDetailsWidget(BuildContext context, AsyncSnapshot snapshot) {
  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return const Padding(
  //       padding: EdgeInsets.only(top: 20),
  //       child: Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //   }
  //   if (snapshot.hasError) {
  //     return const Center(
  //       child: Text("Unable to fetch country data"),
  //     );
  //   }
  //   Country country = snapshot.data;
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 10),
  //         child: Text(
  //           "Country Info",
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Card(
  //         color: Colors.pink.shade50,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //           child: Row(
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: const [
  //                   Text("Name"),
  //                   Text("Capital"),
  //                   Text("Country code"),
  //                   Text("Native"),
  //                   Text("Currency"),
  //                   Text("Phone Code"),
  //                   Text("Emoji"),
  //                 ],
  //               ),
  //               const Spacer(flex: 2),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(": ${country.name}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.capital}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.code}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.native}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.currency}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.phone!}",
  //                       style: const TextStyle(fontWeight: FontWeight.bold)),
  //                   Text(": ${country.emoji}",
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       )),
  //                 ],
  //               ),
  //               const Spacer(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

}
