// Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final List<String> categories;
  final List<String> colors;
  final List<String> sizes;
  final String shopId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.currency = 'Rs.',
    required this.rating,
    this.reviewCount = 0,
    required this.imageUrl,
    this.description = '',
    this.categories = const [],
    this.colors = const [],
    this.sizes = const [],
    this.shopId = '',
  });
}

// Shop Model
class Shop {
  final String id;
  final String name;
  final String ownerName;
  final String bio;
  final String imageUrl;
  final String ownerImageUrl;
  final List<Product> products;

  Shop({
    required this.id,
    required this.name,
    required this.ownerName,
    this.bio = '',
    required this.imageUrl,
    this.ownerImageUrl = '',
    this.products = const [],
  });
}

// Cart Item Model
class CartItem {
  final Product product;
  int quantity;
  String? selectedColor;
  String? selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  double get total => product.price * quantity;
}

// Review Model
class Review {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String title;
  final String comment;
  final DateTime date;
  String? reply;

  Review({
    required this.id,
    required this.userName,
    this.userImage = '',
    required this.rating,
    required this.title,
    required this.comment,
    required this.date,
    this.reply,
  });
}

// Order Model
class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final String status;
  final String deliveryStatus;
  final double progress;
  final String customerImage;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
    this.deliveryStatus = '',
    this.progress = 0,
    this.customerImage = '',
  });
}

// User Model
class UserModel {
  final String name;
  final String email;
  final String role;
  final String badge;
  final String bio;
  final String portfolioUrl;
  final String phoneNumber;
  final String address;
  final String city;
  final String postalCode;

  UserModel({
    required this.name,
    required this.email,
    this.role = 'Master Potter',
    this.badge = 'Premium Seller',
    this.bio = '',
    this.portfolioUrl = '',
    this.phoneNumber = '',
    this.address = '',
    this.city = '',
    this.postalCode = '',
  });
}

// Sample Data
class SampleData {
  static final List<Product> products = [
    Product(
      id: '1',
      name: 'Crochet Cactus',
      price: 1500,
      rating: 4.0,
      reviewCount: 12,
      imageUrl: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=400',
      description: 'Beautiful handmade crochet cactus.',
      categories: ['Crochet/Knit'],
      shopId: 'shop1',
    ),
    Product(
      id: '2',
      name: 'Flower Clips',
      price: 690,
      rating: 4.0,
      reviewCount: 8,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      description: 'Handmade crochet flower clips.',
      categories: ['Crochet/Knit'],
      shopId: 'shop1',
    ),
    Product(
      id: '3',
      name: 'Gift Basket',
      price: 4000,
      rating: 5.0,
      reviewCount: 20,
      imageUrl: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400',
      description: 'Handcrafted gift basket.',
      categories: ['Gift Items'],
      shopId: 'shop2',
    ),
    Product(
      id: '4',
      name: 'Clay Plate',
      price: 3000,
      rating: 4.5,
      reviewCount: 15,
      imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=400',
      description: 'Hand-painted blue clay plate.',
      categories: ['Clay Items'],
      shopId: 'shop3',
    ),
    Product(
      id: '5',
      name: 'Clay Pot',
      price: 5000,
      rating: 5.0,
      reviewCount: 25,
      imageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
      description: 'Traditional hand-thrown clay pot.',
      categories: ['Clay Items'],
      shopId: 'shop3',
    ),
    Product(
      id: '6',
      name: 'Red Persian Rug',
      price: 35000,
      rating: 4.7,
      reviewCount: 26,
      imageUrl: 'https://images.unsplash.com/photo-1600166898405-da9535204843?w=400',
      description:
          'The collection features iconic motifs like Omar Khayyam, Hunting scenes, Poetic themes, intricate floral designs, and exquisite Mughal art, all in vibrant gaudy and warm earthy colors.',
      categories: ['Rugs', 'Hand Sewn', 'Woolen Goods', 'Luxury'],
      colors: ['brown', 'red', 'cream'],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      shopId: 'shop4',
    ),
    Product(
      id: '7',
      name: 'Handmade Rug',
      price: 7000,
      rating: 4.5,
      reviewCount: 18,
      imageUrl: 'https://images.unsplash.com/photo-1600166898405-da9535204843?w=400',
      description: 'Beautiful handmade floral rug.',
      categories: ['Rugs'],
      shopId: 'shop4',
    ),
    Product(
      id: '8',
      name: 'Clay Pots',
      price: 499,
      currency: '\$',
      rating: 4.5,
      reviewCount: 30,
      imageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
      description: 'Set of traditional clay pots.',
      categories: ['Clay Items'],
      shopId: 'shop3',
    ),
  ];

