import 'package:coffee_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationTile extends StatefulWidget {
  const LocationTile({super.key});

  @override
  State<LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  String _addressLine1 = "Loading...";
  String _addressLine2 = "Fetching location...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _addressLine1 = "Location Disabled";
        _addressLine2 = "Enable location services";
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _addressLine1 = "Permission Denied";
          _addressLine2 = "Allow location access";
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _addressLine1 = "Permission Denied";
        _addressLine2 = "Enable in settings";
        _isLoading = false;
      });
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition();
      _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _addressLine1 = "Error";
        _addressLine2 = "Could not fetch location";
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // Construct address lines
          // Priority: Street -> Name -> Thoroughfare
          String line1 = place.street ?? "";
          if (line1.isEmpty || line1 == place.name) {
            line1 = place.thoroughfare ?? place.name ?? "Unknown Place";
          }
          _addressLine1 = line1;

          // Construct subtitle from Locality, SubAdminArea, AdminArea
          List<String?> distinctParts = [
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.postalCode,
          ].toSet().toList(); // Remove duplicates

          _addressLine2 = distinctParts
              .where((element) => element != null && element.isNotEmpty)
              .join(", ");

          print(
            "Full Placemark: $place",
          ); // Debug print for user to see in console

          _isLoading = false;
        });
      } else {
        setState(() {
          _addressLine1 = "Unknown Location";
          _addressLine2 = "No address found";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _addressLine1 = "Error";
        _addressLine2 = "Address lookup failed";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.settingsCard,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon Background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  255,
                  238,
                  219,
                  206,
                ), // Light orange background for icon
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary, // Orange icon
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            // Address Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _addressLine1, // Display dynamic address
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    _addressLine2, // Display dynamic address
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Change Button / Refresh
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _addressLine1 = "Refreshing...";
                  _addressLine2 = "";
                });
                _determinePosition();
              },
              child: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange,
                      ),
                    )
                  : Text(
                      "Change", // Could be icon or "Refresh"
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
