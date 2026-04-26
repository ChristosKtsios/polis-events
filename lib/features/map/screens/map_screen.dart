import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_colors.dart';

/// Πραγματικός χάρτης με Google Maps + markers για όλα τα places.
/// Tap σε marker → ανοίγει place detail.
class MapScreen extends StatefulWidget {
  final String cityId;

  const MapScreen({super.key, this.cityId = 'ioannina'});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _loading = true;
  String? _error;

  // Default camera στα Ιωάννινα
  static const _ioanninaCamera = CameraPosition(
    target: LatLng(39.6650, 20.8537),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('places')
          .where('cityId', isEqualTo: widget.cityId)
          .where('published', isEqualTo: true)
          .get();

      final markers = <Marker>{};

      for (final doc in snap.docs) {
        final data = doc.data();
        final loc = data['location'] as GeoPoint?;
        if (loc == null) continue;

        final name = (data['name']?['el'] as String?) ?? doc.id;
        final category = (data['category'] as String?) ?? '';
        final priceFrom = data['priceFrom'] as num?;
        final isFree = data['isFree'] == true;

        final priceText = isFree
            ? 'Δωρεάν'
            : priceFrom != null
                ? 'Από €${priceFrom.toInt()}'
                : '';

        markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(loc.latitude, loc.longitude),
          icon: _markerColorForCategory(category),
          infoWindow: InfoWindow(
            title: name,
            snippet: priceText,
            onTap: () => context.go('/place/${doc.id}'),
          ),
        ));
      }

      if (mounted) {
        setState(() {
          _markers = markers;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  /// Διαφορετικό χρώμα marker ανά κατηγορία.
  BitmapDescriptor _markerColorForCategory(String category) {
    switch (category) {
      case 'museum':
      case 'gallery':
      case 'historical':
      case 'castle':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case 'archaeological':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'lake':
      case 'park':
      case 'nature':
      case 'trail':
      case 'cave':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'gym':
      case 'pool':
      case 'field':
      case 'stadium':
      case 'padel':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      case 'cinema':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'workshop':
      case 'hobbies':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta);
      case 'restaurant':
      case 'cafe':
      case 'bar':
      case 'nightlife':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _ioanninaCamera,
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          if (_loading)
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Φόρτωση χάρτη...', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          if (_error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Σφάλμα: $_error',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                ),
              ),
            ),
          // Counter chip
          if (!_loading && _markers.isNotEmpty)
            Positioned(
              top: 60,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place, size: 14, color: Color(0xFF185FA5)),
                    const SizedBox(width: 6),
                    Text(
                      '${_markers.length} σημεία',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0C447C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
