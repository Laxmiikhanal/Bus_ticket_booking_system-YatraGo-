import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/screens/seat_selection_screen.dart';
import 'package:bus_ticket_booking_system/features/bus_list/data/models/bus_model.dart';
import 'package:bus_ticket_booking_system/features/bus_list/presentation/providers/bus_list_provider.dart';

class BusListScreen extends ConsumerStatefulWidget {
  final String from;
  final String to;
  const BusListScreen({super.key, required this.from, required this.to});
  @override
  ConsumerState<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends ConsumerState<BusListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'AC', 'Non-AC', 'Night', 'Deluxe'];

  List<BusModel> _applyFilter(List<BusModel> buses) {
    if (_selectedFilter == 'All') return buses;
    return buses
        .where((b) => b.type.toLowerCase().contains(_selectedFilter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final busesAsync = ref.watch(
      busListProvider(BusRouteArgs(from: widget.from, to: widget.to)),
    );

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
                            Text('${widget.from} → ${widget.to}', style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                            busesAsync.when(
                              data: (buses) => Text('${_applyFilter(buses).length} buses available', style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11)),
                              loading: () => Text('Searching…', style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11)),
                              error: (_, _) => Text('Could not load buses', style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref.invalidate(busListProvider(BusRouteArgs(from: widget.from, to: widget.to))),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.refresh_rounded, color: AppColors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
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
              child: busesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text(
                          err.toString().replaceFirst('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          onPressed: () => ref.invalidate(busListProvider(BusRouteArgs(from: widget.from, to: widget.to))),
                          child: const Text('Retry', style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (buses) {
                  final filtered = _applyFilter(buses);
                  if (filtered.isEmpty) {
                    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.directions_bus_outlined, size: 64, color: AppColors.textLight), const SizedBox(height: 12), Text('No buses found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey))]));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _busCard(filtered[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _busCard(BusModel bus) {
    final isLowSeat = bus.availableSeats <= 5;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeatSelectionScreen(busId: bus.id, busName: bus.name, from: widget.from, to: widget.to, departure: bus.departure, price: bus.price))),
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
                  Text(bus.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(bus.type, style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 9))),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Rs ${bus.price}', style: AppTextStyles.price.copyWith(fontSize: 16)),
                  Text('per seat', style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
                ]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bus.departure, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  Text(widget.from, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                ]),
                Expanded(child: Column(children: [
                  Text(bus.duration, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
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
                  Text(bus.arrival, style: AppTextStyles.h3.copyWith(fontSize: 16)),
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
                  child: Text('${bus.availableSeats} seats left', style: AppTextStyles.label.copyWith(color: isLowSeat ? AppColors.orange : AppColors.primary, fontSize: 9)),
                ),
                const SizedBox(width: 8),
                ...(bus.amenities.take(3).map((a) => Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6)), child: Text(a, style: AppTextStyles.label.copyWith(fontSize: 9))))),
                const Spacer(),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.orange),
                  const SizedBox(width: 3),
                  Text(bus.rating.toStringAsFixed(1), style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 11)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
