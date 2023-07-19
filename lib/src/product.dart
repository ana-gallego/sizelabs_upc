import 'dart:convert';

class Product {
  String code;
  String title;
  String category;
  String brand;
  List<String> images;
  List<Store> stores;

  Product({
    required this.code,
    required this.title,
    required this.category,
    required this.brand,
    required this.images,
    required this.stores,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        code: json["barcode_number"],
        title: json["title"],
        category: json["category"],
        brand: json["brand"],
        images: List<String>.from(json["images"].map((x) => x)),
        stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "barcode_number": code,
        "title": title,
        "category": category,
        "brand": brand,
        "images": List<dynamic>.from(images.map((x) => x)),
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };
}

class Store {
  String name;
  String country;
  String currency;
  String? currencySymbol;
  String price;
  String salePrice;
  List<dynamic> tax;
  String link;
  String itemGroupId;
  String availability;
  String condition;
  List<dynamic> shipping;
  DateTime lastUpdate;

  Store({
    required this.name,
    required this.country,
    required this.currency,
    this.currencySymbol,
    required this.price,
    required this.salePrice,
    required this.tax,
    required this.link,
    required this.itemGroupId,
    required this.availability,
    required this.condition,
    required this.shipping,
    required this.lastUpdate,
  });

  factory Store.fromRawJson(String str) => Store.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json["name"],
        country: json["country"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        price: json["price"],
        salePrice: json["sale_price"],
        tax: List<dynamic>.from(json["tax"].map((x) => x)),
        link: json["link"],
        itemGroupId: json["item_group_id"],
        availability: json["availability"],
        condition: json["condition"],
        shipping: List<dynamic>.from(json["shipping"].map((x) => x)),
        lastUpdate: DateTime.parse(json["last_update"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "country": country,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "price": price,
        "sale_price": salePrice,
        "tax": List<dynamic>.from(tax.map((x) => x)),
        "link": link,
        "item_group_id": itemGroupId,
        "availability": availability,
        "condition": condition,
        "shipping": List<dynamic>.from(shipping.map((x) => x)),
        "last_update": lastUpdate.toIso8601String(),
      };
}
