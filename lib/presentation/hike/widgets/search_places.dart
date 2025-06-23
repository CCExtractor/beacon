import 'package:beacon/presentation/hike/services/geoapify_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocationSearchWidget extends StatelessWidget {
  final GeoapifyService geoapifyService = GeoapifyService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: TypeAheadField<String>(
        suggestionsCallback: (pattern) async {
          return await geoapifyService.getLocationSuggestions(pattern);
        },
        builder: (context, controller, focusNode) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              cursorColor: Colors.deepPurpleAccent.withAlpha(120),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: 'Search for a place',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.deepPurpleAccent.withAlpha(120),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      focusNode.unfocus();
                      // remove keyboard
                    },
                  )),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          );
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
            leading: Icon(Icons.location_on, color: Colors.blue),
          );
        },
        onSelected: (suggestion) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You selected: $suggestion')),
          );
        },
        hideOnEmpty: true,
        decorationBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: child,
          );
        },
      ),
    );
  }
}
