
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srishti/features/auth/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _authService = AuthService();
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginView = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      if (_isLoginView) {
        await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await _authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _nameController.text.trim(),
        );
        _authService.showAuthMessage(context, 'Success! Please check your email for a confirmation link.', isError: false);
        // Switch to login view after successful signup
        setState(() => _isLoginView = true);
      }
      // On successful login, a listener elsewhere in the app would navigate.
    } on AuthException catch (e) {
      _authService.showAuthMessage(context, e.message);
    } catch (e) {
      _authService.showAuthMessage(context, 'An unexpected error occurred.');
    } finally {
      if(mounted) {
         setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleOAuth(OAuthProvider provider) async {
    try {
      await _authService.signInWithOAuth(provider);
    } on AuthException catch (e) {
      _authService.showAuthMessage(context, e.message);
    } catch (e) {
      _authService.showAuthMessage(context, 'An unexpected error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildAuthToggler(),
                const SizedBox(height: 24),
                if (!_isLoginView) ...[
                  _buildTextField(controller: _nameController, hint: 'Full Name', icon: Icons.person_outline, validator: (val) => val!.isEmpty ? 'Please enter your name' : null),
                  const SizedBox(height: 16),
                ],
                _buildTextField(controller: _emailController, hint: 'Email', icon: Icons.alternate_email, keyboardType: TextInputType.emailAddress, validator: (val) => (val == null || !val.contains('@')) ? 'Please enter a valid email' : null),
                const SizedBox(height: 16),
                _buildTextField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, obscureText: true, validator: (val) => (val == null || val.length < 6) ? 'Password must be at least 6 characters' : null),
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 24),
                _buildSeparator(),
                const SizedBox(height: 24),
                _buildSocialAuthButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER HELPERS ---
  
  Widget _buildHeader() => Column(
    children: [
      Text('Srishti', style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 8),
      Text('The Intelligent Creation Engine', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
    ],
  );

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool obscureText = false, TextInputType? keyboardType, String? Function(String?)? validator}) => TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2)),
    ),
  );

  Widget _buildSubmitButton() => ElevatedButton(
    onPressed: _isLoading ? null : _handleAuth,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
    child: _isLoading
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
        : Text(_isLoginView ? 'Login' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _buildAuthToggler() => Container(
    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: [
        Expanded(child: _buildToggleButton('Login', _isLoginView, () => setState(() => _isLoginView = true))),
        Expanded(child: _buildToggleButton('Sign Up', !_isLoginView, () => setState(() => _isLoginView = false))),
      ],
    ),
  );

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed) => GestureDetector(
    onTap: onPressed,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

  Widget _buildSeparator() => const Row(
    children: [
      Expanded(child: Divider(color: Colors.white24)),
      Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR', style: TextStyle(color: Colors.white54))),
      Expanded(child: Divider(color: Colors.white24)),
    ],
  );

  Widget _buildSocialAuthButtons() => Row(
    children: [
      Expanded(child: _buildSocialButton('Google', () => _handleOAuth(OAuthProvider.google))),
      const SizedBox(width: 16),
      Expanded(child: _buildSocialButton('GitHub', () => _handleOAuth(OAuthProvider.github))),
    ],
  );

  Widget _buildSocialButton(String text, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      backgroundColor: Colors.black.withOpacity(0.3),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Colors.white.withOpacity(0.2))),
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
