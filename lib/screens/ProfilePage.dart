import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController(text: 'Muhammad Andi Syaifullah');
  final emailController = TextEditingController(text: 'andisyaifullah@gmail.com');
  final phoneController = TextEditingController(text: '082216458858');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A491F), // Warna coklat atas & bawah
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Colors.yellowAccent),
                const SizedBox(width: 10),
                const Text(
                  'My profile',
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Kontainer isi profile
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nama'),
                  _buildTextField(nameController),
                  const SizedBox(height: 16),
                  _buildLabel('Email'),
                  _buildTextField(emailController),
                  const SizedBox(height: 16),
                  _buildLabel('Nomor Telepon'),
                  _buildTextField(phoneController),
                  const Spacer(),
                  Center(
                    child: Column(
                      children: [
                        _buildButton(
                          label: 'Update Profile',
                          onPressed: () {
                            // TODO: Tambahkan logic update
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildButton(
                          label: 'Logout',
                          onPressed: () {
                            // TODO: Tambahkan logic logout
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF4C2609),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFF1D7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A491F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
