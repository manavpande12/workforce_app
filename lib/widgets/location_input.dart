import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class LocationInput extends StatefulWidget {
  final void Function(double latitude, double longitude, String address)
      onSelectLocation;
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationInput({
    super.key,
    required this.onSelectLocation,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  var _isGettingLocation = false;
  double? _latitude;
  double? _longitude;
  String? _address;

  @override
  void initState() {
    super.initState();
    _latitude = (widget.initialLat != 0.0) ? widget.initialLat : null;
    _longitude = (widget.initialLng != 0.0) ? widget.initialLng : null;
    _address = widget.initialAddress;
  }

  String get locationImage {
    if (_latitude == null || _longitude == null) {
      return '';
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$_latitude,$_longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$_latitude,$_longitude&key=$apiKey';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch location (HTTP ${response.statusCode})');
      }

      final resData = json.decode(response.body);

      if (resData['status'] != 'OK' || resData['results'].isEmpty) {
        throw Exception('No address found for this location.');
      }

      final address = resData['results'][0]['formatted_address'];

      setState(() {
        _latitude = latitude;
        _longitude = longitude;
        _address = address;
        _isGettingLocation = false;
      });

      widget.onSelectLocation(latitude, longitude, address);
    } catch (error) {
      setState(() {
        _isGettingLocation = false;
      });
      if (mounted) {
        context.showSnackBar('Error fetching location: $error', isError: true);
      }
    }
  }

  void _getCurrentLocation() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    final locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }
    _savePlace(locationData.latitude!, locationData.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      _address ?? 'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleSmall!,
    );

    if (_isGettingLocation) {
      previewContent = const Center(child: ShimmerLoadingCard(height: 200));
    } else if (_latitude != null && _longitude != null) {
      previewContent = Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: locationImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
              placeholder: (context, url) =>
                  ShimmerLoadingCard(width: 120, height: 120),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: red),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _address ?? '',
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          )
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 160),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? bgrey
                      : grey,
                ),
                child: previewContent,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              fgClr: white,
              bgClr: red,
              text: "Get Location",
              onTap: _getCurrentLocation,
              iClr: white,
              icon: Icons.location_on_outlined,
              iSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
