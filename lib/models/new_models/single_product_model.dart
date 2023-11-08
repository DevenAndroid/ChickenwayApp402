class ModelSingleProduct {
  bool? status;
  String? message;
  List<ProductData>? data;
  List<AddonsData>? productOption;
  /// For checkbox
  Map<String, String> selectedRadios = {};
  List<String> selected1 = [];

  ModelSingleProduct(
      {this.status, this.message, this.data, this.productOption});

  ModelSingleProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        if (v != null) {
          data!.add(ProductData.fromJson(v));
        }
      });
    }
    if (json['product_option'] != null) {
      productOption = <AddonsData>[];
      json['product_option'].forEach((v) {
        if (v != null) {
          productOption!.add(AddonsData.fromJson(v));
        }
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
    if (productOption != null) {
      data['product_option'] = productOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductData {
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
  String? createdFormated;
  // List<Null>? attributeData;
  // List<AddonsData>? addonsData;

  ProductData({
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
    // this.attributeData,
    // this.addonsData
  });

  ProductData.fromJson(Map<String, dynamic> json) {
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
    //     if(v != null) {
    //       addonsData!.add(AddonsData.fromJson(v));
    //     }
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
    data['created'] = created;
    data['created_formated'] = createdFormated;
    // if (this.attributeData != null) {
    //   data['attribute_data'] =
    //       this.attributeData!.map((v) => v.toJson()).toList();
    // }
    // if (addonsData != null) {
    //   data['addons_data'] = addonsData!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class AddonsData {
  /// For checkbox
  bool makeDefaults = true;
  bool makeDefaultsCheckBox = true;

  String? sectionsPlacement = "";
  List<String>? uniId;
  Map<String, dynamic>? title;
  Map<String, dynamic>? checkBoxesHeaderSubtitle;
  Map<String, dynamic>? headerSubtitle;
  Map<String, dynamic>? checkBoxesRequired;
  Map<String, dynamic>? checkBoxesHeaderTitle;
  Map<String, dynamic>? radioButtonsRequired;
  Map<String, dynamic>? radioOptionsDefaultValue;

  Map<String, List<String>>? optionsTitle;
  Map<String, List<String>>? optionsImage;
  Map<String, List<String>>? optionsPrice;
  Map<String, List<String>>? checkBoxesOptionsDefaultValue;
  Map<String, List<String>>? salePrice;
  Map<String, dynamic>? radiobuttonsHeaderTitle;
  Map<String, dynamic>? radiobuttonsHeaderSubtitle;
  Map<String, List<String>>? multipleRadiobuttonsOptionsTitle;
  Map<String, List<String>>? radiobuttonsOptionsImage;
  Map<String, List<String>>? radiobuttonsOptionsValue;
  Map<String, List<String>>? radiobuttonsOptionsPrice;
  Map<String, List<String>>? radiobuttonsSalePrice;

  AddonsData(
      {this.uniId,
      this.title,
      this.headerSubtitle,
      this.sectionsPlacement,
      this.checkBoxesRequired,
      this.checkBoxesHeaderTitle,
      this.radioButtonsRequired,
      this.radioOptionsDefaultValue,
      this.checkBoxesHeaderSubtitle,
      this.optionsTitle,
      this.optionsImage,
      this.optionsPrice,
      this.checkBoxesOptionsDefaultValue,
      this.salePrice,
      this.radiobuttonsHeaderTitle,
      this.radiobuttonsHeaderSubtitle,
      this.multipleRadiobuttonsOptionsTitle,
      this.radiobuttonsOptionsImage,
      this.radiobuttonsOptionsValue,
      this.radiobuttonsOptionsPrice,
      this.radiobuttonsSalePrice});

  AddonsData.fromJson(Map<String, dynamic> json) {
    sectionsPlacement = json["sections_placement"];
    uniId = json['uni_id'].cast<String>();
    title = (json['title'] != null && json['title'].toString().isNotEmpty)
        ? json['title']
        : {};
    headerSubtitle = (json['header_subtitle'] != null &&
            json['header_subtitle'].toString().isNotEmpty)
        ? json['header_subtitle']
        : {};
    checkBoxesRequired = (json['checkboxes_required'] != null &&
            json['checkboxes_required'].toString().isNotEmpty)
        ? json['checkboxes_required']
        : {};
    checkBoxesHeaderTitle = (json['checkboxes_header_title'] != null &&
            json['checkboxes_header_title'].toString().isNotEmpty)
        ? json['checkboxes_header_title']
        : {};
    radioButtonsRequired = (json['radiobuttons_required'] != null &&
            json['radiobuttons_required'].toString().isNotEmpty)
        ? json['radiobuttons_required']
        : {};
    radioOptionsDefaultValue = (json['radio_options_default_value'] != null &&
            json['radio_options_default_value'].toString().isNotEmpty)
        ? json['radio_options_default_value']
        : {};
    checkBoxesHeaderSubtitle = (json['checkboxes_header_subtitle'] != null &&
            json['checkboxes_header_subtitle'].toString().isNotEmpty)
        ? json['checkboxes_header_subtitle']
        : {};
    radiobuttonsHeaderTitle = json['radiobuttons_header_title'] != null &&
            json['radiobuttons_header_title'].toString() != ""
        ? json['radiobuttons_header_title']
        : {};
    radiobuttonsHeaderSubtitle = json['radiobuttons_header_subtitle'] != null &&
            json['radiobuttons_header_subtitle'].toString() != ""
        ? json['radiobuttons_header_subtitle']
        : {};

    // checkboxes_header_subtitle = json['checkboxes_header_subtitle'];

    // if(json['options_title'] != null){
    // log("title......     ${parseMap(json['options_title'])}");
    //
    //   // (json['options_title'] as Map).forEach((key, value) {
    //   //   log("title......     ${(json['options_title'] as Map).entries.map((e) => {e.key : e.value})}");
    //   // });
    // }


    optionsTitle = (json['options_title'] != null &&
            json['options_title'].toString() != "")
        ? parseMap(json['options_title'])
        : {};
    optionsImage = (json['options_image'] != null &&
            json['options_image'].toString() != "")
        ? parseMap(json['options_image'])
        : {};
    optionsPrice = (json['options_price'] != null &&
            json['options_price'].toString() != "")
        ? parseMap(json['options_price'])
        : {};
    checkBoxesOptionsDefaultValue = (json['checkboxes_options_default_value'] != null &&
            json['checkboxes_options_default_value'].toString() != "")
        ? parseMap(json['checkboxes_options_default_value'])
        : {};
    salePrice =
        (json['sale_price'] != null && json['sale_price'].toString() != "")
            ? parseMap(json['sale_price'])
            : {};

    // log("title......     $title");
    // log("headerSubtitle......     $headerSubtitle");
    // log("optionsTitle......     $optionsTitle");
    // log("optionsImage......     $optionsImage");
    // log("optionsPrice......     $optionsPrice");
    // log("salePrice......     $salePrice");
    multipleRadiobuttonsOptionsTitle =
        json['multiple_radiobuttons_options_title'] != null &&
                json['multiple_radiobuttons_options_title'].toString() != ""
            ? parseMap(json['multiple_radiobuttons_options_title'])
            : {};
    radiobuttonsOptionsImage = json['radiobuttons_options_image'] != null &&
            json['radiobuttons_options_image'].toString() != ""
        ? parseMap(json['radiobuttons_options_image'])
        : {};
    radiobuttonsOptionsValue = json['radiobuttons_options_value'] != null &&
            json['radiobuttons_options_value'].toString() != ""
        ? parseMap(json['radiobuttons_options_value'])
        : {};
    radiobuttonsOptionsPrice = json['radiobuttons_options_price'] != null &&
            json['radiobuttons_options_price'].toString() != ""
        ? parseMap(json['radiobuttons_options_price'])
        : {};
    radiobuttonsSalePrice = json['radiobuttons_sale_price'] != null &&
            json['radiobuttons_sale_price'].toString() != ""
        ? parseMap(json['radiobuttons_sale_price'])
        : {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uni_id'] = uniId;
    // if (title != null) {
    //   data['title'] = title!.toJson();
    // }
    // if (headerSubtitle != null) {
    //   data['header_subtitle'] = headerSubtitle!.toJson();
    // }
    // if (optionsTitle != null) {
    //   data['options_title'] = optionsTitle!.toJson();
    // }
    // if (optionsImage != null) {
    //   data['options_image'] = optionsImage!.toJson();
    // }
    // if (optionsPrice != null) {
    //   data['options_price'] = optionsPrice!.toJson();
    // }
    // if (salePrice != null) {
    //   data['sale_price'] = salePrice!.toJson();
    // }
    data['radiobuttons_header_title'] = radiobuttonsHeaderTitle;
    data['sections_placement'] = sectionsPlacement;
    data['radiobuttons_header_subtitle'] = radiobuttonsHeaderSubtitle;
    data['multiple_radiobuttons_options_title'] =
        multipleRadiobuttonsOptionsTitle;
    data['radiobuttons_options_image'] = radiobuttonsOptionsImage;
    data['radiobuttons_options_value'] = radiobuttonsOptionsValue;
    data['radiobuttons_options_price'] = radiobuttonsOptionsPrice;
    data['radiobuttons_sale_price'] = radiobuttonsSalePrice;
    return data;
  }
}

// class Title {
//   String? s0;
//
//   Title({this.s0});
//
//   Title.fromJson(Map<String, dynamic> json) {
//     s0 = json['0'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['0'] = s0;
//     return data;
//   }
// }

// class OptionsTitle {
//   List<String>? l0;
//
//   OptionsTitle({this.l0});
//
//   OptionsTitle.fromJson(Map<String, dynamic> json) {
//     l0 = json['0'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['0'] = l0;
//     return data;
//   }
// }

Map<String, List<String>> parseMap(Map<dynamic, dynamic> item) {
  Map<String, List<String>> data = {};
  item.forEach((key, value) {
    data["$key"] = value.cast<String>();
  });
  return data;
}
