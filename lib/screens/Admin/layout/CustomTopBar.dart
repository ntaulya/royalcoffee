import 'package:flutter/material.dart';
import '../home/Track/StaffOrderView.dart';
import '../home/DashboardAdmin.dart';
import '../../../../models/StaffRole.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomTopBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context); // close menu
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardAdmin()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Waiters'),
                onTap: () {
                  Navigator.pop(context); // close menu
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StaffOrderView(role: StaffRole.waiter),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_cafe),
                title: const Text('Dapur'),
                onTap: () {
                  Navigator.pop(context); // close menu
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StaffOrderView(role: StaffRole.barista),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.switch_account),
                title: const Text('Switch Mode: User'),
                onTap: () {
                  Navigator.pop(context); // close menu
                  Navigator.pop(context); // close menu
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.brown),
        onPressed: () => _openMenu(context),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
