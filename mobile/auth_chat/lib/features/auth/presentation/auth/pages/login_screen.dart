import 'package:auth_chat/features/auth/presentation/widgets/button.dart';
import 'package:auth_chat/features/auth/presentation/widgets/text.dart';
import 'package:auth_chat/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_chat/features/auth/presentation/auth/pages/signup_screen.dart';
import 'package:auth_chat/features/auth/presentation/auth/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  double formInputTypeSize = 15;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 245, 245),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: 
Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                // Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple.shade700),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'ECOM',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Sign into your account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                  
                ),

                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(text: 'Email', size: formInputTypeSize),
                      const SizedBox(height: 5),
                      // Email Field
                      textInput(
                        controller: _emailController,
                        hintText: 'ex: jon.smith@email.com',
                        inputType: TextInputType.emailAddress,
                        invalidInputMessege: 'Please enter valid email',
                      ),

                      const SizedBox(height: 20),

                      customText(text: 'Password', size: formInputTypeSize),
                      const SizedBox(height: 5),
                      // Password Field
                      textInput(
                        controller: _passwordController,
                        hintText: '********',
                        inputType: TextInputType.visiblePassword,
                        invalidInputMessege: 'Please enter valid password',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    },
                  ),

                const Spacer(),


                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'Don’t have an account? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'SIGN UP',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),

        //   child: Padding(
        //     padding: const EdgeInsets.all(24.0),
        //     child: Form(
        //       key: _formKey,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: [
        //           const SizedBox(height: 60),
        //           // Header
        //           const Text(
        //             'Welcome Back',
        //             style: TextStyle(
        //               fontSize: 32,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white,
        //             ),
        //           ),
        //           const SizedBox(height: 8),
        //           const Text(
        //             'Sign in to continue',
        //             style: TextStyle(
        //               fontSize: 16,
        //               color: Colors.grey,
        //             ),
        //           ),
        //           const SizedBox(height: 48),
        //           // Email Field
        //           TextFormField(
        //             controller: _emailController,
        //             keyboardType: TextInputType.emailAddress,
        //             style: const TextStyle(color: Colors.white),
        //             decoration: InputDecoration(
        //               labelText: 'Email',
        //               labelStyle: const TextStyle(color: Colors.grey),
        //               prefixIcon: const Icon(Icons.email, color: Colors.grey),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Colors.grey),
        //               ),
        //               enabledBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Colors.grey),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Color(0xFF4A90E2)),
        //               ),
        //             ),
        //             validator: (value) {
        //               if (value == null || value.isEmpty) {
        //                 return 'Please enter your email';
        //               }
        //               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        //                 return 'Please enter a valid email';
        //               }
        //               return null;
        //             },
        //           ),
        //           const SizedBox(height: 16),
        //           // Password Field
        //           TextFormField(
        //             controller: _passwordController,
        //             obscureText: _obscurePassword,
        //             style: const TextStyle(color: Colors.white),
        //             decoration: InputDecoration(
        //               labelText: 'Password',
        //               labelStyle: const TextStyle(color: Colors.grey),
        //               prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        //               suffixIcon: IconButton(
        //                 icon: Icon(
        //                   _obscurePassword ? Icons.visibility : Icons.visibility_off,
        //                   color: Colors.grey,
        //                 ),
        //                 onPressed: () {
        //                   setState(() {
        //                     _obscurePassword = !_obscurePassword;
        //                   });
        //                 },
        //               ),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Colors.grey),
        //               ),
        //               enabledBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Colors.grey),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 borderSide: const BorderSide(color: Color(0xFF4A90E2)),
        //               ),
        //             ),
        //             validator: (value) {
        //               if (value == null || value.isEmpty) {
        //                 return 'Please enter your password';
        //               }
        //               if (value.length < 6) {
        //                 return 'Password must be at least 6 characters';
        //               }
        //               return null;
        //             },
        //           ),
        //           const SizedBox(height: 24),
        //           // Login Button
        //           BlocBuilder<AuthBloc, AuthState>(
        //             builder: (context, state) {
        //               return ElevatedButton(
        //                 onPressed: state is AuthLoading ? null : _handleLogin,
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: const Color(0xFF4A90E2),
        //                   foregroundColor: Colors.white,
        //                   padding: const EdgeInsets.symmetric(vertical: 16),
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(12),
        //                   ),
        //                 ),
        //                 child: state is AuthLoading
        //                     ? const SizedBox(
        //                         height: 20,
        //                         width: 20,
        //                         child: CircularProgressIndicator(
        //                           strokeWidth: 2,
        //                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //                         ),
        //                       )
        //                     : const Text(
        //                         'Sign In',
        //                         style: TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //               );
        //             },
        //           ),
        //           const SizedBox(height: 24),
        //           // Sign Up Link
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               const Text(
        //                 "Don't have an account? ",
        //                 style: TextStyle(color: Colors.grey),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (context) => const SignupScreen(),
        //                     ),
        //                   );
        //                 },
        //                 child: const Text(
        //                   'Sign Up',
        //                   style: TextStyle(
        //                     color: Color(0xFF4A90E2),
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    ));
  }
} 