import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/models.dart';
import 'screens/auth/auth_screens.dart';
import 'screens/buyer/buyer_screens.dart';
import 'screens/buyer/product_screens.dart';
import 'screens/seller/seller_screens.dart';
import 'screens/shared/profile_screens.dart';

void main() {
  runApp(const ArtisansMarketplaceApp());
}

class ArtisansMarketplaceApp extends StatelessWidget {
  const ArtisansMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artisans Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/register',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // ── Auth ────────────────────────────────────────────────────────────
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
          case '/verify':
            return MaterialPageRoute(builder: (_) => const VerifyCodeScreen());

          // ── Buyer ───────────────────────────────────────────────────────────
          case '/home':
            return MaterialPageRoute(builder: (_) => const BuyerHomeScreen());
          case '/catalog':
            return MaterialPageRoute(builder: (_) => const CatalogScreen());
          case '/shops':
            return MaterialPageRoute(builder: (_) => const ShopsScreen());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutUsScreen());
          case '/view-shop':
            final shop = settings.arguments as Shop;
            return MaterialPageRoute(builder: (_) => ViewShopScreen(shop: shop));
          case '/product':
            final product = settings.arguments as Product;
            return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
          case '/checkout':
            return MaterialPageRoute(builder: (_) => const CheckoutScreen());

          // ── Seller ──────────────────────────────────────────────────────────
          case '/seller-home':
            return MaterialPageRoute(builder: (_) => const FinancesScreen());
          case '/finances':
            return MaterialPageRoute(builder: (_) => const FinancesScreen());
          case '/manage-orders':
            return MaterialPageRoute(builder: (_) => const ManageOrdersScreen());
          case '/reviews':
            return MaterialPageRoute(builder: (_) => const ReviewsScreen());
          case '/seller-product':
            final product = settings.arguments as Product;
            return MaterialPageRoute(builder: (_) => SellerProductDetailScreen(product: product));
          case '/edit-product':
            final product = settings.arguments as Product?;
            return MaterialPageRoute(builder: (_) => EditProductScreen(product: product));
          case '/sell-product':
            return MaterialPageRoute(builder: (_) => const EditProductScreen());

          // ── Profile ─────────────────────────────────────────────────────────
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/profile-account':
            return MaterialPageRoute(builder: (_) => const AccountSecurityScreen());
          case '/profile-contact':
            return MaterialPageRoute(builder: (_) => const ContactDetailsScreen());
          case '/profile-communication':
            return MaterialPageRoute(builder: (_) => const CommunicationScreen());

          default:
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
        }
      },
    );
  }
}
