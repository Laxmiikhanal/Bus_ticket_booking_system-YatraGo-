import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/screens/seat_selection_screen.dart';

class BusListScreen extends StatefulWidget {
  final String from;
  final String to;
  const BusListScreen({super.key, required this.from, required this.to});
  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'AC', 'Non-AC', 'Night', 'Deluxe'];
  final List<Map<String, dynamic>> _buses = [
    {'id':'B001','name':'Greenline Deluxe','type':'AC Deluxe','departure':'07:00 AM','arrival':'02:00 PM','duration':'7 hrs','price':1400,'seats':12,'rating':4.8,'amenities':['AC','WiFi','USB']},
    {'id':'B002','name':'Sajha Yatayat','type':'Tourist Bus','departure':'08:30 AM','arrival':'03:30 PM','duration':'7 hrs','price':900,'seats':3,'rating':4.2,'amenities':['AC','USB']},
    {'id':'B003','name':'Buddha Air Express','type':'Night Bus','departure':'10:00 PM','arrival':'05:00 AM','duration':'7 hrs','price':1100,'seats':28,'rating':4.5,'amenities':['AC','Blanket','USB']},
    {'id':'B004','name':'Himalayan Travels','type':'Non-AC','departure':'06:00 AM','arrival':'01:30 PM','duration':'7.5 hrs','price':650,'seats':18,'rating':3.9,'amenities':['USB']},
    {'id':'B005','name':'Pokhara Express','type':'AC Deluxe','departure':'12:00 PM','arrival':'07:00 PM','duration':'7 hrs','price':1350,'seats':7,'rating':4.6,'amenities':['AC','WiFi','Snacks']},
  ];

  List<Map<String, dynamic>> get _filteredBuses {
    if (_selectedFilter == 'All') return _buses;
    return _buses.where((b) {
      final type = (b['type'] as String).toLowerCase();
      return type.contains(_selectedFilter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.from} ? ${widget.to}', style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                            Text('${_filteredBuses.length} buses available', style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.tune_rounded, color: AppColors.white, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final selected = _selectedFilter == _filters[i];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = _filters[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : AppColors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: selected ? AppColors.primary : AppColors.white.withValues(alpha: 0.2)),
                            ),
                            child: Center(child: Text(_filters[i], style: AppTextStyles.bodySmall.copyWith(color: AppColors.white, fontWeight: selected ? FontWeight.w700 : FontWeight.w400, fontSize: 12))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredBuses.isEmpty
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.directions_bus_outlined, size: 64, color: AppColors.textLight), const SizedBox(height: 12), Text('No buses found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey))]))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredBuses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _busCard(_filteredBuses[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _busCard(Map<String, dynamic> bus) {
    final isLowSeat = (bus['seats'] as int) <= 5;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeatSelectionScreen(busId: bus['id'] as String, busName: bus['name'] as String, from: widget.from, to: widget.to, departure: bus['departure'] as String, price: bus['price'] as int))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bus['name'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(bus['type'] as String, style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 9))),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Rs ${bus['price']}', style: AppTextStyles.price.copyWith(fontSize: 16)),
                  Text('per seat', style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
                ]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bus['departure'] as String, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  Text(widget.from, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                ]),
                Expanded(child: Column(children: [
                  Text(bus['duration'] as String, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    Expanded(child: Container(height: 1, color: AppColors.textLight)),
                    const Icon(Icons.directions_bus_rounded, size: 14, color: AppColors.primary),
                    Expanded(child: Container(height: 1, color: AppColors.textLight)),
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle)),
                  ]),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(bus['arrival'] as String, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  Text(widget.to, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                ]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: isLowSeat ? AppColors.orange.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text('${bus['seats']} seats left', style: AppTextStyles.label.copyWith(color: isLowSeat ? AppColors.orange : AppColors.primary, fontSize: 9)),
                ),
                const SizedBox(width: 8),
                ...((bus['amenities'] as List<String>).take(3).map((a) => Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6)), child: Text(a, style: AppTextStyles.label.copyWith(fontSize: 9))))),
                const Spacer(),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.orange),
                  const SizedBox(width: 3),
                  Text('${bus['rating']}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 11)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
