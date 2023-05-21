// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gezi_rehberi/screens/Details/Lists.dart';
import 'package:gezi_rehberi/screens/home/HomePage.dart';
import 'package:firestore_search/firestore_search.dart';
class SearchPage extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              }
              query = '';
            },
            icon: const Icon(Icons.clear))
      ];
  @override
  Widget buildResults(BuildContext context) => Center(
          child: Text(
        query,
        style: const TextStyle(
          fontSize: 64,
        ),
      ));
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResults) {
      final result = searchResults.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return  ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context,index){
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query=suggestion;
            showResults(context);
          },
        );
      });
  }
}

