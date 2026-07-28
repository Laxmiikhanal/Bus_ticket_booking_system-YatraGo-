// import "package:flutter/material.dart";
// import "package:flutter_riverpod/flutter_riverpod.dart";
// import "package:bus_ticket_booking_system/core/theme/app_colors.dart";
// import "package:bus_ticket_booking_system/core/theme/app_text_styles.dart";
// import "package:bus_ticket_booking_system/features/auth/presentation/pages/login_page.dart";
// import "package:bus_ticket_booking_system/features/auth/presentation/providers/auth_provider.dart";

// class RegisterPage extends ConsumerStatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   ConsumerState<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends ConsumerState<RegisterPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleRegister() async {
//     final fullName = _nameController.text.trim();
//     final email = _emailController.text.trim();
//     final password = _passwordController.text;

//     if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
//       _snack("Please fill name, email and password");
//       return;
//     }
//     if (password.length < 6) {
//       _snack("Password must be at least 6 characters");
//       return;
//     }

//     // Backend wants firstName + lastName. Split the full name.
//     final parts = fullName.split(" ");
//     final firstName = parts.first;
//     final lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

//     final success = await ref.read(authProvider.notifier).register(
//           firstName: firstName,
//           lastName: lastName,
//           email: email,
//           password: password,
//         );

//     if (!mounted) return;

//     if (success) {
//       _snack("Account created! Please log in.", isError: false);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginPage(prefillEmail: email)),
//       );
//       return;
//     }

//     final state = ref.read(authProvider);
//     state.whenOrNull(
//       error: (e, _) => _snack(e.toString().replaceFirst("Exception: ", "")),
//     );
//   }

//   void _snack(String msg, {bool isError = true}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? AppColors.error : AppColors.primary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(authProvider).isLoading;
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.06),
//                           blurRadius: 8),
//                     ],
//                   ),
//                   child: const Icon(Icons.arrow_back_ios_new_rounded,
//                       size: 16, color: AppColors.darkGreen),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               const Text("Create Account", style: AppTextStyles.h1),
//               const SizedBox(height: 6),
//               Text("Join YatraGo and start booking bus tickets across Nepal",
//                   style: AppTextStyles.bodySmall.copyWith(fontSize: 13)),
//               const SizedBox(height: 32),
//               _label("Full Name"),
//               const SizedBox(height: 8),
//               _inputField(
//                 controller: _nameController,
//                 hint: "Ram Bahadur",
//                 icon: Icons.person_outline_rounded,
//               ),
//               const SizedBox(height: 18),
//               _label("Email Address"),
//               const SizedBox(height: 8),
//               _inputField(
//                 controller: _emailController,
//                 hint: "you@example.com",
//                 icon: Icons.email_outlined,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 18),
//               _label("Phone Number"),
//               const SizedBox(height: 8),
//               _inputField(
//                 controller: _phoneController,
//                 hint: "98XXXXXXXX",
//                 icon: Icons.phone_outlined,
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 18),
//               _label("Password"),
//               const SizedBox(height: 8),
//               _inputField(
//                 controller: _passwordController,
//                 hint: "At least 6 characters",
//                 icon: Icons.lock_outline_rounded,
//                 obscure: _obscurePassword,
//                 suffix: GestureDetector(
//                   onTap: () =>
//                       setState(() => _obscurePassword = !_obscurePassword),
//                   child: Icon(
//                     _obscurePassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 18,
//                     color: AppColors.textGrey,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     elevation: 0,
//                   ),
//                   onPressed: isLoading ? null : _handleRegister,
//                   child: isLoading
//                       ? const CircularProgressIndicator(
//                           color: AppColors.white, strokeWidth: 2)
//                       : Text("Create Account",
//                           style:
//                               AppTextStyles.buttonText.copyWith(fontSize: 16)),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: GestureDetector(
//                   onTap: () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const LoginPage()),
//                   ),
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Already have an account? ",
//                       style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
//                       children: [
//                         TextSpan(
//                           text: "Login",
//                           style: AppTextStyles.bodySmall.copyWith(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _label(String text) => Text(text,
//       style: AppTextStyles.bodySmall.copyWith(
//           fontWeight: FontWeight.w700,
//           color: AppColors.textDark,
//           fontSize: 12));

//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//     Widget? suffix,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         keyboardType: keyboardType,
//         style: AppTextStyles.bodyMedium,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: AppTextStyles.bodySmall,
//           prefixIcon: Icon(icon, size: 18, color: AppColors.textGrey),
//           suffixIcon: suffix,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: AppColors.textLight)),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: AppColors.textLight)),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide:
//                   const BorderSide(color: AppColors.primary, width: 2)),
//           filled: true,
//           fillColor: AppColors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }
// }

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:bus_ticket_booking_system/core/theme/app_colors.dart";
import "package:bus_ticket_booking_system/core/theme/app_text_styles.dart";
import "package:bus_ticket_booking_system/features/auth/presentation/pages/login_page.dart";
import "package:bus_ticket_booking_system/features/auth/presentation/providers/auth_provider.dart";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _snack("Please fill name, email and password");
      return;
    }
    if (password.length < 6) {
      _snack("Password must be at least 6 characters");
      return;
    }

    // Backend wants firstName + lastName. Split the full name.
    final parts = fullName.split(" ");
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

    final success = await ref.read(authProvider.notifier).register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );

    if (!mounted) return;

    if (success) {
      _snack("Account created! Please log in.", isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(prefillEmail: email)),
      );
      return;
    }

    final state = ref.read(authProvider);
    state.whenOrNull(
      error: (e, _) => _snack(e.toString().replaceFirst("Exception: ", "")),
    );
  }

  void _snack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.darkGreen, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
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
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16, color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person_add_alt_1_rounded,
                          color: AppColors.white, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text("Create Account",
                        style: AppTextStyles.h1.copyWith(color: AppColors.white)),
                    const SizedBox(height: 8),
                    Text(
                      "Join YatraGo and start booking\nbus tickets across Nepal",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.pale,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Full Name"),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _nameController,
                      hint: "Ram Bahadur",
                    ),
                    const SizedBox(height: 18),
                    _label("Email Address"),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _emailController,
                      hint: "you@example.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    _label("Phone Number"),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _phoneController,
                      hint: "98XXXXXXXX",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),
                    _label("Password"),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _passwordController,
                      hint: "At least 6 characters",
                      obscure: _obscurePassword,
                      suffix: GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _obscurePassword ? "Show" : "Hide",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.darkGreen],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          onPressed: isLoading ? null : _handleRegister,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white, strokeWidth: 2)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.arrow_forward_rounded,
                                        color: AppColors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text("Create Account",
                                        style: AppTextStyles.buttonText
                                            .copyWith(fontSize: 16)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: AppTextStyles.bodySmall
                                .copyWith(fontSize: 13, color: AppColors.textGrey),
                            children: [
                              TextSpan(
                                text: "Login →",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text.toUpperCase(),
        style: AppTextStyles.label,
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySmall,
          suffixIcon: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          filled: true,
          fillColor: AppColors.cardBg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
      ),
    );
  }
}