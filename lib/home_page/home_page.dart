
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:  TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter country name',
                ),
              ),
            ),
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
}



