import 'package:djadol_mobile/agen/absent/absent_page.dart';
import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zcard.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'agen/jurnal/jurnal_list.dart';
import 'agen/retail/retail_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                  fit: BoxFit.cover,
                  'https://plus.unsplash.com/premium_vector-1682268954127-8882f9026d4b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGRlbGl2ZXJ5fGVufDB8fDB8fHww'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Menu',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  BigMenuCard(
                    title: 'Absensi',
                    description: 'Absen masuk dan keluar',
                    icon: Icons.gps_fixed,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AbsentPage(),
                      ),
                    ),
                  ),
                  BigMenuCard(
                    title: 'Jurnal',
                    description: 'Transaksi penjualan produk',
                    icon: Icons.production_quantity_limits,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const JurnalListPage(),
                      ),
                    ),
                  ),
                  BigMenuCard(
                    title: 'Retail',
                    description: 'Tambah dan daftar toko',
                    icon: Icons.store,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RetailListPage(),
                      ),
                    ),
                  ),
                  BigMenuCard(
                    title: 'Logout',
                    description: 'Keluar dari aplikasi',
                    icon: Icons.exit_to_app,
                    onTap: () async {
                      confirmDanger(
                        context,
                        title: 'Logout',
                      ).then((value) async {
                        if (value) {
                          await Store().clearToken();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BigMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const BigMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              radius: 28,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
