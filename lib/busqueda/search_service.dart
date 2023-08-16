// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'items';
  
  Future<List<QueryDocumentSnapshot>> getSearch() async {
    QuerySnapshot querySnapshot= await _firestore.collection(ref).get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getuserSearch() async {
    QuerySnapshot querySnapshot= await _firestore.collection("drivers").get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getSuggestion(String suggestion) async{
    QuerySnapshot querySnapshot= await _firestore.collection(ref).where("name", isEqualTo: suggestion).get();
    return querySnapshot.docs;
  }
}


class Serchitemsbymod extends StatefulWidget {
  static String id = 'serchitemsbymod';

  const Serchitemsbymod({super.key});
  @override
  _SerchitemsbymodState createState() => _SerchitemsbymodState();
}

class _SerchitemsbymodState extends State<Serchitemsbymod> {
  SearchService _searchService = SearchService();
  //List<Map> search = <Map>[];
  List<Map<String, dynamic>> search = [];

  @override
  void initState() {
    getDocs();
    super.initState();
  }

  Future getDocs() async {
    /*List<QueryDocumentSnapshot> searchDocs = await _searchService.getSearch();
    search = searchDocs.map((item) => item.data as Map).toList();
    setState(() {});*/
    search = (await _searchService.getSearch())
    .map((item) => item.data() as Map<String, dynamic>).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mian Traders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child:TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              textAlign: TextAlign.center,
              style:
              const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
              ),
              decoration: InputDecoration(border: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.blueAccent,width: 1.0),
                borderRadius: BorderRadius.circular(32.0),
              ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(32.0)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent,width: 2.0),
                  borderRadius: BorderRadius.circular(32.0),
                ),
                hintText: ('Enter the Name of item'),
                hintStyle: const TextStyle(
                  fontSize: 15.0,
                ),
              )),
          suggestionsCallback: (pattern) {
            return search.where(
                  (doc) => jsonEncode(doc)
                  .toLowerCase()
                  .contains(pattern.toLowerCase()),
            );
          },
          itemBuilder: (context, suggestion) {
            return Card(
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 6.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(suggestion['A'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),),
                    Text(suggestion['B'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        )),
                    Text(suggestion['C'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),)
                  ],
                ),

              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            final map = jsonDecode(suggestion as String);
          },
        ),
      ),
    );
  }
}