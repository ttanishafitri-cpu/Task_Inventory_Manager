import 'package:flutter/material.dart';
import '../models/item_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  String _selectedRole = 'User';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================
  // REGISTER
  // =========================

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username =
        _usernameController.text.trim();

    final password =
        _passwordController.text;

    final alreadyExists =
        registeredUsers.any(
      (user) => user.username == username,
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Username sudah terdaftar!',
          ),
        ),
      );

      return;
    }

    // =========================
    // AKUN BARU = PENDING
    // =========================

    registeredUsers.add(
      UserAccount(
        username: username,
        password: password,
        role: _selectedRole,
        status: 'Pending',
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Registrasi berhasil! Menunggu persetujuan Admin Utama.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrasi Akun',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Silakan isi data berikut.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              // USERNAME

              TextFormField(
                controller:
                    _usernameController,

                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon:
                      const Icon(Icons.person),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Username wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // PASSWORD

              TextFormField(
                controller:
                    _passwordController,

                obscureText: true,

                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                      const Icon(Icons.lock),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Password wajib diisi';
                  }

                  if (value.length < 4) {
                    return 'Password minimal 4 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // ROLE

              DropdownButtonFormField<String>(
                value: _selectedRole,

                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon:
                      const Icon(Icons.badge),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'User',
                    child: Text('User'),
                  ),

                  DropdownMenuItem(
                    value: 'Admin',
                    child: Text('Admin'),
                  ),
                ],

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole =
                          value;
                    });
                  }
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: _register,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.teal,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}