class YourOrderProfile {
  bool? status;
  dynamic message;
  Data? data;

  YourOrderProfile({this.status, this.message, this.data});

  YourOrderProfile.fromJson(Map<String, dynamic> json) {
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
  dynamic count;
  dynamic page;
  dynamic perPage;
  List<Orders>? orders;

  Data({this.count, this.page, this.perPage, this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    page = json['page'];
    perPage = json['per_page'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['page'] = page;
    data['per_page'] = perPage;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  dynamic id;
  dynamic parentId;
  dynamic status;
  dynamic currency;
  dynamic version;
  bool? pricesIncludeTax;
  dynamic dateCreated;
  dynamic dateModified;
  dynamic discountTotal;
  dynamic discountTax;
  dynamic shippingTotal;
  dynamic shippingTax;
  dynamic cartTax;
  dynamic total;
  dynamic totalTax;
  dynamic customerId;
  dynamic orderKey;
  Billing? billing;
  Shipping? shipping;
  dynamic paymentMethod;
  dynamic paymentMethodTitle;
  dynamic transactionId;
  dynamic customerIpAddress;
  dynamic customerUserAgent;
  dynamic createdVia;
  dynamic customerNote;
  dynamic dateCompleted;
  dynamic datePaid;
  dynamic cartHash;
  dynamic number;
  // List<MetaData>? metaData;
  List<LineItems>? lineItems;
  dynamic paymentUrl;
  bool? isEditable;
  bool? needsPayment;
  bool? needsProcessing;
  dynamic dateCreatedGmt;
  dynamic dateModifiedGmt;
  dynamic dateCompletedGmt;
  dynamic datePaidGmt;
  dynamic currencySymbol;
  bool? hasSuborder;
  CommentData? commentData;

  Orders(
      {this.id,
        this.parentId,
        this.status,
        this.currency,
        this.version,
        this.pricesIncludeTax,
        this.dateCreated,
        this.dateModified,
        this.discountTotal,
        this.discountTax,
        this.shippingTotal,
        this.shippingTax,
        this.cartTax,
        this.total,
        this.totalTax,
        this.customerId,
        this.orderKey,
        this.billing,
        this.shipping,
        this.paymentMethod,
        this.paymentMethodTitle,
        this.transactionId,
        this.customerIpAddress,
        this.customerUserAgent,
        this.createdVia,
        this.customerNote,
        this.dateCompleted,
        this.datePaid,
        this.cartHash,
        this.number,
        // this.metaData,
        this.lineItems,
        this.paymentUrl,
        this.isEditable,
        this.needsPayment,
        this.needsProcessing,
        this.dateCreatedGmt,
        this.dateModifiedGmt,
        this.dateCompletedGmt,
        this.datePaidGmt,
        this.currencySymbol,
        this.hasSuborder,
        this.commentData});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    status = json['status'];
    currency = json['currency'];
    version = json['version'];
    pricesIncludeTax = json['prices_include_tax'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    discountTotal = json['discount_total'];
    discountTax = json['discount_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    cartTax = json['cart_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    billing =
    json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null
        ? Shipping.fromJson(json['shipping'])
        : null;
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    transactionId = json['transaction_id'];
    customerIpAddress = json['customer_ip_address'];
    customerUserAgent = json['customer_user_agent'];
    createdVia = json['created_via'];
    customerNote = json['customer_note'];
    dateCompleted = json['date_completed'];
    datePaid = json['date_paid'];
    cartHash = json['cart_hash'];
    number = json['number'];
    // if (json['meta_data'] != null) {
    //   metaData = <MetaData>[];
    //   json['meta_data'].forEach((v) {
    //     metaData!.add(MetaData.fromJson(v));
    //   });
    // }
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    paymentUrl = json['payment_url'];
    isEditable = json['is_editable'];
    needsPayment = json['needs_payment'];
    needsProcessing = json['needs_processing'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModifiedGmt = json['date_modified_gmt'];
    dateCompletedGmt = json['date_completed_gmt'];
    datePaidGmt = json['date_paid_gmt'];
    currencySymbol = json['currency_symbol'];
    hasSuborder = json['has_suborder'];
    commentData = json['comment_data'] != null
        ? CommentData.fromJson(json['comment_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['status'] = status;
    data['currency'] = currency;
    data['version'] = version;
    data['prices_include_tax'] = pricesIncludeTax;
    data['date_created'] = dateCreated;
    data['date_modified'] = dateModified;
    data['discount_total'] = discountTotal;
    data['discount_tax'] = discountTax;
    data['shipping_total'] = shippingTotal;
    data['shipping_tax'] = shippingTax;
    data['cart_tax'] = cartTax;
    data['total'] = total;
    data['total_tax'] = totalTax;
    data['customer_id'] = customerId;
    data['order_key'] = orderKey;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['transaction_id'] = transactionId;
    data['customer_ip_address'] = customerIpAddress;
    data['customer_user_agent'] = customerUserAgent;
    data['created_via'] = createdVia;
    data['customer_note'] = customerNote;
    data['date_completed'] = dateCompleted;
    data['date_paid'] = datePaid;
    data['cart_hash'] = cartHash;
    data['number'] = number;
    // if (metaData != null) {
    //   data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    // }
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    data['payment_url'] = paymentUrl;
    data['is_editable'] = isEditable;
    data['needs_payment'] = needsPayment;
    data['needs_processing'] = needsProcessing;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified_gmt'] = dateModifiedGmt;
    data['date_completed_gmt'] = dateCompletedGmt;
    data['date_paid_gmt'] = datePaidGmt;
    data['currency_symbol'] = currencySymbol;
    data['has_suborder'] = hasSuborder;
    if (commentData != null) {
      data['comment_data'] = commentData!.toJson();
    }
    return data;
  }
}

class Billing {
  dynamic firstName;
  dynamic lastName;
  dynamic company;
  dynamic address1;
  dynamic address2;
  dynamic city;
  dynamic state;
  dynamic postcode;
  dynamic country;
  dynamic email;
  dynamic phone;

  Billing(
      {this.firstName,
        this.lastName,
        this.company,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.postcode,
        this.country,
        this.email,
        this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Shipping {
  dynamic firstName;
  dynamic lastName;
  dynamic company;
  dynamic address1;
  dynamic address2;
  dynamic city;
  dynamic state;
  dynamic postcode;
  dynamic country;
  dynamic phone;

  Shipping(
      {this.firstName,
        this.lastName,
        this.company,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.postcode,
        this.country,
        this.phone});

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    data['phone'] = phone;
    return data;
  }
}

// class MetaData {
//   dynamic id;
//   dynamic key;
//   dynamic value;
//
//   MetaData({this.id, this.key, this.value});
//
//   MetaData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     key = json['key'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['key'] = key;
//     data['value'] = value;
//     return data;
//   }
// }

class LineItems {
  dynamic id;
  dynamic name;
  dynamic productId;
  dynamic variationId;
  dynamic quantity;
  dynamic taxClass;
  dynamic subtotal;
  dynamic subtotalTax;
  dynamic total;
  dynamic totalTax;
  // List<MetaData>? metaData;
  dynamic sku;
  dynamic price;
  Image? image;

  LineItems(
      {this.id,
        this.name,
        this.productId,
        this.variationId,
        this.quantity,
        this.taxClass,
        this.subtotal,
        this.subtotalTax,
        this.total,
        this.totalTax,
        // this.taxes,
        // this.metaData,
        this.sku,
        this.price,
        this.image,
        // this.parentName
      });

  LineItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    taxClass = json['tax_class'];
    subtotal = json['subtotal'];
    subtotalTax = json['subtotal_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    // if (json['taxes'] != null) {
    //   taxes = <Null>[];
    //   json['taxes'].forEach((v) {
    //     taxes!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['meta_data'] != null) {
    //   metaData = <MetaData>[];
    //   json['meta_data'].forEach((v) {
    //     metaData!.add(MetaData.fromJson(v));
    //   });
    // }
    sku = json['sku'];
    price = json['price'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    // parentName = json['parent_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['quantity'] = quantity;
    data['tax_class'] = taxClass;
    data['subtotal'] = subtotal;
    data['subtotal_tax'] = subtotalTax;
    data['total'] = total;
    data['total_tax'] = totalTax;
    // if (this.taxes != null) {
    //   data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    // }
    // if (metaData != null) {
    //   data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    // }
    data['sku'] = sku;
    data['price'] = price;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    // data['parent_name'] = this.parentName;
    return data;
  }
}

class Image {
  dynamic id;
  dynamic src;

  Image({this.id, this.src});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['src'] = src;
    return data;
  }
}

class CommentData {
  dynamic commentAuthor;
  dynamic commentContent;
  dynamic commentDate;
  dynamic rating;

  CommentData(
      {this.commentAuthor, this.commentContent, this.commentDate, this.rating});

  CommentData.fromJson(Map<String, dynamic> json) {
    commentAuthor = json['comment_author'];
    commentContent = json['comment_content'];
    commentDate = json['comment_date'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment_author'] = commentAuthor;
    data['comment_content'] = commentContent;
    data['comment_date'] = commentDate;
    data['rating'] = rating;
    return data;
  }
}
