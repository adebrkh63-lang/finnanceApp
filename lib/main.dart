import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================
/// DATA & PROVIDERS
/// ========================

final Map<String, Map<String, dynamic>> productData = {
  'Topi': {'price': 50000, 'image': 'assets/images/topi.jpg'},
  'Jaket': {'price': 150000, 'image': 'assets/images/jaket.jpg'},
  'Jeans': {'price': 200000, 'image': 'assets/images/jeans.jpg'},
  'Kaos': {'price': 75000, 'image': 'assets/images/kaos.jpg'},
  'Sepatu': {'price': 250000, 'image': 'assets/images/sepatu.jpg'},
  'Kemeja': {'price': 120000, 'image': 'assets/images/kemeja.jpg'},
  'Tas': {'price': 180000, 'image': 'assets/images/tas.jpg'},
  'Sweater': {'price': 160000, 'image': 'assets/images/sweater.jpg'},
  'Celana Pendek': {'price': 90000, 'image': 'assets/images/celana pendek.jpg'}, 
  'Jam Tangan': {'price': 300000, 'image': 'assets/images/jam.jpg'},
  'Kacamata': {'price': 80000, 'image': 'assets/images/kacamata.jpg'},
  'Kalung': {'price': 145000, 'image': 'assets/images/kalung.jpg'},
  'Cincin': {'price': 160000, 'image': 'assets/images/cincin.jpg'},
  'Gelang': {'price': 160000, 'image': 'assets/images/gelang.jpg'},
  'Dompet': {'price': 90000, 'image': 'assets/images/dompet.jpg'},
  'Baju Tidur': {'price': 150000, 'image': 'assets/images/baju tidur.jpg'},
};

// kategori sederhana (nama kategori -> list nama produk)
final Map<String, List<String>> categoriesData = {
  'Semua': productData.keys.toList(),
  'Pakaian': ['Jaket', 'Jeans', 'Kaos', 'Kemeja', 'Sweater', 'Celana Pendek'],
  'Aksesoris': [
    'Topi', 
    'Tas', 
    'Jam Tangan', 
    'Kacamata',
    'Kalung',
    'Cincin',
    'Gelang',
    'Dompet',
    'Baju Tidur'],
  'Sepatu': ['Sepatu'],
};

/// Cart Provider (sama seperti sebelumnya)
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({for (final key in productData.keys) key: 0});

  void increment(String item) {
    state = {...state, item: state[item]! + 1};
  }

  void decrement(String item) {
    if (state[item]! > 0) {
      state = {...state, item: state[item]! - 1};
    }
  }

  void reset() {
    state = {for (final key in state.keys) key: 0};
  }

  int get totalItems => state.values.reduce((a, b) => a + b);

  int get totalPrice {
    int total = 0;
    for (var item in state.keys) {
      total += state[item]! * (productData[item]!['price'] as int);
    }
    return total;
  }

  Map<String, int> get nonZeroItems {
    final newMap = {...state};
    newMap.removeWhere((key, value) => value == 0);
    return newMap;
  }
}

/// History provider (list of checkouts)
final historyProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

/// Search text provider
final searchProvider = StateProvider<String>((ref) => "");

/// Selected Category provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'Semua');

/// Favorites provider (set of product names)
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{});

  void toggle(String item) {
    final newSet = {...state};
    if (newSet.contains(item)) {
      newSet.remove(item);
    } else {
      newSet.add(item);
    }
    state = newSet;
  }

  bool contains(String item) => state.contains(item);

  void clear() => state = <String>{};
}

/// Simple profile provider (store user name)
final profileProvider = StateProvider<String>((ref) => 'Pengguna');

/// ========================
/// MAIN
/// ========================
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // warna biru muda & putih
    const primary = Colors.lightBlue;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Riverpod',
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primary,
          secondary: Colors.lightBlueAccent,
        ),
      ),
      home: const MainPage(),
    );
  }
}

