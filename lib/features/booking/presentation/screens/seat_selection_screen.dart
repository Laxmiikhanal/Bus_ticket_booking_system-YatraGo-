import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/screens/passenger_details_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String busId;
  final String busName;
  final String from;
  final String to;
  final String departure;
  final int price;

  const SeatSelectionScreen({
    super.key,
    required this.busId,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.price,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Map<String, String> _seatStatus = {
    '1A': 'available', '1B': 'available', '1C': 'booked',   '1D': 'booked',
    '2A': 'women',     '2B': 'women',     '2C': 'available', '2D': 'available',
    '3A': 'available', '3B': 'booked',    '3C': 'available', '3D': 'available',
    '4A': 'booked',    '4B': 'available', '4C': 'available', '4D': 'booked',
    '5A': 'available', '5B': 'available', '5C': 'booked',    '5D': 'available',
    '6A': 'available', '6B': 'available', '6C': 'available', '6D': 'available',
    '7A': 'booked',    '7B': 'available', '7C': 'available', '7D': 'booked',
    '8A': 'available', '8B': 'booked',    '8C': 'available', '8D': 'available',
  };

  final List<String> _selectedSeats = [];
  final int _maxSeats = 5;

  void _toggleSeat(String seatId) {
    final status = _seatStatus[seatId];
    if (status == 'booked' || status == 'women') return;

    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
        _seatStatus[seatId] = 'available';
      } else {
        if (_selectedSeats.length >= _maxSeats) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can select max $_maxSeats seats'),
              backgroundColor: AppColors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          return;
        }
        _selectedSeats.add(seatId);
        _seatStatus[seatId] = 'selected';
      }
    });
  }

  int get _totalPrice => _selectedSeats.length * widget.price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.busName,
                              style: AppTextStyles.h3.copyWith(color: AppColors.white),
                            ),
                            Text(
                              '${widget.from} → ${widget.to}  •  ${widget.departure}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _stepDone('Search'),
                      _stepLine(done: true),
                      _stepActive('2', 'Seat'),
                      _stepLine(done: false),
                      _stepPending('3', 'Details'),
                      _stepLine(done: false),
                      _stepPending('4', 'Pay'),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Rs ${widget.price} per seat',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Max $_maxSeats seats',
                              style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _legendItem(AppColors.seatAvailable, AppColors.textLight, 'Available'),
                        const SizedBox(width: 16),
                        _legendItem(AppColors.seatSelected, null, 'Selected'),
                        const SizedBox(width: 16),
                        _legendItem(AppColors.seatBooked, null, 'Booked'),
                        const SizedBox(width: 16),
                        _legendItem(AppColors.seatWomen, null, 'Women'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_bus_rounded, color: AppColors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'DRIVER',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                const SizedBox(width: 32),
                                Expanded(child: Center(child: Text('A', style: AppTextStyles.label.copyWith(fontSize: 10)))),
                                Expanded(child: Center(child: Text('B', style: AppTextStyles.label.copyWith(fontSize: 10)))),
                                const SizedBox(width: 24),
                                Expanded(child: Center(child: Text('C', style: AppTextStyles.label.copyWith(fontSize: 10)))),
                                Expanded(child: Center(child: Text('D', style: AppTextStyles.label.copyWith(fontSize: 10)))),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...List.generate(8, (rowIndex) {
                            final row = rowIndex + 1;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 32,
                                    child: Text(
                                      '$row',
                                      style: AppTextStyles.label.copyWith(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(child: _seatWidget('${row}A')),
                                  const SizedBox(width: 4),
                                  Expanded(child: _seatWidget('${row}B')),
                                  const SizedBox(width: 24),
                                  Expanded(child: _seatWidget('${row}C')),
                                  const SizedBox(width: 4),
                                  Expanded(child: _seatWidget('${row}D')),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedSeats.isEmpty ? 'No seat selected' : _selectedSeats.join(', '),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontSize: 11,
                  ),
                ),
                Text(
                  _selectedSeats.isEmpty ? 'Select at least 1 seat' : 'Total: Rs $_totalPrice',
                  style: AppTextStyles.price.copyWith(fontSize: 18),
                ),
              ],
            ),
            const Spacer(),
            // FIX: wrapped in Flexible so the Row gives this a bounded width
            // instead of Infinity (this was the cause of the white-screen crash)
            Flexible(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSeats.isEmpty ? AppColors.textLight : AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  onPressed: _selectedSeats.isEmpty
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PassengerDetailsScreen(
                                busId: widget.busId,
                                busName: widget.busName,
                                from: widget.from,
                                to: widget.to,
                                departure: widget.departure,
                                selectedSeats: List.from(_selectedSeats),
                                pricePerSeat: widget.price,
                                totalPrice: _totalPrice,
                              ),
                            ),
                          ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Continue', style: AppTextStyles.buttonText),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatWidget(String seatId) {
    final status = _seatStatus[seatId] ?? 'available';
    Color bgColor;
    Color borderColor;
    Color textColor;
    bool tappable = true;

    switch (status) {
      case 'selected':
        bgColor = AppColors.seatSelected;
        borderColor = AppColors.primary;
        textColor = AppColors.white;
        break;
      case 'booked':
        bgColor = AppColors.seatBooked;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        tappable = false;
        break;
      case 'women':
        bgColor = AppColors.seatWomen;
        borderColor = AppColors.orange;
        textColor = AppColors.orangeDark;
        tappable = false;
        break;
      default:
        bgColor = AppColors.seatAvailable;
        borderColor = AppColors.textLight;
        textColor = AppColors.textDark;
    }

    return GestureDetector(
      onTap: tappable ? () => _toggleSeat(seatId) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: status == 'selected'
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, Color? borderColor, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor ?? color.withValues(alpha: 0.5), width: 1),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textGrey)),
      ],
    );
  }

  Widget _stepDone(String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 14),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(color: AppColors.white.withValues(alpha: 0.7), fontSize: 9)),
        ],
      );

  Widget _stepActive(String num, String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
            child: Center(
              child: Text(num, style: AppTextStyles.label.copyWith(color: AppColors.white, fontSize: 11)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(color: AppColors.white, fontSize: 9)),
        ],
      );

  Widget _stepPending(String num, String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Center(
              child: Text(num, style: AppTextStyles.label.copyWith(color: AppColors.white.withValues(alpha: 0.6), fontSize: 11)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(color: AppColors.white.withValues(alpha: 0.4), fontSize: 9)),
        ],
      );

  Widget _stepLine({required bool done}) => Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.only(bottom: 20),
          color: done ? AppColors.white.withValues(alpha: 0.8) : AppColors.white.withValues(alpha: 0.25),
        ),
      );
}