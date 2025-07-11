import 'package:beacon/data/models/landmark/location_suggestion.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/services/geoapify_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchWidget extends StatelessWidget {
  final String beaconId;
  final Function(LocationSuggestion)? onLocationSelected; // Add callback

  LocationSearchWidget(
    this.beaconId, {
    Key? key,
    this.onLocationSelected,
  }) : super(key: key);

  final GeoapifyService geoapifyService = GeoapifyService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: TypeAheadField<LocationSuggestion>(
        // Changed from String to LocationSuggestion
        suggestionsCallback: (pattern) async {
          List<LocationSuggestion> res =
              await geoapifyService.getLocationSuggestions(pattern);
          return res; // Return the LocationSuggestion objects directly
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
            title: Text(
                suggestion.name), // Use suggestion.name instead of suggestion
            subtitle: Text(
              'Lat: ${suggestion.latitude.toStringAsFixed(4)}, Lon: ${suggestion.longitude.toStringAsFixed(4)} \n ${suggestion.fullAddress}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            leading: Icon(Icons.location_on, color: Colors.blue),
          );
        },
        onSelected: (suggestion) {
          print("Location selected: ${suggestion.name}");
          print("Coordinates: ${suggestion.latitude}, ${suggestion.longitude}");

          // Call the callback if provided
          if (onLocationSelected != null) {
            onLocationSelected!(suggestion);
          }

          locator<LocationCubit>().createLandmark(
              beaconId,
              suggestion.name,
              LatLng(suggestion.latitude, suggestion.longitude),
              "images/icons/location-marker.png");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Selected: ${suggestion.name}\nLat: ${suggestion.latitude}, Lon: ${suggestion.longitude}',
              ),
            ),
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
                  offset: Offset(0, 3),
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
