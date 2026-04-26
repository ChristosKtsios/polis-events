import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';

/// Bottom sheet που ανοίγει όταν πατάς ένα place.
/// - Πάνω: Google Map με marker
/// - Φωτογραφίες
/// - Όνομα + διεύθυνση + όλες οι πληροφορίες
/// - Swipe down to close
class PlaceDetailBottomSheet extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const PlaceDetailBottomSheet({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final name = (data['name']?['el'] as String?) ?? doc.id;
    final description = (data['description']?['el'] as String?) ?? '';
    final address = (data['address']?['el'] as String?) ?? '';
    final priceFrom = data['priceFrom'] as num?;
    final isFree = data['isFree'] == true;
    final rating = (data['rating'] as num?)?.toDouble();
    final reviewCount = (data['reviewCount'] as num?)?.toInt() ?? 0;
    final phone = data['phone'] as String?;
    final website = data['website'] as String?;
    final loc = data['location'] as GeoPoint?;
    final images = (data['images'] as List?)?.cast<String>() ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Map area (top)
                    if (loc != null)
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(loc.latitude, loc.longitude),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(doc.id),
                              position: LatLng(loc.latitude, loc.longitude),
                              infoWindow: InfoWindow(title: name),
                            ),
                          },
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          myLocationButtonEnabled: false,
                          liteModeEnabled: false,
                        ),
                      ),

                    // Photos carousel (αν υπάρχουν παραπάνω από 1)
                    if (images.length > 1)
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          itemCount: images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                images[i],
                                width: 160,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 160,
                                  color: const Color(0xFFE6F1FB),
                                  child: const Icon(Icons.image_outlined,
                                      color: Color(0xFF185FA5)),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else if (images.length == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            images.first,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 160,
                              color: const Color(0xFFE6F1FB),
                              child: const Icon(Icons.image_outlined,
                                  color: Color(0xFF185FA5)),
                            ),
                          ),
                        ),
                      ),

                    // Title & basic info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (address.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.place_outlined,
                                    size: 14, color: AppColors.textTertiary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),

                          // Stats row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F1FB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(
                                  label: 'Τιμή',
                                  value: isFree
                                      ? 'Δωρεάν'
                                      : priceFrom != null
                                          ? '€${priceFrom.toInt()}'
                                          : '—',
                                ),
                                _Divider(),
                                _StatItem(
                                  label: 'Βαθμολογία',
                                  value: rating != null
                                      ? '★ ${rating.toStringAsFixed(1)}'
                                      : '—',
                                ),
                                _Divider(),
                                _StatItem(
                                  label: 'Reviews',
                                  value: reviewCount > 0 ? '$reviewCount' : '—',
                                ),
                              ],
                            ),
                          ),

                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Περιγραφή',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],

                          // Action buttons (call / website / directions)
                          if (phone != null ||
                              website != null ||
                              loc != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (phone != null)
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.phone,
                                      label: 'Κλήση',
                                      onTap: () =>
                                          launchUrl(Uri.parse('tel:$phone')),
                                    ),
                                  ),
                                if (phone != null && website != null)
                                  const SizedBox(width: 8),
                                if (website != null)
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.language,
                                      label: 'Site',
                                      onTap: () => launchUrl(Uri.parse(website),
                                          mode: LaunchMode.externalApplication),
                                    ),
                                  ),
                                if ((phone != null || website != null) &&
                                    loc != null)
                                  const SizedBox(width: 8),
                                if (loc != null)
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.directions,
                                      label: 'Οδηγίες',
                                      onTap: () => launchUrl(
                                        Uri.parse(
                                            'https://www.google.com/maps/dir/?api=1&destination=${loc.latitude},${loc.longitude}'),
                                        mode: LaunchMode.externalApplication,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF185FA5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0C447C),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFB5D4F4),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF185FA5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
