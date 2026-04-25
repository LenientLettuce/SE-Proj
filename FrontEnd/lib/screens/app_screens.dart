import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';
import 'buyer/product_screens.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (state.isBootstrapping) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (!state.isLoggedIn) return const AuthScreen();
        if (state.isAdmin) return const AdminDashboardScreen();
        if (state.isArtisan) return const ArtisanHomeScreen();
        return const CustomerHomeScreen();
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  String _role = 'customer';
  bool _isLogin = true;

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Icon(Icons.storefront, size: 60),
                  const SizedBox(height: 12),
                  Text(
                    'Artisans Marketplace',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customers can shop. Artisans can sell. Admin can supervise.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('Login')),
                      ButtonSegment(value: false, label: Text('Register')),
                    ],
                    selected: {_isLogin},
                    onSelectionChanged: (value) => setState(() => _isLogin = value.first),
                  ),
                  const SizedBox(height: 20),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ErrorBanner(message: state.error!),
                    ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: _isLogin ? _buildLogin(context, state) : _buildRegister(context, state),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Demo roles supported by backend: customer, artisan, admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context, AppState state) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _loginEmail,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _loginPassword,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: state.isBusy
                ? null
                : () async {
                    if (!_loginFormKey.currentState!.validate()) return;
                    try {
                      await context.read<AppState>().login(_loginEmail.text.trim(), _loginPassword.text.trim());
                    } catch (_) {
                      if (!context.mounted) return;
                      _showSnack(context, state.error ?? 'Login failed');
                    }
                  },
            child: Text(state.isBusy ? 'Please wait...' : 'Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegister(BuildContext context, AppState state) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Full name'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) => (v == null || v.length < 8) ? 'Minimum 8 characters' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: const InputDecoration(labelText: 'Role'),
            items: const [
              DropdownMenuItem(value: 'customer', child: Text('Customer')),
              DropdownMenuItem(value: 'artisan', child: Text('Artisan')),
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
            ],
            onChanged: (v) => setState(() => _role = v ?? 'customer'),
          ),
          const SizedBox(height: 12),
          TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 12),
          TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
          const SizedBox(height: 12),
          TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City')),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: state.isBusy
                ? null
                : () async {
                    if (!_registerFormKey.currentState!.validate()) return;
                    try {
                      await context.read<AppState>().register(
                            fullName: _name.text.trim(),
                            email: _email.text.trim(),
                            password: _password.text.trim(),
                            role: _role,
                            phone: _phone.text.trim(),
                            address: _address.text.trim(),
                            city: _city.text.trim(),
                          );
                    } catch (_) {
                      if (!context.mounted) return;
                      _showSnack(context, state.error ?? 'Registration failed');
                    }
                  },
            child: Text(state.isBusy ? 'Please wait...' : 'Create account'),
          ),
        ],
      ),
    );
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _search = TextEditingController();
  String _category = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().refreshAll();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = ['All', ...state.categories];
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${state.user?.fullName.split(' ').first ?? 'Customer'}'),
        actions: [
          IconButton(onPressed: () => context.read<AppState>().logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AppState>().refreshAll(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => context.read<AppState>().loadProducts(search: _search.text, category: _category),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _category,
                  items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) {
                    setState(() => _category = v ?? 'All');
                    context.read<AppState>().loadProducts(search: _search.text, category: v);
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            if (state.products.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('No products found yet.')),
              )
            else
              ...state.products.map(
                (product) => Card(
                  child: ListTile(
                    leading: _ProductThumb(imageUrl: product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('${product.category} • ${product.artisanName}\nStock: ${product.stock}'),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rs ${product.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 28,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: product.stock <= 0
                                ? null
                                : () async {
                                    try {
                                      await context.read<AppState>().addToCart(product);
                                      if (!context.mounted) return;
                                      _showSnack(context, '${product.name} added to cart');
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      _showSnack(context, e.toString().replaceFirst('Exception: ', ''));
                                    }
                                  },
                            child: const Text('Add'),
                          ),
                        )
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 1) Navigator.pushNamed(context, '/catalog');
          if (i == 3) Navigator.pushNamed(context, '/cart');
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.cart.items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(child: Text('Your cart is empty.')),
            )
          else ...[
            ...state.cart.items.map((item) => Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Qty ${item.quantity} • Rs ${item.price.toStringAsFixed(0)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context.read<AppState>().removeFromCart(item.productId),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Rs ${state.cart.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      child: const Text('Proceed to checkout'),
                    )
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _address = TextEditingController();
  String _paymentMethod = 'cod';

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    _address.text = _address.text.isEmpty ? (state.user?.address ?? '') : _address.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _address,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Shipping address'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMethod,
            decoration: const InputDecoration(labelText: 'Payment method'),
            items: const [
              DropdownMenuItem(value: 'cod', child: Text('Cash on delivery')),
              DropdownMenuItem(value: 'card', child: Text('Card')),
            ],
            onChanged: (v) => setState(() => _paymentMethod = v ?? 'cod'),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Order total: Rs ${state.cart.total.toStringAsFixed(0)}'),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.cart.items.isEmpty
                ? null
                : () async {
                    if (_address.text.trim().isEmpty) {
                      _showSnack(context, 'Please enter shipping address');
                      return;
                    }
                    try {
                      await context.read<AppState>().checkout(
                            paymentMethod: _paymentMethod,
                            shippingAddress: _address.text.trim(),
                          );
                      if (!context.mounted) return;
                      Navigator.popUntil(context, (route) => route.isFirst);
                      _showSnack(context, 'Order placed successfully');
                    } catch (e) {
                      if (!context.mounted) return;
                      _showSnack(context, e.toString().replaceFirst('Exception: ', ''));
                    }
                  },
            child: const Text('Place order'),
          )
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppState>().orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: orders.isEmpty
            ? [const Padding(padding: EdgeInsets.only(top: 48), child: Center(child: Text('No orders yet.')))]
            : orders
                .map((order) => Card(
                      child: ExpansionTile(
                        title: Text('Order ${order.id.substring(0, 6)} • ${order.status}'),
                        subtitle: Text('Rs ${order.totalAmount.toStringAsFixed(0)}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${order.shippingAddress}'),
                                const SizedBox(height: 8),
                                ...order.items.map((item) => Text('${item.name} x ${item.quantity}')),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
      ),
    );
  }
}

class ArtisanHomeScreen extends StatefulWidget {
  const ArtisanHomeScreen({super.key});

  @override
  State<ArtisanHomeScreen> createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends State<ArtisanHomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().refreshAll();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Artisan Studio • ${state.user?.fullName ?? ''}'),
        bottom: TabBar(controller: _controller, tabs: const [Tab(text: 'Products'), Tab(text: 'Orders')]),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/edit-product'),
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(onPressed: () => context.read<AppState>().logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: const [ArtisanProductsTab(), ArtisanOrdersTab()],
      ),
    );
  }
}

class ArtisanProductsTab extends StatelessWidget {
  const ArtisanProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<AppState>().sellerProducts;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: products.isEmpty
          ? [const Padding(padding: EdgeInsets.only(top: 48), child: Center(child: Text('No products listed yet.')))]
          : products
              .map(
                (product) => Card(
                  child: ListTile(
                    leading: _ProductThumb(imageUrl: product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('${product.category} • Stock ${product.stock}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          Navigator.pushNamed(context, '/edit-product', arguments: product);
                        } else {
                          await context.read<AppState>().deleteProduct(product.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class ArtisanOrdersTab extends StatelessWidget {
  const ArtisanOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppState>().artisanOrders;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: orders.isEmpty
          ? [const Padding(padding: EdgeInsets.only(top: 48), child: Center(child: Text('No artisan orders yet.')))]
          : orders
              .map(
                (order) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order ${order.id.substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(order.status.toUpperCase()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Customer: ${order.customerName}'),
                        const SizedBox(height: 8),
                        ...order.items.map((item) => Text('${item.name} x ${item.quantity}')),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: ['pending', 'processing', 'completed', 'cancelled']
                              .map(
                                (status) => ChoiceChip(
                                  label: Text(status),
                                  selected: order.status == status,
                                  onSelected: (_) => context.read<AppState>().updateOrderStatus(order.id, status),
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadAdminDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dashboard = state.dashboard;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
        actions: [IconButton(onPressed: () => context.read<AppState>().logout(), icon: const Icon(Icons.logout))],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AppState>().loadAdminDashboard(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Supervisor view for marketplace activity', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 16),
            if (dashboard == null)
              const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: CircularProgressIndicator()))
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(label: 'Users', value: dashboard.users.toString()),
                  _StatCard(label: 'Artisans', value: dashboard.artisans.toString()),
                  _StatCard(label: 'Customers', value: dashboard.customers.toString()),
                  _StatCard(label: 'Products', value: dashboard.products.toString()),
                  _StatCard(label: 'Orders', value: dashboard.orders.toString()),
                  _StatCard(label: 'Revenue', value: 'Rs ${dashboard.revenue.toStringAsFixed(0)}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imageUrl.isEmpty
            ? const Icon(Icons.image_outlined)
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Text(message, style: TextStyle(color: Colors.red.shade800)),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
