// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int? totlaPopularProducts;
  bool? status;




  String? message;
  Data? data;

  HomeModel({
    this.totlaPopularProducts,
    this.status,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    totlaPopularProducts: json["totla_popular_products"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "totla_popular_products": totlaPopularProducts,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  SliderClass? slider;
  DataCategory? category;
  List<PopularProduct>? popularProducts;
  List<Slider>? hSlider;
  List<Slider>? vSlider;
  BestSellerDataClass? yallaData;
  BestSellerDataClass? bestSellerData;
  BestSellerDataClass? deliciousData;
  BestSellerDataClass? shortcutsData;
  CategoryProducts? categoryProducts;
  List<OffersGallery>? offersGallery;
  List<TimeBannerAd>? timeBannerAd;
  List<BestSeller>? bestSeller;
  List<FreeDelivery>? freeDeliverys;
  List<ServiceSection>? serviceSection;
  List<dynamic>? shortcutBanner;
  List<Copon>? copons;

  Data({
    this.slider,
    this.category,
    this.popularProducts,
    this.hSlider,
    this.vSlider,
    this.yallaData,
    this.bestSellerData,
    this.deliciousData,
    this.shortcutsData,
    this.categoryProducts,
    this.offersGallery,
    this.timeBannerAd,
    this.bestSeller,
    this.freeDeliverys,
    this.serviceSection,
    this.shortcutBanner,
    this.copons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    slider: json["slider"] == null ? null : SliderClass.fromJson(json["slider"]),
    category: json["category"] == null ? null : DataCategory.fromJson(json["category"]),
    popularProducts: json["popular_products"] == null ? [] : List<PopularProduct>.from(json["popular_products"]!.map((x) => PopularProduct.fromJson(x))),
    hSlider: json["h_slider"] == null ? [] : List<Slider>.from(json["h_slider"]!.map((x) => Slider.fromJson(x))),
    vSlider: json["v_slider"] == null ? [] : List<Slider>.from(json["v_slider"]!.map((x) => Slider.fromJson(x))),
    yallaData: json["yalla_data"] == null ? null : BestSellerDataClass.fromJson(json["yalla_data"]),
    bestSellerData: json["best_seller_data"] == null ? null : BestSellerDataClass.fromJson(json["best_seller_data"]),
    deliciousData: json["delicious_data"] == null ? null : BestSellerDataClass.fromJson(json["delicious_data"]),
    shortcutsData: json["shortcuts_data"] == null ? null : BestSellerDataClass.fromJson(json["shortcuts_data"]),
    categoryProducts: json["category_products"] == null ? null : CategoryProducts.fromJson(json["category_products"]),
    offersGallery: json["offers_gallery"] == null ? [] : List<OffersGallery>.from(json["offers_gallery"]!.map((x) => OffersGallery.fromJson(x))),
    timeBannerAd: json["time_banner_ad"] == null ? [] : List<TimeBannerAd>.from(json["time_banner_ad"]!.map((x) => TimeBannerAd.fromJson(x))),
    bestSeller: json["best_seller"] == null ? [] : List<BestSeller>.from(json["best_seller"]!.map((x) => BestSeller.fromJson(x))),
    freeDeliverys: json["free_deliverys"] == null ? [] : List<FreeDelivery>.from(json["free_deliverys"]!.map((x) => FreeDelivery.fromJson(x))),
    serviceSection: json["service_section"] == null ? [] : List<ServiceSection>.from(json["service_section"]!.map((x) => ServiceSection.fromJson(x))),
    shortcutBanner: json["shortcut_banner"] == null ? [] : List<dynamic>.from(json["shortcut_banner"]!.map((x) => x)),
    copons: json["copons"] == null ? [] : List<Copon>.from(json["copons"]!.map((x) => Copon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slider": slider?.toJson(),
    "category": category?.toJson(),
    "popular_products": popularProducts == null ? [] : List<dynamic>.from(popularProducts!.map((x) => x.toJson())),
    "h_slider": hSlider == null ? [] : List<dynamic>.from(hSlider!.map((x) => x.toJson())),
    "v_slider": vSlider == null ? [] : List<dynamic>.from(vSlider!.map((x) => x.toJson())),
    "yalla_data": yallaData?.toJson(),
    "best_seller_data": bestSellerData?.toJson(),
    "delicious_data": deliciousData?.toJson(),
    "shortcuts_data": shortcutsData?.toJson(),
    "category_products": categoryProducts?.toJson(),
    "offers_gallery": offersGallery == null ? [] : List<dynamic>.from(offersGallery!.map((x) => x.toJson())),
    "time_banner_ad": timeBannerAd == null ? [] : List<dynamic>.from(timeBannerAd!.map((x) => x.toJson())),
    "best_seller": bestSeller == null ? [] : List<dynamic>.from(bestSeller!.map((x) => x.toJson())),
    "free_deliverys": freeDeliverys == null ? [] : List<dynamic>.from(freeDeliverys!.map((x) => x.toJson())),
    "service_section": serviceSection == null ? [] : List<dynamic>.from(serviceSection!.map((x) => x.toJson())),
    "shortcut_banner": shortcutBanner == null ? [] : List<dynamic>.from(shortcutBanner!.map((x) => x)),
    "copons": copons == null ? [] : List<dynamic>.from(copons!.map((x) => x.toJson())),
  };
}

class BestSeller {
  String? bestsellerSliderUrl;

  BestSeller({
    this.bestsellerSliderUrl,
  });

  factory BestSeller.fromJson(Map<String, dynamic> json) => BestSeller(
    bestsellerSliderUrl: json["bestseller_slider_url"],
  );

  Map<String, dynamic> toJson() => {
    "bestseller_slider_url": bestsellerSliderUrl,
  };
}

class BestSellerDataClass {
  String? icon;
  String? title;

  BestSellerDataClass({
    this.icon,
    this.title,
  });

  factory BestSellerDataClass.fromJson(Map<String, dynamic> json) => BestSellerDataClass(
    icon: json["icon"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "title": title,
  };
}

class DataCategory {
  bool? enabled;
  String? showCategory;
  List<CategoryElement>? categories;

  DataCategory({
    this.enabled,
    this.showCategory,
    this.categories,
  });

  factory DataCategory.fromJson(Map<String, dynamic> json) => DataCategory(
    enabled: json["enabled"],
    showCategory: json["show_category"],
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "show_category": showCategory,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class CategoryElement {
  int? termId;
  String? name;
  String? slug;

  CategoryElement({
    this.termId,
    this.name,
    this.slug,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    termId: json["term_id"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "term_id": termId,
    "name": name,
    "slug": slug,
  };
}

class CategoryProducts {
  String? categoryName;
  String? categoryId;
  List<Product>? products;

  CategoryProducts({
    this.categoryName,
    this.categoryId,
    this.products,
  });

  factory CategoryProducts.fromJson(Map<String, dynamic> json) => CategoryProducts(
    categoryName: json["category_name"],
    categoryId: json["category_id"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category_name": categoryName,
    "category_id": categoryId,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  String? name;
  String? slug;
  String? permalink;
  String? dateCreated;
  String? type;
  String? description;
  String? shortDescription;
  String? price;
  String? intPrice;
  String? regularPrice;
  String? salePrice;
  String? currencySymbol;
  String? storeId;
  String? storeName;
  String? averageRating;
  int? ratingCount;
  bool? manageStock;
  String? stockStatus;
  String? stockQuantity;
  String? lowStockAmount;
  bool? isInWishlist;
  bool? onSale;
  bool? purchasable;
  bool? featured;
  bool? virtual;
  bool? downloadable;
  int? categoryId;
  String? categoryName;
  String? categorySlug;
  String? imageUrl;
  int? created;
  DateTime? createdFormated;
  List<dynamic>? attributeData;
  List<ProductAddonsDatum>? addonsData;

  Product({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.dateCreated,
    this.type,
    this.description,
    this.shortDescription,
    this.price,
    this.intPrice,
    this.regularPrice,
    this.salePrice,
    this.currencySymbol,
    this.storeId,
    this.storeName,
    this.averageRating,
    this.ratingCount,
    this.manageStock,
    this.stockStatus,
    this.stockQuantity,
    this.lowStockAmount,
    this.isInWishlist,
    this.onSale,
    this.purchasable,
    this.featured,
    this.virtual,
    this.downloadable,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.imageUrl,
    this.created,
    this.createdFormated,
    this.attributeData,
    this.addonsData,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    permalink: json["permalink"],
    dateCreated: json["date_created"],
    type: json["type"],
    description: json["description"],
    shortDescription: json["short_description"],
    price: json["price"],
    intPrice: json["int_price"],
    regularPrice: json["regular_price"],
    salePrice: json["sale_price"],
    currencySymbol: json["currency_symbol"],
    storeId: json["store_id"],
    storeName: json["store_name"],
    averageRating: json["average_rating"],
    ratingCount: json["rating_count"],
    manageStock: json["manage_stock"],
    stockStatus: json["stock_status"],
    stockQuantity: json["stock_quantity"],
    lowStockAmount: json["low_stock_amount"],
    isInWishlist: json["is_in_wishlist"],
    onSale: json["on_sale"],
    purchasable: json["purchasable"],
    featured: json["featured"],
    virtual: json["virtual"],
    downloadable: json["downloadable"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    categorySlug: json["category_slug"],
    imageUrl: json["image_url"],
    created: json["created"],
    createdFormated: json["created_formated"] == null ? null : DateTime.parse(json["created_formated"]),
    attributeData: json["attribute_data"] == null ? [] : List<dynamic>.from(json["attribute_data"]!.map((x) => x)),
    addonsData: json["addons_data"] == null ? [] : List<ProductAddonsDatum>.from(json["addons_data"]!.map((x) => ProductAddonsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "permalink": permalink,
    "date_created": dateCreated,
    "type": type,
    "description": description,
    "short_description": shortDescription,
    "price": price,
    "int_price": intPrice,
    "regular_price": regularPrice,
    "sale_price": salePrice,
    "currency_symbol": currencySymbol,
    "store_id": storeId,
    "store_name": storeName,
    "average_rating": averageRating,
    "rating_count": ratingCount,
    "manage_stock": manageStock,
    "stock_status": stockStatus,
    "stock_quantity": stockQuantity,
    "low_stock_amount": lowStockAmount,
    "is_in_wishlist": isInWishlist,
    "on_sale": onSale,
    "purchasable": purchasable,
    "featured": featured,
    "virtual": virtual,
    "downloadable": downloadable,
    "category_id": categoryId,
    "category_name": categoryName,
    "category_slug": categorySlug,
    "image_url": imageUrl,
    "created": created,
    "created_formated": "${createdFormated!.year.toString().padLeft(4, '0')}-${createdFormated!.month.toString().padLeft(2, '0')}-${createdFormated!.day.toString().padLeft(2, '0')}",
    "attribute_data": attributeData == null ? [] : List<dynamic>.from(attributeData!.map((x) => x)),
    "addons_data": addonsData == null ? [] : List<dynamic>.from(addonsData!.map((x) => x.toJson())),
  };
}

class ProductAddonsDatum {
  List<String>? uniId;
  String? title;
  String? headerSubtitle;
  Map<String, String>? checkboxesRequired;
  Map<String, String>? checkboxesHeaderSubtitle;
  Map<String, List<String>>? optionsTitle;
  Map<String, List<String>>? optionsImage;
  Map<String, List<String>>? optionsPrice;
  Map<String, List<String>>? salePrice;
  Map<String, String>? radiobuttonsRequired;
  Map<String, String>? radioOptionsDefaultValue;
  Map<String, String>? radiobuttonsHeaderTitle;
  Map<String, String>? radiobuttonsHeaderSubtitle;
  Map<String, List<String>>? multipleRadiobuttonsOptionsTitle;
  Map<String, List<String>>? radiobuttonsOptionsImage;
  Map<String, List<String>>? radiobuttonsOptionsValue;
  Map<String, List<String>>? radiobuttonsOptionsPrice;
  Map<String, List<String>>? radiobuttonsSalePrice;

  ProductAddonsDatum({
    this.uniId,
    this.title,
    this.headerSubtitle,
    this.checkboxesRequired,
    this.checkboxesHeaderSubtitle,
    this.optionsTitle,
    this.optionsImage,
    this.optionsPrice,
    this.salePrice,
    this.radiobuttonsRequired,
    this.radioOptionsDefaultValue,
    this.radiobuttonsHeaderTitle,
    this.radiobuttonsHeaderSubtitle,
    this.multipleRadiobuttonsOptionsTitle,
    this.radiobuttonsOptionsImage,
    this.radiobuttonsOptionsValue,
    this.radiobuttonsOptionsPrice,
    this.radiobuttonsSalePrice,
  });

  factory ProductAddonsDatum.fromJson(Map<String, dynamic> json) => ProductAddonsDatum(
    uniId: json["uni_id"] == null ? [] : List<String>.from(json["uni_id"]!.map((x) => x)),
    title: json["title"],
    headerSubtitle: json["header_subtitle"],
    checkboxesRequired: Map.from(json["checkboxes_required"]!).map((k, v) => MapEntry<String, String>(k, v)),
    checkboxesHeaderSubtitle: Map.from(json["checkboxes_header_subtitle"]!).map((k, v) => MapEntry<String, String>(k, v)),
    optionsTitle: Map.from(json["options_title"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    optionsImage: Map.from(json["options_image"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    optionsPrice: Map.from(json["options_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    salePrice: Map.from(json["sale_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsRequired: Map.from(json["radiobuttons_required"]!).map((k, v) => MapEntry<String, String>(k, v)),
    radioOptionsDefaultValue: Map.from(json["radio_options_default_value"]!).map((k, v) => MapEntry<String, String>(k, v)),
    radiobuttonsHeaderTitle: Map.from(json["radiobuttons_header_title"]!).map((k, v) => MapEntry<String, String>(k, v)),
    radiobuttonsHeaderSubtitle: Map.from(json["radiobuttons_header_subtitle"]!).map((k, v) => MapEntry<String, String>(k, v)),
    multipleRadiobuttonsOptionsTitle: Map.from(json["multiple_radiobuttons_options_title"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsOptionsImage: Map.from(json["radiobuttons_options_image"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsOptionsValue: Map.from(json["radiobuttons_options_value"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsOptionsPrice: Map.from(json["radiobuttons_options_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsSalePrice: Map.from(json["radiobuttons_sale_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "uni_id": uniId == null ? [] : List<dynamic>.from(uniId!.map((x) => x)),
    "title": title,
    "header_subtitle": headerSubtitle,
    "checkboxes_required": Map.from(checkboxesRequired!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "checkboxes_header_subtitle": Map.from(checkboxesHeaderSubtitle!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "options_title": Map.from(optionsTitle!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "options_image": Map.from(optionsImage!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "options_price": Map.from(optionsPrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "sale_price": Map.from(salePrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_required": Map.from(radiobuttonsRequired!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "radio_options_default_value": Map.from(radioOptionsDefaultValue!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "radiobuttons_header_title": Map.from(radiobuttonsHeaderTitle!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "radiobuttons_header_subtitle": Map.from(radiobuttonsHeaderSubtitle!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "multiple_radiobuttons_options_title": Map.from(multipleRadiobuttonsOptionsTitle!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_options_image": Map.from(radiobuttonsOptionsImage!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_options_value": Map.from(radiobuttonsOptionsValue!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_options_price": Map.from(radiobuttonsOptionsPrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_sale_price": Map.from(radiobuttonsSalePrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
  };
}

class Copon {
  int? id;
  String? postAuthor;
  DateTime? postDate;
  DateTime? postDateGmt;
  String? postContent;
  String? postTitle;
  String? postExcerpt;
  String? postStatus;
  String? commentStatus;
  String? pingStatus;
  String? postPassword;
  String? postName;
  String? toPing;
  String? pinged;
  DateTime? postModified;
  DateTime? postModifiedGmt;
  String? postContentFiltered;
  int? postParent;
  String? guid;
  int? menuOrder;
  String? postType;
  String? postMimeType;
  String? commentCount;
  String? filter;

  Copon({
    this.id,
    this.postAuthor,
    this.postDate,
    this.postDateGmt,
    this.postContent,
    this.postTitle,
    this.postExcerpt,
    this.postStatus,
    this.commentStatus,
    this.pingStatus,
    this.postPassword,
    this.postName,
    this.toPing,
    this.pinged,
    this.postModified,
    this.postModifiedGmt,
    this.postContentFiltered,
    this.postParent,
    this.guid,
    this.menuOrder,
    this.postType,
    this.postMimeType,
    this.commentCount,
    this.filter,
  });

  factory Copon.fromJson(Map<String, dynamic> json) => Copon(
    id: json["ID"],
    postAuthor: json["post_author"],
    postDate: json["post_date"] == null ? null : DateTime.parse(json["post_date"]),
    postDateGmt: json["post_date_gmt"] == null ? null : DateTime.parse(json["post_date_gmt"]),
    postContent: json["post_content"],
    postTitle: json["post_title"],
    postExcerpt: json["post_excerpt"],
    postStatus: json["post_status"],
    commentStatus: json["comment_status"],
    pingStatus: json["ping_status"],
    postPassword: json["post_password"],
    postName: json["post_name"],
    toPing: json["to_ping"],
    pinged: json["pinged"],
    postModified: json["post_modified"] == null ? null : DateTime.parse(json["post_modified"]),
    postModifiedGmt: json["post_modified_gmt"] == null ? null : DateTime.parse(json["post_modified_gmt"]),
    postContentFiltered: json["post_content_filtered"],
    postParent: json["post_parent"],
    guid: json["guid"],
    menuOrder: json["menu_order"],
    postType: json["post_type"],
    postMimeType: json["post_mime_type"],
    commentCount: json["comment_count"],
    filter: json["filter"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "post_author": postAuthor,
    "post_date": postDate?.toIso8601String(),
    "post_date_gmt": postDateGmt?.toIso8601String(),
    "post_content": postContent,
    "post_title": postTitle,
    "post_excerpt": postExcerpt,
    "post_status": postStatus,
    "comment_status": commentStatus,
    "ping_status": pingStatus,
    "post_password": postPassword,
    "post_name": postName,
    "to_ping": toPing,
    "pinged": pinged,
    "post_modified": postModified?.toIso8601String(),
    "post_modified_gmt": postModifiedGmt?.toIso8601String(),
    "post_content_filtered": postContentFiltered,
    "post_parent": postParent,
    "guid": guid,
    "menu_order": menuOrder,
    "post_type": postType,
    "post_mime_type": postMimeType,
    "comment_count": commentCount,
    "filter": filter,
  };
}

class FreeDelivery {
  String? freeDeliverys;
  String? freeDeliveryTitle;
  String? freeDeliveryContent;

  FreeDelivery({
    this.freeDeliverys,
    this.freeDeliveryTitle,
    this.freeDeliveryContent,
  });

  factory FreeDelivery.fromJson(Map<String, dynamic> json) => FreeDelivery(
    freeDeliverys: json["free_deliverys"],
    freeDeliveryTitle: json["free_delivery_title"],
    freeDeliveryContent: json["free_delivery_content"],
  );

  Map<String, dynamic> toJson() => {
    "free_deliverys": freeDeliverys,
    "free_delivery_title": freeDeliveryTitle,
    "free_delivery_content": freeDeliveryContent,
  };
}

class Slider {
  String? image;
  String? priority;
  int? productId;
  String? productLink;

  Slider({
    this.image,
    this.priority,
    this.productId,
    this.productLink,
  });

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    image: json["image"],
    priority: json["priority"],
    productId: json["product_id"],
    productLink: json["product_link"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "priority": priority,
    "product_id": productId,
    "product_link": productLink,
  };
}

class OffersGallery {
  String? sliderUrl;

  OffersGallery({
    this.sliderUrl,
  });

  factory OffersGallery.fromJson(Map<String, dynamic> json) => OffersGallery(
    sliderUrl: json["slider_url"],
  );

  Map<String, dynamic> toJson() => {
    "slider_url": sliderUrl,
  };
}

class PopularProduct {
  int? id;
  String? name;
  String? slug;
  String? permalink;
  String? dateCreated;
  String? type;
  String? description;
  String? shortDescription;
  String? price;
  String? intPrice;
  String? regularPrice;
  String? salePrice;
  String? currencySymbol;
  String? storeId;
  String? storeName;
  String? averageRating;
  int? ratingCount;
  bool? manageStock;
  String? stockStatus;
  String? stockQuantity;
  String? lowStockAmount;
  bool? isInWishlist;
  bool? onSale;
  bool? purchasable;
  bool? featured;
  bool? virtual;
  bool? downloadable;
  int? categoryId;
  String? categoryName;
  String? categorySlug;
  String? imageUrl;
  int? created;
  DateTime? createdFormated;
  List<dynamic>? attributeData;
  List<PopularProductAddonsDatum>? addonsData;

  PopularProduct({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.dateCreated,
    this.type,
    this.description,
    this.shortDescription,
    this.price,
    this.intPrice,
    this.regularPrice,
    this.salePrice,
    this.currencySymbol,
    this.storeId,
    this.storeName,
    this.averageRating,
    this.ratingCount,
    this.manageStock,
    this.stockStatus,
    this.stockQuantity,
    this.lowStockAmount,
    this.isInWishlist,
    this.onSale,
    this.purchasable,
    this.featured,
    this.virtual,
    this.downloadable,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.imageUrl,
    this.created,
    this.createdFormated,
    this.attributeData,
    this.addonsData,
  });

  factory PopularProduct.fromJson(Map<String, dynamic> json) => PopularProduct(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    permalink: json["permalink"],
    dateCreated: json["date_created"],
    type: json["type"],
    description: json["description"],
    shortDescription: json["short_description"],
    price: json["price"],
    intPrice: json["int_price"],
    regularPrice: json["regular_price"],
    salePrice: json["sale_price"],
    currencySymbol: json["currency_symbol"],
    storeId: json["store_id"],
    storeName: json["store_name"],
    averageRating: json["average_rating"],
    ratingCount: json["rating_count"],
    manageStock: json["manage_stock"],
    stockStatus: json["stock_status"],
    stockQuantity: json["stock_quantity"],
    lowStockAmount: json["low_stock_amount"],
    isInWishlist: json["is_in_wishlist"],
    onSale: json["on_sale"],
    purchasable: json["purchasable"],
    featured: json["featured"],
    virtual: json["virtual"],
    downloadable: json["downloadable"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    categorySlug: json["category_slug"],
    imageUrl: json["image_url"],
    created: json["created"],
    createdFormated: json["created_formated"] == null ? null : DateTime.parse(json["created_formated"]),
    attributeData: json["attribute_data"] == null ? [] : List<dynamic>.from(json["attribute_data"]!.map((x) => x)),
    addonsData: json["addons_data"] == null ? [] : List<PopularProductAddonsDatum>.from(json["addons_data"]!.map((x) => PopularProductAddonsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "permalink": permalink,
    "date_created": dateCreated,
    "type": type,
    "description": description,
    "short_description": shortDescription,
    "price": price,
    "int_price": intPrice,
    "regular_price": regularPrice,
    "sale_price": salePrice,
    "currency_symbol": currencySymbol,
    "store_id": storeId,
    "store_name": storeName,
    "average_rating": averageRating,
    "rating_count": ratingCount,
    "manage_stock": manageStock,
    "stock_status": stockStatus,
    "stock_quantity": stockQuantity,
    "low_stock_amount": lowStockAmount,
    "is_in_wishlist": isInWishlist,
    "on_sale": onSale,
    "purchasable": purchasable,
    "featured": featured,
    "virtual": virtual,
    "downloadable": downloadable,
    "category_id": categoryId,
    "category_name": categoryName,
    "category_slug": categorySlug,
    "image_url": imageUrl,
    "created": created,
    "created_formated": "${createdFormated!.year.toString().padLeft(4, '0')}-${createdFormated!.month.toString().padLeft(2, '0')}-${createdFormated!.day.toString().padLeft(2, '0')}",
    "attribute_data": attributeData == null ? [] : List<dynamic>.from(attributeData!.map((x) => x)),
    "addons_data": addonsData == null ? [] : List<dynamic>.from(addonsData!.map((x) => x.toJson())),
  };
}

class PopularProductAddonsDatum {
  List<String>? uniId;
  String? title;
  String? headerSubtitle;
  Map<String, String>? checkboxesRequired;
  Map<String, String>? checkboxesHeaderSubtitle;
  Map<String, List<String>>? optionsTitle;
  Map<String, List<String>>? optionsImage;
  Map<String, List<String>>? optionsPrice;
  Map<String, List<String>>? salePrice;
  dynamic radiobuttonsRequired;
  dynamic radioOptionsDefaultValue;
  dynamic radiobuttonsHeaderTitle;
  dynamic radiobuttonsHeaderSubtitle;
  dynamic multipleRadiobuttonsOptionsTitle;
  dynamic radiobuttonsOptionsImage;
  dynamic radiobuttonsOptionsValue;
  dynamic radiobuttonsOptionsPrice;
  dynamic radiobuttonsSalePrice;

  PopularProductAddonsDatum({
    this.uniId,
    this.title,
    this.headerSubtitle,
    this.checkboxesRequired,
    this.checkboxesHeaderSubtitle,
    this.optionsTitle,
    this.optionsImage,
    this.optionsPrice,
    this.salePrice,
    this.radiobuttonsRequired,
    this.radioOptionsDefaultValue,
    this.radiobuttonsHeaderTitle,
    this.radiobuttonsHeaderSubtitle,
    this.multipleRadiobuttonsOptionsTitle,
    this.radiobuttonsOptionsImage,
    this.radiobuttonsOptionsValue,
    this.radiobuttonsOptionsPrice,
    this.radiobuttonsSalePrice,
  });

  factory PopularProductAddonsDatum.fromJson(Map<String, dynamic> json) => PopularProductAddonsDatum(
    uniId: json["uni_id"] == null ? [] : List<String>.from(json["uni_id"]!.map((x) => x)),
    title: json["title"],
    headerSubtitle: json["header_subtitle"],
    checkboxesRequired: Map.from(json["checkboxes_required"]!).map((k, v) => MapEntry<String, String>(k, v)),
    checkboxesHeaderSubtitle: Map.from(json["checkboxes_header_subtitle"]!).map((k, v) => MapEntry<String, String>(k, v)),
    optionsTitle: Map.from(json["options_title"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    optionsImage: Map.from(json["options_image"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    optionsPrice: Map.from(json["options_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    salePrice: Map.from(json["sale_price"]!).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    radiobuttonsRequired: json["radiobuttons_required"],
    radioOptionsDefaultValue: json["radio_options_default_value"],
    radiobuttonsHeaderTitle: json["radiobuttons_header_title"],
    radiobuttonsHeaderSubtitle: json["radiobuttons_header_subtitle"],
    multipleRadiobuttonsOptionsTitle: json["multiple_radiobuttons_options_title"],
    radiobuttonsOptionsImage: json["radiobuttons_options_image"],
    radiobuttonsOptionsValue: json["radiobuttons_options_value"],
    radiobuttonsOptionsPrice: json["radiobuttons_options_price"],
    radiobuttonsSalePrice: json["radiobuttons_sale_price"],
  );

  Map<String, dynamic> toJson() => {
    "uni_id": uniId == null ? [] : List<dynamic>.from(uniId!.map((x) => x)),
    "title": title,
    "header_subtitle": headerSubtitle,
    "checkboxes_required": Map.from(checkboxesRequired!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "checkboxes_header_subtitle": Map.from(checkboxesHeaderSubtitle!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "options_title": Map.from(optionsTitle!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "options_image": Map.from(optionsImage!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "options_price": Map.from(optionsPrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "sale_price": Map.from(salePrice!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "radiobuttons_required": radiobuttonsRequired,
    "radio_options_default_value": radioOptionsDefaultValue,
    "radiobuttons_header_title": radiobuttonsHeaderTitle,
    "radiobuttons_header_subtitle": radiobuttonsHeaderSubtitle,
    "multiple_radiobuttons_options_title": multipleRadiobuttonsOptionsTitle,
    "radiobuttons_options_image": radiobuttonsOptionsImage,
    "radiobuttons_options_value": radiobuttonsOptionsValue,
    "radiobuttons_options_price": radiobuttonsOptionsPrice,
    "radiobuttons_sale_price": radiobuttonsSalePrice,
  };
}

class MultipleRadiobuttonsOptionsTitleClass {
  List<String>? the0;

  MultipleRadiobuttonsOptionsTitleClass({
    this.the0,
  });

  factory MultipleRadiobuttonsOptionsTitleClass.fromJson(Map<String, dynamic> json) => MultipleRadiobuttonsOptionsTitleClass(
    the0: json["0"] == null ? [] : List<String>.from(json["0"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "0": the0 == null ? [] : List<dynamic>.from(the0!.map((x) => x)),
  };
}

class RadioOptionsDefaultValueClass {
  String? the0;

  RadioOptionsDefaultValueClass({
    this.the0,
  });

  factory RadioOptionsDefaultValueClass.fromJson(Map<String, dynamic> json) => RadioOptionsDefaultValueClass(
    the0: json["0"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
  };
}

class ServiceSection {
  String? serviceTitle;
  String? serviceImages;
  String? serviceUrl;

  ServiceSection({
    this.serviceTitle,
    this.serviceImages,
    this.serviceUrl,
  });

  factory ServiceSection.fromJson(Map<String, dynamic> json) => ServiceSection(
    serviceTitle: json["service_title"],
    serviceImages: json["service_images"],
    serviceUrl: json["service_url"],
  );

  Map<String, dynamic> toJson() => {
    "service_title": serviceTitle,
    "service_images": serviceImages,
    "service_url": serviceUrl,
  };
}

class SliderClass {
  bool? isBanner;
  bool? isSlider;
  bool? sliderEnable;
  List<Slide>? slides;

  SliderClass({
    this.isBanner,
    this.isSlider,
    this.sliderEnable,
    this.slides,
  });

  factory SliderClass.fromJson(Map<String, dynamic> json) => SliderClass(
    isBanner: json["is_banner"],
    isSlider: json["is_slider"],
    sliderEnable: json["slider_enable"],
    slides: json["slides"] == null ? [] : List<Slide>.from(json["slides"]!.map((x) => Slide.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_banner": isBanner,
    "is_slider": isSlider,
    "slider_enable": sliderEnable,
    "slides": slides == null ? [] : List<dynamic>.from(slides!.map((x) => x.toJson())),
  };
}

class Slide {
  String? url;
  int? productId;
  String? productCategory;
  String? type;

  Slide({
    this.url,
    this.productId,
    this.productCategory,
    this.type,
  });

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
    url: json["url"],
    productId: json["product_id"],
    productCategory: json["product_category"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "product_id": productId,
    "product_category": productCategory,
    "type": type,
  };
}

class TimeBannerAd {
  String? addScreen;
  String? adsUrl;
  String? adsTitle;
  String? adsSubtitle;
  DateTime? offerDuration;

  TimeBannerAd({
    this.addScreen,
    this.adsUrl,
    this.adsTitle,
    this.adsSubtitle,
    this.offerDuration,
  });

  factory TimeBannerAd.fromJson(Map<String, dynamic> json) => TimeBannerAd(
    addScreen : json['add_screen'],
    adsUrl: json["ads_url"],
    adsTitle: json["ads_title"],
    adsSubtitle: json["ads_subtitle"],
    offerDuration: json["offer_duration"] == null ? null : DateTime.parse(json["offer_duration"]),
  );

  Map<String, dynamic> toJson() => {
    "add_screen":addScreen,
    "ads_url": adsUrl,
    "ads_title": adsTitle,
    "ads_subtitle": adsSubtitle,
    "offer_duration": "${offerDuration!.year.toString().padLeft(4, '0')}-${offerDuration!.month.toString().padLeft(2, '0')}-${offerDuration!.day.toString().padLeft(2, '0')}",
  };
}
