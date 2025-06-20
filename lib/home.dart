import 'package:djadol_mobile/agen/absent/absent_list.dart';
import 'package:djadol_mobile/agen/visitasi/visitasi_list.dart';
import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';

import 'agen/jurnal/jurnal_list.dart';
import 'agen/retail/retail_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> gradient = [
      Colors.blue.shade400,
      Colors.purple.shade300,
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Absensi',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: MenuCardVertical(
                            icon: Icons.gps_fixed,
                            title: 'Masuk',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AbsentListPage(
                                  type: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: MenuCardVertical(
                            icon: Icons.gps_off,
                            title: 'Pulang',
                            gradient: [
                              Colors.red.shade500,
                              Colors.orange.shade300,
                            ],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AbsentListPage(
                                  type: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    MenuCardHorizontal(
                      title: 'Sales',
                      description: 'Transaksi penjualan produk',
                      icon: Icons.production_quantity_limits,
                      gradient: gradient,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JurnalListPage(),
                        ),
                      ),
                    ),
                    MenuCardHorizontal(
                      title: 'Kunjungan',
                      description: 'Daftar kunjungan agen',
                      icon: Icons.directions_walk_sharp,
                      gradient: gradient,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const VisitasiListPage(),
                        ),
                      ),
                    ),
                    MenuCardHorizontal(
                      title: 'Toko',
                      description: 'Tambah dan daftar toko',
                      icon: Icons.store,
                      gradient: gradient,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RetailListPage(),
                        ),
                      ),
                    ),
                    MenuCardHorizontal(
                      title: 'Logout',
                      description: 'Keluar dari aplikasi',
                      gradient: gradient,
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
      ),
    );
  }
}

class VerticalMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const VerticalMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.blue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCardVertical extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final List<Color> gradient;

  const MenuCardVertical({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.gradient = const [
      Colors.blue,
      Colors.purple,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              radius: 28,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCardHorizontal extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onTap;
  final List<Color> gradient;

  const MenuCardHorizontal({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onTap,
    this.gradient = const [
      Colors.blue,
      Colors.purple,
    ],
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
            colors: gradient,
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
              backgroundColor: Colors.white.withValues(alpha: 0.2),
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
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
