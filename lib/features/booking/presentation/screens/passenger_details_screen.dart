import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/payment/presentation/screens/payment_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final String busName;
  final String from;
  final String to;
  final String departure;
  final List<String> selectedSeats;
  final int pricePerSeat;
  final int totalPrice;

  const PassengerDetailsScreen({
    super.key,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.selectedSeats,
    required this.pricePerSeat,
    required this.totalPrice,
  });

  @override
  State<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the first passenger (lead)
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Per-seat passenger names
  late final List<TextEditingController> _passengerControllers;

  @override
  void initState() {
    super.initState();
    _passengerControllers = List.generate(
      widget.selectedSeats.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    for (final c in _passengerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _proceed() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            busName: widget.busName,
            from: widget.from,
            to: widget.to,
            departure: widget.departure,
            selectedSeats: widget.selectedSeats,
            totalPrice: widget.totalPrice,
          ),
        ),
      );
    }
  }

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
                            Text('Passenger Details',
                                style: AppTextStyles.h3
                                    .copyWith(color: AppColors.white)),
                            Text(
                              '${widget.selectedSeats.length} passenger(s) · ${widget.selectedSeats.join(', ')}',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.pale, fontSize: 11),
                            ),
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
                      _stepActive('3', 'Details'),
                      _stepLine(done: false),
                      _stepPending('4', 'Pay'),
                    ],
                  ),
                ],
              ),
            ),

            // ── FORM ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact info section
                      Text('Contact Information',
                          style: AppTextStyles.h3.copyWith(fontSize: 16)),
                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'e.g. Hari Bahadur Thapa',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: 'e.g. 98XXXXXXXX',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (v.trim().length < 10) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _emailController,
                        label: 'Email (for ticket)',
                        hint: 'e.g. hari@example.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Passenger names per seat
                      if (widget.selectedSeats.length > 1) ...[
                        Text('Passenger Names',
                            style: AppTextStyles.h3.copyWith(fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(
                          'Enter name for each seat',
                          style: AppTextStyles.bodySmall
                              .copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 14),
                        ...List.generate(widget.selectedSeats.length,
                            (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildTextField(
                              controller: _passengerControllers[i],
                              label:
                                  'Seat ${widget.selectedSeats[i]} — Passenger',
                              hint: 'Full name',
                              icon: Icons.airline_seat_recline_normal_rounded,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter passenger name'
                                      : null,
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: 24),

                      // Booking summary card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreen.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            _summaryRow('Bus', widget.busName),
                            _summaryRow('Route',
                                '${widget.from} → ${widget.to}'),
                            _summaryRow('Departure', widget.departure),
                            _summaryRow('Seats',
                                widget.selectedSeats.join(', ')),
                            const Divider(
                                color: AppColors.textLight, height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700)),
                                Text(
                                  'Rs ${widget.totalPrice}',
                                  style: AppTextStyles.price
                                      .copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── BOTTOM BUTTON ──
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
            onPressed: _proceed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Proceed to Payment',
                    style: AppTextStyles.buttonText.copyWith(fontSize: 15)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.label
                .copyWith(color: AppColors.textDark, fontSize: 11)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
            prefixIcon:
                Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.textLight, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.textLight, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
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

  Widget _stepPending(String num, String label) => Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Center(
              child: Text(num,
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: 11)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.label.copyWith(
                  color: AppColors.white.withValues(alpha: 0.4), fontSize: 9)),
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
