import 'package:djadol_mobile/agen/absent/absent_list.dart';
import 'package:djadol_mobile/agen/jurnal/stock_product_list.dart';
import 'package:djadol_mobile/agen/visitasi/visitasi_list.dart';
import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/auth/profile_page.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';

import 'agen/inquiry/inquiry_list.dart';
import 'agen/jurnal/jurnal_list.dart';
import 'agen/jurnal/print/printer_settings_page.dart';
import 'agen/retail/retail_list.dart';
import 'core/geo_location/geo_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    cekGps();
  }

  Future<void> cekGps() async {
    bool isActiveGps = await GeoLocation().check();
    if (!isActiveGps) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gps_off, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                'Tolong aktifkan GPS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Aplikasi membutuhkan akses lokasi. Silakan aktifkan GPS pada perangkat Anda untuk melanjutkan.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // icon: const Icon(Icons.),
                  label: const Text('Tutup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    bool isActiveGps = await GeoLocation().check();
                    if (isActiveGps) Navigator.of(context).pop();
                    // GeoLocation().openSettings();
                  },
                ),
              ),
            ],
          ),
        ),
      );
      ZToast.error(context, 'Please enable GPS to continue');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradient = [
      Colors.blue.shade400,
      Colors.purple.shade300,
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.purple.shade300
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.transparent,
                          child:
                              Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome,',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            Store().fullName ?? 'User',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Absensi',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
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
                  title: 'Stock',
                  description: 'Stock produk di agen',
                  icon: Icons.inventory,
                  gradient: gradient,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StockProductListPage(),
                    ),
                  ),
                ),
                MenuCardHorizontal(
                  title: 'Ploting Barang',
                  description: 'Terima barang dari warehouse',
                  icon: Icons.inventory_2,
                  gradient: gradient,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InquiryListPage(),
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
                  title: 'Setting Printer',
                  description: 'Hubungkan printer thermal bluetooth',
                  icon: Icons.print,
                  gradient: gradient,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrinterSettingsPage(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: MenuCardVertical(
                        icon: Icons.exit_to_app,
                        title: 'Logout',
                        gradient: [
                          const Color.fromARGB(255, 12, 113, 229),
                          Colors.red.shade300,
                        ],
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: MenuCardVertical(
                        icon: Icons.person,
                        title: 'Profile',
                        gradient: [
                          const Color.fromARGB(255, 12, 113, 229),
                          Colors.orange.shade300,
                        ],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                ,
               
              ],
            ),
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
