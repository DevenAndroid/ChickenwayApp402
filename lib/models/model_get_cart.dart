class ModelGetCartData {
  bool? status;
  String? message;
  Data? data;

  ModelGetCartData({this.status, this.message, this.data});

  ModelGetCartData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Cartmeta? cartmeta;
  List<CartProductItem>? items = [];
  List<CouponCode>? couponCode = [];

  Data({this.cartmeta, this.items, this.couponCode});

  Data.fromJson(Map<String, dynamic> json) {
    cartmeta =
        json['cartmeta'] != null ? Cartmeta.fromJson(json['cartmeta']) : null;
    if (json['items'] != null) {
      items = <CartProductItem>[];
      json['items'].forEach((v) {
        items!.add(CartProductItem.fromJson(v));
      });
    }
    if (json['coupon_code'] != null) {
      couponCode = <CouponCode>[];
      json['coupon_code'].forEach((v) {
        couponCode!.add(CouponCode.fromJson(v));
      });
    } else {
      couponCode = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartmeta != null) {
      data['cartmeta'] = cartmeta!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (couponCode != null) {
      data['coupon_code'] = couponCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cartmeta {
  String? subtotal;
  String? subtotalTax;
  String? shippingTotal;
  String? shippingTax;

  String? discountTotal;
  String? discountTax;
  String? cartContentsTotal;
  String? cartContentsTax;
  // List<Null>? cartContentsTaxes;
  String? feeTotal;
  String? feeTax;
  // List<Null>? feeTaxes;
  String? total;
  String? totalTax;
  String? currencySymbol;

  Cartmeta(
      {this.subtotal,
      this.subtotalTax,
      this.shippingTotal,
      this.shippingTax,
      // this.shippingTaxes,
      this.discountTotal,
      this.discountTax,
      this.cartContentsTotal,
      this.cartContentsTax,
      // this.cartContentsTaxes,
      this.feeTotal,
      this.feeTax,
      // this.feeTaxes,
      this.total,
      this.totalTax,
      this.currencySymbol});

  Cartmeta.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    subtotalTax = json['subtotal_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    // if (json['shipping_taxes'] != null) {
    //   shippingTaxes = <Null>[];
    //   json['shipping_taxes'].forEach((v) {
    //     shippingTaxes!.add(Null.fromJson(v));
    //   });
    // }
    discountTotal = json['discount_total'];
    discountTax = json['discount_tax'];
    cartContentsTotal = json['cart_contents_total'];
    cartContentsTax = json['cart_contents_tax'];
    // if (json['cart_contents_taxes'] != null) {
    //   cartContentsTaxes = <Null>[];
    //   json['cart_contents_taxes'].forEach((v) {
    //     cartContentsTaxes!.add(Null.fromJson(v));
    //   });
    // }
    feeTotal = json['fee_total'];
    feeTax = json['fee_tax'];
    // if (json['fee_taxes'] != null) {
    //   feeTaxes = <Null>[];
    //   json['fee_taxes'].forEach((v) {
    //     feeTaxes!.add(Null.fromJson(v));
    //   });
    // }
    total = json['total'];
    totalTax = json['total_tax'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subtotal'] = subtotal;
    data['subtotal_tax'] = subtotalTax;
    data['shipping_total'] = shippingTotal;
    data['shipping_tax'] = shippingTax;
    // if (shippingTaxes != null) {
    //   data['shipping_taxes'] =
    //       shippingTaxes!.map((v) => v.toJson()).toList();
    // }
    data['discount_total'] = discountTotal;
    data['discount_tax'] = discountTax;
    data['cart_contents_total'] = cartContentsTotal;
    data['cart_contents_tax'] = cartContentsTax;
    // if (cartContentsTaxes != null) {
    //   data['cart_contents_taxes'] =
    //       cartContentsTaxes!.map((v) => v.toJson()).toList();
    // }
    data['fee_total'] = feeTotal;
    data['fee_tax'] = feeTax;
    // if (feeTaxes != null) {
    //   data['fee_taxes'] = feeTaxes!.map((v) => v.toJson()).toList();
    // }
    data['total'] = total;
    data['total_tax'] = totalTax;
    data['currency_symbol'] = currencySymbol;
    return data;
  }
}

class CartProductItem {
  Product? product;
  dynamic quantity;
  // Null? variation;
  Addons? addons;
  dynamic totalPrice;

  CartProductItem(
      {this.product,
      this.quantity,
      // this.variation,
      this.addons,
      this.totalPrice});

  CartProductItem.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    // variation = json['variation'];
    addons = json['addons'] != null ? Addons.fromJson(json['addons']) : null;
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    // data['variation'] = variation;
    if (addons != null) {
      data['addons'] = addons!.toJson();
    }
    data['total_price'] = totalPrice;
    return data;
  }
}

class Product {
  String? id;
  String? name;
  String? slug;
  String? permalink;
  String? dateCreated;
  String? type;
  String? description;
  String? shortDescription;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? currencySymbol;
  dynamic storeId;
  String? storeName;
  String? averageRating;
  dynamic ratingCount;
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
  dynamic categoryId;
  String? categoryName;
  String? categorySlug;
  String? imageUrl;
  // Null? bookingData;
  // List<Null>? attributeData;

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
    // this.bookingData,
    // this.attributeData
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permalink = json['permalink'];
    dateCreated = json['date_created'];
    type = json['type'];
    description = json['description'];
    shortDescription = json['short_description'];
    price = json['price'];
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
    isInWishlist = json['is_in_wishlist'];
    onSale = json['on_sale'];
    purchasable = json['purchasable'];
    featured = json['featured'];
    virtual = json['virtual'];
    downloadable = json['downloadable'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    imageUrl = json['image_url'];
    // bookingData = json['booking_data'];
    // if (json['attribute_data'] != null) {
    //   attributeData = <Null>[];
    //   json['attribute_data'].forEach((v) {
    //     attributeData!.add(Null.fromJson(v));
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
    data['is_in_wishlist'] = isInWishlist;
    data['on_sale'] = onSale;
    data['purchasable'] = purchasable;
    data['featured'] = featured;
    data['virtual'] = virtual;
    data['downloadable'] = downloadable;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_slug'] = categorySlug;
    data['image_url'] = imageUrl;
    // data['booking_data'] = bookingData;
    // if (attributeData != null) {
    //   data['attribute_data'] =
    //       attributeData!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Addons {
  Map<String, dynamic>? cCustomOptions = {};
  dynamic iCustomPrice;
  // ignore: non_constant_identifier_names
  dynamic option_price;

  Addons({
    this.cCustomOptions,
    this.iCustomPrice,
    // ignore: non_constant_identifier_names
    this.option_price,
  });

  Addons.fromJson(Map<String, dynamic> json) {
    cCustomOptions = !(json['_custom_option'] ?? json['_custom_options'])
                .toString()
                .contains("[]") &&
            (json['_custom_option'] ?? json['_custom_options']) != null
        ? (json['_custom_option'] ?? json['_custom_options'])
        : {};
    iCustomPrice = json['_custom_price'];
    option_price = json['_option_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cCustomOptions != null) {
      data['_custom_options'] = cCustomOptions!;
    }
    data['_custom_price'] = iCustomPrice;
    data['_option_price'] = option_price;
    return data;
  }
}

class CustomOptions {
  String? tmcpRadio0;
  String? tmcpCheckbox10;
  String? tmcpCheckbox11;
  String? tmcpCheckbox12;
  String? tmcpCheckbox13;
  dynamic crispyPlusTextBox;
  String? tmcpCheckbox14;

  CustomOptions(
      {this.tmcpRadio0,
        this.tmcpCheckbox10,
        this.tmcpCheckbox11,
        this.tmcpCheckbox12,
        this.tmcpCheckbox13,
        this. crispyPlusTextBox,
        this.tmcpCheckbox14});

  CustomOptions.fromJson(Map<String, dynamic> json) {
    tmcpRadio0 = json['tmcp_radio_0'];
    tmcpCheckbox10 = json['tmcp_checkbox_1_0'];
    tmcpCheckbox11 = json['tmcp_checkbox_1_1'];
    tmcpCheckbox12 = json['tmcp_checkbox_1_2'];
    tmcpCheckbox13 = json['tmcp_checkbox_1_3'];
    crispyPlusTextBox = json['crispy_plus_text_box'];
    tmcpCheckbox14 = json['tmcp_checkbox_1_4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tmcp_radio_0'] = tmcpRadio0;
    data['tmcp_checkbox_1_0'] = tmcpCheckbox10;
    data['tmcp_checkbox_1_1'] = tmcpCheckbox11;
    data['tmcp_checkbox_1_2'] = tmcpCheckbox12;
    data['tmcp_checkbox_1_3'] = tmcpCheckbox13;
    data['crispy_plus_text_box'] = crispyPlusTextBox;
    data['tmcp_checkbox_1_4'] = tmcpCheckbox14;
    return data;
  }
}

class CouponCode {
  String? title;
  String? discount;

  CouponCode({this.title, this.discount});

  CouponCode.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['discount'] = discount;
    return data;
  }
}
