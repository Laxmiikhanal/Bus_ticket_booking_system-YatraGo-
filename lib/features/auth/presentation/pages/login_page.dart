import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:bus_ticket_booking_system/core/theme/app_colors.dart";
import "package:bus_ticket_booking_system/core/theme/app_text_styles.dart";
import "package:bus_ticket_booking_system/features/auth/presentation/pages/register_page.dart";
import "package:bus_ticket_booking_system/features/auth/presentation/providers/auth_provider.dart";
import "package:bus_ticket_booking_system/features/home/presentation/screens/home_screen.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _snack("Please enter email and password");
      return;
    }
    await ref.read(authProvider.notifier).login(email, password);

    if (!mounted) return;
    final state = ref.read(authProvider);
    state.when(
      data: (user) {
        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
          );
        }
      },
      loading: () {},
      error: (e, _) => _snack(e.toString().replaceFirst("Exception: ", "")),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: AppColors.darkGreen),
                ),
              ),
              const SizedBox(height: 32),
              const Text("Welcome back", style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text("Login to continue booking your bus tickets",
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 36),
              _label("Email Address"),
              const SizedBox(height: 8),
              _inputField(
                controller: _emailController,
                hint: "you@example.com",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _label("Password"),
              const SizedBox(height: 8),
              _inputField(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_outline_rounded,
                obscure: _obscurePassword,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.white, strokeWidth: 2)
                      : Text("Login",
                          style:
                              AppTextStyles.buttonText.copyWith(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              const Row(children: [
                Expanded(child: Divider(color: AppColors.textLight)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("or", style: AppTextStyles.bodySmall)),
                Expanded(child: Divider(color: AppColors.textLight)),
              ]),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Do not have an account? ",
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Register",
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          fontSize: 12));

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
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
          prefixIcon: Icon(icon, size: 18, color: AppColors.textGrey),
          suffixIcon: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.textLight)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.textLight)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 2)),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
