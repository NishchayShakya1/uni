import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/map.dart';

class FacultyMap extends StatelessWidget {
  const FacultyMap({required this.faculty, required this.locations, super.key});
  final String faculty;
  final List<LocationGroup> locations;

  @override
  Widget build(BuildContext context) {
    switch (faculty) {
      case 'FEUP':
        return LocationsMap(
          northEastBoundary: const LatLng(41.17986, -8.59298),
          southWestBoundary: const LatLng(41.17670, -8.59991),
          center: const LatLng(41.17731, -8.59522),
          locations: locations,
        );
      default:
        return Container(); // Should not happen
    }
  }

  static Color getFontColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
  }
}
