import 'package:flutter/material.dart';

class ModelFoodMenuProducts {
  bool? status;
  dynamic message;
  List<FoodMenuData>? data;

  ModelFoodMenuProducts({this.status, this.message, this.data});

  ModelFoodMenuProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FoodMenuData>[];
      json['data'].forEach((v) {
        data!.add(FoodMenuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodMenuData {
  dynamic termId;
  GlobalKey menuKeyUpper = GlobalKey();
  GlobalKey menuKeyLower = GlobalKey();
  dynamic name;
  dynamic slug;
  dynamic imageUrl;
  dynamic categoryName;
  dynamic categoryId;
  dynamic categorySlug;
  dynamic yallaImage;
  dynamic priority;
  dynamic homescreentop;
  dynamic yallaMenu;
  dynamic menuscreen;
  dynamic iconCate;
  List<ProductsData>? productsData;

  FoodMenuData({this.termId, this.name, this.slug, this.imageUrl, this.productsData});

  FoodMenuData.fromJson(Map<String, dynamic> json) {
    termId = json['category_id'];
    name = json['category_name'];
    slug = json['category_slug'];
    imageUrl = json['image_url'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    categorySlug = json['category_slug'];
    yallaImage = json['yalla_image'];
    priority = json['priority'];
    homescreentop = json['homescreentop'];
    yallaMenu = json['yalla_menu'];
    menuscreen = json['menuscreen '];
    iconCate = json['icon_cate'];
    if (json['products'] != null) {
      productsData = <ProductsData>[];
      json['products'].forEach((v) {
        productsData!.add(ProductsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = termId;
    data['category_name'] = name;
    data['category_slug'] = slug;
    data['image_url'] = imageUrl;
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['category_slug'] = categorySlug;
    data['yalla_image'] = yallaImage;
    data['priority'] = priority;
    data['homescreentop'] = homescreentop;
    data['yalla_menu'] = yallaMenu;
    data['menuscreen '] = menuscreen;
    data['icon_cate'] = iconCate;
    if (productsData != null) {
      data['products'] =
          productsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsData {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic permalink;
  dynamic dateCreated;
  dynamic type;
  dynamic description;
  dynamic shortDescription;
  dynamic price;
  dynamic intPrice;
  dynamic regularPrice;
  dynamic salePrice;
  dynamic currencySymbol;
  dynamic storeId;
  dynamic storeName;
  dynamic averageRating;
  dynamic ratingCount;
  bool? manageStock;
  dynamic stockStatus;
  dynamic stockQuantity;
  dynamic lowStockAmount;
  // Null? isInWishlist;
  bool? onSale;
  bool? purchasable;
  bool? featured;
  bool? virtual;
  bool? downloadable;
  dynamic categoryId;
  dynamic categoryName;
  dynamic categorySlug;
  dynamic imageUrl;
  dynamic created;
  dynamic createdFormated;
  // List<Null>? attributeData;
  // List<AddonsData>? addonsData;

  ProductsData(
      {this.id,
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
        // this.addonsData
      });

  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permalink = json['permalink'];
    dateCreated = json['date_created'];
    type = json['type'];
    description = json['description'];
    shortDescription = json['short_description'];
    price = json['price'];
    intPrice = json['int_price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    currencySymbol = json['currency_symbol'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    manageStock = json['manage_stock'];
    stockStatus = json['stock_status'];
    stockQuantity = json['stock_quantity'];
    lowStockAmount = json['low_stock_amount'];
    // isInWishlist = json['is_in_wishlist'];
    onSale = json['on_sale'];
    purchasable = json['purchasable'];
    featured = json['featured'];
    virtual = json['virtual'];
    downloadable = json['downloadable'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    imageUrl = json['image_url'];
    created = json['created'];
    createdFormated = json['created_formated'];
    // if (json['attribute_data'] != null) {
    //   attributeData = <Null>[];
    //   json['attribute_data'].forEach((v) {
    //     attributeData!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['addons_data'] != null) {
    //   addonsData = <AddonsData>[];
    //   json['addons_data'].forEach((v) {
    //     addonsData!.add(AddonsData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['permalink'] = permalink;
    data['date_created'] = dateCreated;
    data['type'] = type;
    data['description'] = description;
    data['short_description'] = shortDescription;
    data['price'] = price;
    data['int_price'] = intPrice;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['currency_symbol'] = currencySymbol;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['average_rating'] = averageRating;
    data['rating_count'] = ratingCount;
    data['manage_stock'] = manageStock;
    data['stock_status'] = stockStatus;
    data['stock_quantity'] = stockQuantity;
    data['low_stock_amount'] = lowStockAmount;
    // data['is_in_wishlist'] = isInWishlist;
    data['on_sale'] = onSale;
    data['purchasable'] = purchasable;
    data['featured'] = featured;
    data['virtual'] = virtual;
    data['downloadable'] = downloadable;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_slug'] = categorySlug;
    data['image_url'] = imageUrl;
    data['created'] = created;
    data['created_formated'] = createdFormated;
    // if (attributeData != null) {
    //   data['attribute_data'] =
    //       attributeData!.map((v) => v.toJson()).toList();
    // }
    // if (addonsData != null) {
    //   data['addons_data'] = addonsData!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