  static final List<Shop> shops = [
    Shop(
      id: 'shop1',
      name: 'Crochet Haven',
      ownerName: 'Sarah',
      bio: 'Handcrafted crochet items made with love.',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      ownerImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
    ),
    Shop(
      id: 'shop2',
      name: 'Gifts and More',
      ownerName: 'Maria',
      bio: 'Unique handcrafted gifts for every occasion.',
      imageUrl: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400',
      ownerImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    ),
    Shop(
      id: 'shop3',
      name: 'Clayr',
      ownerName: 'Hassan',
      bio:
          'Meet Hassan, the creative force behind Clayr. What started as a childhood hobby in a small home studio has blossomed into a lifelong obsession with clay.\n\nEvery piece in the Clayr collection is a labor of love, often taking days or even weeks to transition from a raw idea to a finished masterpiece. Hassan focuses on tactile textures and timeless designs that are built to be used and cherished for generations.',
      imageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
      ownerImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    ),
    Shop(
      id: 'shop4',
      name: 'Yarn and More',
      ownerName: 'Fatima',
      bio: 'Premium handwoven rugs and yarn products.',
      imageUrl: 'https://images.unsplash.com/photo-1600166898405-da9535204843?w=400',
      ownerImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    ),
  ];

  static final List<Review> reviews = [
    Review(
      id: 'r1',
      userName: 'Emma',
      rating: 5.0,
      title: 'Great',
      comment: 'Amazing Work of art.',
      date: DateTime(2023, 8, 26),
    ),
    Review(
      id: 'r2',
      userName: 'John',
      rating: 4.0,
      title: 'Excellent',
      comment: 'Incredible !!',
      date: DateTime(2023, 8, 26),
    ),
    Review(
      id: 'r3',
      userName: 'Anna',
      rating: 4.0,
      title: 'Great Quality',
      comment: 'This Rug is a Gem, am passing it as my family heirloom',
      date: DateTime(2023, 8, 26),
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: '1',
      date: DateTime(2022, 8, 5),
      items: [],
      status: 'Finished',
      deliveryStatus: 'Delivery In Progress',
      progress: 0.72,
      customerImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
    ),
    Order(
      id: '2',
      date: DateTime(2022, 9, 3),
      items: [],
      status: 'Finished',
      deliveryStatus: '',
      progress: 0.45,
      customerImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    ),
    Order(
      id: '3',
      date: DateTime(2022, 8, 3),
      items: [],
      status: 'Finished',
      deliveryStatus: 'Delivered',
      progress: 1.0,
      customerImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    ),
  ];

  static final UserModel currentUser = UserModel(
    name: 'Julian Rivers',
    email: 'julian.artisan@studio.com',
    role: 'Master Potter',
    badge: 'Premium Seller',
    bio: 'Dedicated to hand-thrown pottery. Bridging functional tableware with organic sculptural art for modern living spaces.',
    portfolioUrl: 'artisan.io/julian_rivers',
    phoneNumber: '+1 (555) 012-3456',
    address: '42 Artisan Way, Studio B',
    city: 'Asheville',
    postalCode: '28801',
  );

  static const List<String> categories = [
    'Rugs',
    'Clay Items',
    'Crochet/Knit',
    'Gift Items',
  ];

  static const List<Map<String, String>> cartItems = [
    {'name': 'Red Persian Rug', 'price': '70,000', 'qty': '2'},
    {'name': 'Crockery Set', 'price': '10,000', 'qty': '1'},
    {'name': 'Coffee Mug', 'price': '1,000', 'qty': '1'},
    {'name': 'Clay Plate', 'price': '2,000', 'qty': '1'},
  ];
}
