import 'package:flutter/material.dart';
import '../../../controllers/AuthController.dart';
import '../../../admin/home/DashboardAdmin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();
  final nameController = TextEditingController(text: 'Nama Lengkap');
  final emailController = TextEditingController(text: 'example@gmail.com');
  final phoneController = TextEditingController(text: '08xxxxxxxxxx');

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final profile = await _authController.getProfile(context);
    setState(() {
      nameController.text = profile.namaLengkap;
      emailController.text = profile.email;
      phoneController.text = profile.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A491F),
      body: Column(
        children: [
          const SizedBox(height: 50),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.arrow_back, color: Color(0xFFF5CB58)),
                SizedBox(width: 10),
                Text(
                  'My profile',
                  style: TextStyle(
                    color: Color(0xFFF5CB58),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Isi profil dengan lengkungan hanya di atas
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  // bottom corners default (Radius.zero) → tidak melengkung
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nama Lengkap'),
                  _buildTextField(nameController),
                  const SizedBox(height: 16),
                  _buildLabel('Email'),
                  _buildTextField(emailController, enabled: false),
                  const SizedBox(height: 16),
                  _buildLabel('Nomor Telepon'),
                  _buildTextField(phoneController),
                  const Spacer(),

                  // Tombol full width
                  _buildButton(
                    label: 'Update Profile',
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF7A491F),
                    borderColor: const Color(0xFF7A491F),
                  ),
                  const SizedBox(height: 10),
                  _buildButton(
                    label: 'Switch to Admin',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardAdmin()),
                      );
                    }, 
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF7A491F),
                    borderColor: const Color(0xFF7A491F),
                  ),
                  const SizedBox(height: 10),
                  _buildButton(
                    label: 'Logout',
                    onPressed: () => _authController.logOut(context),
                    backgroundColor: const Color(0xFF7A491F),
                    textColor: Colors.white,
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

  Widget _buildTextField(TextEditingController controller, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? const Color(0xFFFFF1D7) : Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color textColor = const Color(0xFF7A491F),
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 2)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