/// ========================
/// MAIN PAGE: bottom nav with 6 item
/// ========================
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int currentIndex = 0;

  // urutan page sesuai bottom nav
  late final pages = <Widget>[
    const ProductPage(), // 0 Produk
    const CategoryPage(), // 1 Kategori
    const FavoritePage(), // 2 Favorit
    const CartPage(), // 3 Keranjang
    const HistoryPage(), // 4 Riwayat
    const ProfilePage(), // 5 Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // lebih dari 3 item
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Produk"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Kategori"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorit"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

/// ========================
/// PRODUCT PAGE (default)
/// ========================
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchProvider).toLowerCase();
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final favorites = ref.watch(favoritesProvider);

    // filter berdasarkan kategori + pencarian
    final filtered = productData.entries.where((entry) {
      final name = entry.key;
      final inCategory = selectedCategory == 'Semua' || (categoriesData[selectedCategory]?.contains(name) ?? false);
      final matchQuery = name.toLowerCase().contains(query);
      return inCategory && matchQuery;
    }).toList();

    final cartNotifier = ref.read(cartProvider.notifier);
    final favNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk Tersedia"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      hintText: "Cari produk...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => ref.read(searchProvider.notifier).state = val,
                  ),
                ),
                const SizedBox(width: 8),
                // quick category pill (shows current)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    selectedCategory,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: filtered.isEmpty
            ? const Center(child: Text("Produk tidak ditemukan"))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final name = filtered[index].key;
                  final data = filtered[index].value;
                  final price = data['price'] as int;
                  final imagePath = data['image'] as String;
                  final isFav = favorites.contains(name);

                  return Card(
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(child: Icon(Icons.image_not_supported)),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: IconButton(
                                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                                        color: isFav ? Colors.redAccent : Colors.grey),
                                    onPressed: () => favNotifier.toggle(name),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          child: Column(
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Rp$price",
                                  style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => cartNotifier.increment(name),
                                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                                    label: const Text("Tambah"),
                                    style: ElevatedButton.styleFrom(minimumSize: const Size(110, 36)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// ========================
/// CATEGORY PAGE
/// ========================
class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final categories = categoriesData.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Kategori")),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // kategori horizontal
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final name = categories[index];
                final isSelected = name == selected;
                return GestureDetector(
                  onTap: () => ref.read(selectedCategoryProvider.notifier).state = name,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.lightBlue : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.lightBlue.shade100),
                      boxShadow: isSelected ? [BoxShadow(color: Colors.lightBlue.withOpacity(0.15), blurRadius: 8)] : null,
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
          const SizedBox(height: 12),
          // preview produk pada kategori
          Expanded(child: const ProductPage()), // reuse product page to show filtered items
        ],
      ),
    );
  }
}

/// ========================
/// FAVORITE PAGE
/// ========================
class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider).toList();
    final cartNotifier = ref.read(cartProvider.notifier);
    final favNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Favorit")),
      body: favs.isEmpty
          ? const Center(child: Text("Belum ada produk favorit"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final name = favs[index];
                final data = productData[name]!;
                final price = data['price'] as int;
                final image = data['image'] as String;

                return Card(
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(image, width: 60, height: 60, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported)),
                    title: Text(name),
                    subtitle: Text("Rp$price"),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () => cartNotifier.increment(name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => favNotifier.toggle(name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// ========================
/// CART PAGE
/// ========================
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final totalItems = cartNotifier.totalItems;
    final totalPrice = cartNotifier.totalPrice;
    final nonZeroItems = cart.entries.where((e) => e.value > 0).toList();
    final history = ref.read(historyProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Keranjang ($totalItems)")),
      body: Column(
        children: [
          Expanded(
            child: nonZeroItems.isEmpty
                ? const Center(child: Text("Keranjang kosong 😢"))
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: nonZeroItems.map((entry) {
                      final item = entry.key;
                      final qty = entry.value;
                      final price = productData[item]!['price'] as int;
                      final image = productData[item]!['image'] as String;
                      final subtotal = qty * price;

                      return Card(
                        color: Colors.blue.shade50,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported)),
                          title: Text(item),
                          subtitle: Text('Rp$price • Subtotal: Rp$subtotal'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => cartNotifier.decrement(item),
                                  icon: const Icon(Icons.remove_circle_outline)),
                              Text('$qty'),
                              IconButton(
                                  onPressed: () => cartNotifier.increment(item),
                                  icon: const Icon(Icons.add_circle_outline)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Total Harga: Rp$totalPrice",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: totalItems == 0
                      ? null
                      : () {
                          history.state = [
                            ...history.state,
                            {'date': DateTime.now(), 'items': {...cart}, 'total': totalPrice}
                          ];
                          cartNotifier.reset();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Checkout berhasil")));
                        },
                  icon: const Icon(Icons.payment),
                  label: const Text("Checkout"),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: cartNotifier.reset,
                  child: const Text("Reset Keranjang"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ========================
/// HISTORY PAGE
/// ========================
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Checkout")),
      body: history.isEmpty
          ? const Center(child: Text("Belum ada riwayat pembelian"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                final date = entry['date'] as DateTime;
                final total = entry['total'] as int;
                final items = entry['items'] as Map<String, int>;

                return Card(
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text("Total: Rp$total"),
                    subtitle: Text(
                      "Tanggal: ${date.day}/${date.month}/${date.year}\n" +
                          (items.entries.where((e) => e.value > 0).map((e) => "${e.key} (${e.value}x)").join(', ')),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// ========================
/// PROFILE PAGE (sederhana + edit nama)
/// ========================
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 48, backgroundColor: Colors.lightBlue.shade100, child: const Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Email: adebarkah@gmail.com", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                // dialog edit nama sederhana
                final controller = TextEditingController(text: name);
                final result = await showDialog<String?>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Ubah Nama"),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                      TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text("Simpan")),
                    ],
                  ),
                );
                if (result != null && result.trim().isNotEmpty) {
                  profileNotifier.state = result.trim();
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profil"),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Pengaturan"),
                subtitle: const Text("Pengaturan aplikasi dasar"),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // reset favorites & cart demo
                ref.read(favoritesProvider.notifier).clear();
                ref.read(cartProvider.notifier).reset();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data demo direset")));
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Reset Data Demo"),
            ),
          ],
        ),
      ),
    );
  }
}
