import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/ticket/presentation/screens/ticket_confirmed_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String busName;
  final String from;
  final String to;
  final String departure;
  final List<String> selectedSeats;
  final int totalPrice;

  const PaymentScreen({
    super.key,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'esewa';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'esewa',
      'name': 'eSewa',
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFF60BB46),
    },
    {
      'id': 'khalti',
      'name': 'Khalti',
      'icon': Icons.account_balance_wallet_outlined,
      'color': const Color(0xFF5C2D91),
    },
    {
      'id': 'card',
      'name': 'Credit / Debit Card',
      'icon': Icons.credit_card_rounded,
      'color': AppColors.primary,
    },
    {
      'id': 'cash',
      'name': 'Cash at Counter',
      'icon': Icons.payments_outlined,
      'color': AppColors.orange,
    },
  ];

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
                            Text('Payment',
                                style: AppTextStyles.h3
                                    .copyWith(color: AppColors.white)),
                            Text('Complete your booking',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.pale, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stepper
                  Row(
                    children: [
                      _stepDone('Search'),
                      _stepLine(done: true),
                      _stepDone('Seat'),
                      _stepLine(done: true),
                      _stepDone('Details'),
                      _stepLine(done: true),
                      _stepActive('4', 'Pay'),
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
                    // ── BOOKING SUMMARY ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Booking Summary',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.textLight, height: 1),
                          const SizedBox(height: 12),
                          _summaryRow('Bus', widget.busName),
                          _summaryRow(
                              'Route', '${widget.from} → ${widget.to}'),
                          _summaryRow('Departure', widget.departure),
                          _summaryRow(
                              'Seats', widget.selectedSeats.join(', ')),
                          _summaryRow('Passengers',
                              '${widget.selectedSeats.length}'),
                          const SizedBox(height: 8),
                          const Divider(color: AppColors.textLight, height: 1),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700)),
                              Text(
                                'Rs ${widget.totalPrice}',
                                style:
                                    AppTextStyles.price.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── PAYMENT METHODS ──
                    Text('Payment Method', style: AppTextStyles.h3),
                    const SizedBox(height: 14),

                    ...(_paymentMethods.map((method) {
                      final selected = _selectedMethod == method['id'];
                      return GestureDetector(
                        onTap: () => setState(
                            () => _selectedMethod = method['id'] as String),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textLight,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: (method['color'] as Color)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  method['icon'] as IconData,
                                  color: method['color'] as Color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(method['name'] as String,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textLight,
                                    width: 2,
                                  ),
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.white,
                                ),
                                child: selected
                                    ? const Icon(Icons.check_rounded,
                                        color: AppColors.white, size: 12)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    })),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── BOTTOM BAR ──
            Container(
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _handlePayment,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Pay Rs ${widget.totalPrice}',
                          style:
                              AppTextStyles.buttonText.copyWith(fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => TicketConfirmedScreen(
            busName: widget.busName,
            from: widget.from,
            to: widget.to,
            departure: widget.departure,
            selectedSeats: widget.selectedSeats,
            totalPrice: widget.totalPrice,
            bookingId:
                'YG${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          ),
        ),
        (_) => false,
      );
    });
  }

  Widget _summaryRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(value,
                style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
          ],
        ),
      );

  Widget _stepDone(String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
                color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded,
                color: AppColors.primary, size: 14),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.label.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7), fontSize: 9)),
        ],
      );

  Widget _stepActive(String num, String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
                color: AppColors.orange, shape: BoxShape.circle),
            child: Center(
              child: Text(num,
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.white, fontSize: 11)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.label
                  .copyWith(color: AppColors.white, fontSize: 9)),
        ],
      );

  Widget _stepLine({required bool done}) => Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.only(bottom: 20),
          color: done
              ? AppColors.white.withValues(alpha: 0.8)
              : AppColors.white.withValues(alpha: 0.25),
        ),
      );
}
