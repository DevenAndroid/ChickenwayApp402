class ModelWishList {
  bool? status;
  String? message;
  List<Data>? data;

  ModelWishList({this.status, this.message, this.data});

  ModelWishList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
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
  // List<AddonsData>? addonsData;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    //     attributeData!.add(new Null.fromJson(v));
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

// class AddonsData {
//   List<String>? uniId = [];
//   List<String>? title = [];
//   List<String>? headerSubtitle = [];
//   List<String>? optionsTitle = [];
//   List<String>? optionsImage = [];
//   List<String>? optionsPrice = [];
//   List<String>? salePrice = [];
//   List<String>? radiobuttonsHeaderTitle = [];
//   List<String>? radiobuttonsHeaderSubtitle = [];
//   List<String>? multipleRadiobuttonsOptionsTitle = [];
//   List<String>? radiobuttonsOptionsImage = [];
//   List<String>? radiobuttonsOptionsValue = [];
//   List<String>? radiobuttonsOptionsPrice = [];
//   List<String>? radiobuttonsSalePrice = [];
//
//   AddonsData(
//       {this.uniId,
//         this.title,
//         this.headerSubtitle,
//         this.optionsTitle,
//         this.optionsImage,
//         this.optionsPrice,
//         this.salePrice,
//         this.radiobuttonsHeaderTitle,
//         this.radiobuttonsHeaderSubtitle,
//         this.multipleRadiobuttonsOptionsTitle,
//         this.radiobuttonsOptionsImage,
//         this.radiobuttonsOptionsValue,
//         this.radiobuttonsOptionsPrice,
//         this.radiobuttonsSalePrice});
//
//   AddonsData.fromJson(Map<String, dynamic> json) {
//     uniId = (json['uni_id'] != null && json['uni_id'].toString() != "") ? json['uni_id'].cast<String>() : [];
//     title = (json['title'] != null && json['title'].toString() != "") ? json['title'].cast<String>() : [];
//     headerSubtitle = (json['header_subtitle'] != null && json['header_subtitle'].toString() != "") ? json['header_subtitle'].cast<String>() : [];
//     optionsTitle = (json['options_title'] != null && json['options_title'].toString() != "") ? json['options_title'].cast<String>() : [];
//     optionsImage = (json['options_image'] != null && json['options_image'].toString() != "") ? json['options_image'].cast<String>() : [];
//     optionsPrice = (json['options_price'] != null && json['options_price'].toString() != "") ? json['options_price'].cast<String>() : [];
//     salePrice = (json['sale_price'] != null && json['sale_price'].toString() != "") ? json['sale_price'].cast<String>() : [];
//     radiobuttonsHeaderTitle = (json['radiobuttons_header_title'] != null && json['radiobuttons_header_title'].toString() != "") ? json['radiobuttons_header_title'].cast<String>() : [];
//     radiobuttonsHeaderSubtitle = (json['radiobuttons_header_subtitle'] != null && json['radiobuttons_header_subtitle'].toString() != "") ? json['radiobuttons_header_subtitle'].cast<String>() : [];
//     multipleRadiobuttonsOptionsTitle = (json['multiple_radiobuttons_options_title'] != null && json['multiple_radiobuttons_options_title'].toString() != "") ? json['multiple_radiobuttons_options_title'].cast<String>() : [];
//     radiobuttonsOptionsImage = (json['radiobuttons_options_image'] != null && json['radiobuttons_options_image'].toString() != "") ? json['radiobuttons_options_image'].cast<String>() : [];
//     radiobuttonsOptionsValue = (json['radiobuttons_options_value'] != null && json['radiobuttons_options_value'].toString() != "") ? json['radiobuttons_options_value'].cast<String>() : [];
//     radiobuttonsOptionsPrice = (json['radiobuttons_options_price'] != null && json['radiobuttons_options_price'].toString() != "") ? json['radiobuttons_options_price'].cast<String>() : [];
//     radiobuttonsSalePrice = (json['radiobuttons_sale_price'] != null && json['radiobuttons_sale_price'].toString() != "") ? json['radiobuttons_sale_price'].cast<String>() : [];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['uni_id'] = uniId;
//     data['title'] = title;
//     data['header_subtitle'] = headerSubtitle;
//     data['options_title'] = optionsTitle;
//     data['options_image'] = optionsImage;
//     data['options_price'] = optionsPrice;
//     data['sale_price'] = salePrice;
//     data['radiobuttons_header_title'] = radiobuttonsHeaderTitle;
//     data['radiobuttons_header_subtitle'] = radiobuttonsHeaderSubtitle;
//     data['multiple_radiobuttons_options_title'] =
//         multipleRadiobuttonsOptionsTitle;
//     data['radiobuttons_options_image'] = radiobuttonsOptionsImage;
//     data['radiobuttons_options_value'] = radiobuttonsOptionsValue;
//     data['radiobuttons_options_price'] = radiobuttonsOptionsPrice;
//     data['radiobuttons_sale_price'] = radiobuttonsSalePrice;
//     return data;
//   }
// }
