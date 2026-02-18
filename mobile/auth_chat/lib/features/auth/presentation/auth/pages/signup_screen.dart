import 'package:auth_chat/features/auth/presentation/widgets/custom_bar.dart';
import 'package:auth_chat/features/auth/presentation/widgets/text.dart';
import 'package:auth_chat/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_chat/features/auth/presentation/auth/pages/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  get formInputNameSize => 15;
  bool _isChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignupEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 250, 250),
      appBar: CustomAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false,
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
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Create your account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(text: 'Name', size: formInputNameSize),
                      const SizedBox(height: 5),
                      // Email Field
                      textInput(
                        controller: _nameController,
                        hintText: 'ex: jon smith',
                        inputType: TextInputType.emailAddress,
                        invalidInputMessege: 'Please enter a valid name',
                      ),

                      const SizedBox(height: 10),

                      customText(text: 'Email', size: formInputNameSize),
                      const SizedBox(height: 5),
                      textInput(
                        controller: _emailController,
                        hintText: 'ex: jon.smith@gmail.com',
                        inputType: TextInputType.emailAddress,
                        invalidInputMessege: 'please enter a valid email',
                      ),

                      const SizedBox(height: 10),

                      customText(text: 'Password', size: formInputNameSize),
                      const SizedBox(height: 5),
                      // Password Field
                      textInput(
                        controller: _passwordController,
                        hintText: '********',
                        inputType: TextInputType.visiblePassword,
                        invalidInputMessege: 'Please enter a valid password',
                      ),

                      const SizedBox(height: 10),

                      customText(
                        text: 'Confirm password',
                        size: formInputNameSize,
                      ),
                      const SizedBox(height: 5),
                      // Password Field
                      textInput(
                        controller: _confirmPasswordController,
                        hintText: '********',
                        inputType: TextInputType.visiblePassword,
                        invalidInputMessege: 'Please enter your password again',
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),


                          RichText(
                            text: const TextSpan(
                              text: 'I understood the  ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Term & policy',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading ? null : _handleSignup,
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
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    },
                  ),
                // signButton(
                //   buttonTitle: 'SIGN UP',
                //   radius: 8,
                //   onpressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       final password = _passwordController.text.trim();
                //       final confirmPassword = _confirmPasswordController.text
                //           .trim();

                //       if (password != confirmPassword) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Text('Passwords do not match'),
                //           ),
                //         );
                //         return;
                //       }

                //       if (!_isChecked) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Text('Please agree to the Terms & Policy'),
                //           ),
                //         );
                //         return;
                //       }

                //       // Dispatch SignupRequested event
                //       context.read<AuthBloc>().add(
                //         SignUpRequested(
                //           name: _nameController.text.trim(),
                //           email: _emailController.text.trim(),
                //           password: password,
                //         ),
                //       );
                //     }
                //   },
                // ),

                const Spacer(),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'have an account? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'SIGN IN',
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

          // child: Padding(
          //   padding: const EdgeInsets.all(24.0),
          //   child: Form(
          //     key: _formKey,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         const SizedBox(height: 20),
          //         // Header
          //         const Text(
          //           'Create Account',
          //           style: TextStyle(
          //             fontSize: 32,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //         const SizedBox(height: 8),
          //         const Text(
          //           'Sign up to get started',
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         const SizedBox(height: 32),
          //         // Name Field
          //         TextFormField(
          //           controller: _nameController,
          //           style: const TextStyle(color: Colors.white),
          //           decoration: InputDecoration(
          //             labelText: 'Full Name',
          //             labelStyle: const TextStyle(color: Colors.grey),
          //             prefixIcon: const Icon(Icons.person, color: Colors.grey),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Color(0xFF4A90E2)),
          //             ),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter your name';
          //             }
          //             return null;
          //           },
          //         ),
          //         const SizedBox(height: 16),
          //         // Email Field
          //         TextFormField(
          //           controller: _emailController,
          //           keyboardType: TextInputType.emailAddress,
          //           style: const TextStyle(color: Colors.white),
          //           decoration: InputDecoration(
          //             labelText: 'Email',
          //             labelStyle: const TextStyle(color: Colors.grey),
          //             prefixIcon: const Icon(Icons.email, color: Colors.grey),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Color(0xFF4A90E2)),
          //             ),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter your email';
          //             }
          //             if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          //               return 'Please enter a valid email';
          //             }
          //             return null;
          //           },
          //         ),
          //         const SizedBox(height: 16),
          //         // Password Field
          //         TextFormField(
          //           controller: _passwordController,
          //           obscureText: _obscurePassword,
          //           style: const TextStyle(color: Colors.white),
          //           decoration: InputDecoration(
          //             labelText: 'Password',
          //             labelStyle: const TextStyle(color: Colors.grey),
          //             prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          //             suffixIcon: IconButton(
          //               icon: Icon(
          //                 _obscurePassword ? Icons.visibility : Icons.visibility_off,
          //                 color: Colors.grey,
          //               ),
          //               onPressed: () {
          //                 setState(() {
          //                   _obscurePassword = !_obscurePassword;
          //                 });
          //               },
          //             ),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Color(0xFF4A90E2)),
          //             ),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter your password';
          //             }
          //             if (value.length < 6) {
          //               return 'Password must be at least 6 characters';
          //             }
          //             return null;
          //           },
          //         ),
          //         const SizedBox(height: 16),
          //         // Confirm Password Field
          //         TextFormField(
          //           controller: _confirmPasswordController,
          //           obscureText: _obscureConfirmPassword,
          //           style: const TextStyle(color: Colors.white),
          //           decoration: InputDecoration(
          //             labelText: 'Confirm Password',
          //             labelStyle: const TextStyle(color: Colors.grey),
          //             prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          //             suffixIcon: IconButton(
          //               icon: Icon(
          //                 _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
          //                 color: Colors.grey,
          //               ),
          //               onPressed: () {
          //                 setState(() {
          //                   _obscureConfirmPassword = !_obscureConfirmPassword;
          //                 });
          //               },
          //             ),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Colors.grey),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //               borderSide: const BorderSide(color: Color(0xFF4A90E2)),
          //             ),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please confirm your password';
          //             }
          //             if (value != _passwordController.text) {
          //               return 'Passwords do not match';
          //             }
          //             return null;
          //           },
          //         ),
          //         const SizedBox(height: 32),
          //         // Sign Up Button
          //         BlocBuilder<AuthBloc, AuthState>(
          //           builder: (context, state) {
          //             return ElevatedButton(
          //               onPressed: state is AuthLoading ? null : _handleSignup,
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF4A90E2),
          //                 foregroundColor: Colors.white,
          //                 padding: const EdgeInsets.symmetric(vertical: 16),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(12),
          //                 ),
          //               ),
          //               child: state is AuthLoading
          //                   ? const SizedBox(
          //                       height: 20,
          //                       width: 20,
          //                       child: CircularProgressIndicator(
          //                         strokeWidth: 2,
          //                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //                       ),
          //                     )
          //                   : const Text(
          //                       'Sign Up',
          //                       style: TextStyle(
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
} 