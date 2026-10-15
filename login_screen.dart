import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'register_screen.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================
  // LOGIN
  // =========================

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username dan password wajib diisi!',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    UserAccount? account;

    for (final user in registeredUsers) {
      if (user.username == username &&
          user.password == password) {
        account = user;
        break;
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username atau password tidak terdaftar!',
          ),
        ),
      );
      return;
    }

    // =========================
    // CEK STATUS AKUN
    // =========================

    if (account.status == 'Pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akun masih menunggu persetujuan Admin Utama.',
          ),
        ),
      );
      return;
    }

    if (account.status == 'Rejected') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akun kamu ditolak oleh Admin Utama.',
          ),
        ),
      );
      return;
    }

    // =========================
    // LOGIN ADMIN
    // =========================

    if (account.role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AdminDashboardScreen(user: account!),
        ),
      );
    } else {
      // =========================
      // LOGIN USER
      // =========================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserDashboardScreen(user: account!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF004D40),
              Color(0xFF00BFA6),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Card(
                elevation: 10,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(24),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    children: [
                      // =========================
                      // LOGO
                      // =========================

                      Image.asset(
                        'images/logosmk.png',
                        height: 90,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Icon(
                            Icons.school,
                            size: 80,
                            color: Colors.teal,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'SMK Negeri 1 Beringin',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Task & Inventory System',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // USERNAME
                      // =========================

                      TextField(
                        controller:
                            _usernameController,

                        decoration: InputDecoration(
                          labelText: 'Username / NIS',
                          prefixIcon:
                              const Icon(Icons.person),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =========================
                      // PASSWORD
                      // =========================

                      TextField(
                        controller:
                            _passwordController,

                        obscureText:
                            _obscurePassword,

                        decoration: InputDecoration(
                          labelText: 'Password',

                          prefixIcon:
                              const Icon(Icons.lock),

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },

                            icon: Icon(
                              _obscurePassword
                                  ? Icons
                                      .visibility_off
                                  : Icons.visibility,
                            ),
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // =========================
                      // LOGIN BUTTON
                      // =========================

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : _handleLogin,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.teal,

                            foregroundColor:
                                Colors.white,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // REGISTER
                      // =========================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          const Text(
                            'Belum punya akun? ',
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen(),
                                ),
                              );
                            },

                            child: const Text(
                              'Daftar sekarang',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}