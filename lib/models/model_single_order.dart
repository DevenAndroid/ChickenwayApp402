class SingleOrderModel {
  bool? status;
  dynamic message;
  Data? data;

  SingleOrderModel({this.status, this.message, this.data});

  SingleOrderModel.fromJson(Map<String, dynamic> json) {
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
  dynamic id;
  dynamic parentId;
  dynamic status;
  dynamic currency;
  dynamic version;
  bool? pricesIncludeTax;
  DateCreated? dateCreated;
  DateCreated? dateModified;
  dynamic discountTotal;
  dynamic subtotal;
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
  DateCreated? datePaid;
  dynamic cartHash;
  bool? orderStockReduced;
  bool? downloadPermissionsGranted;
  bool? newOrderEmailSent;
  bool? recordedSales;
  bool? recordedCouponUsageCounts;
  dynamic number;
  List<MetaData>? metaData;
  List<AddressData>? addressData = [];
  OrderData? orderData;
  CommentData? commentData;

  Data(
      {this.id,
      this.parentId,
      this.status,
      this.currency,
      this.version,
      this.pricesIncludeTax,
      this.commentData,
      this.dateCreated,
      this.dateModified,
      this.discountTotal,
      this.subtotal,
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
      this.orderStockReduced,
      this.downloadPermissionsGranted,
      this.newOrderEmailSent,
      this.recordedSales,
      this.recordedCouponUsageCounts,
      this.number,
      this.metaData,
      this.addressData,
      this.orderData});

  Data.fromJson(Map<String, dynamic> json) {
    commentData = json['comment_data'] != null ? CommentData.fromJson(json['comment_data']) : null;
    id = json['id'];
    parentId = json['parent_id'];
    status = json['status'];
    currency = json['currency'];
    version = json['version'];
    pricesIncludeTax = json['prices_include_tax'];
    dateCreated = json['date_created'] != null ? DateCreated.fromJson(json['date_created']) : null;
    dateModified = json['date_modified'] != null ? DateCreated.fromJson(json['date_modified']) : null;
    discountTotal = json['discount_total'];
    subtotal = json['subtotal'];
    discountTax = json['discount_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    cartTax = json['cart_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    billing = json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    transactionId = json['transaction_id'];
    customerIpAddress = json['customer_ip_address'];
    customerUserAgent = json['customer_user_agent'];
    createdVia = json['created_via'];
    customerNote = json['customer_note'];
    dateCompleted = json['date_completed'];
    datePaid = json['date_paid'] != null ? DateCreated.fromJson(json['date_paid']) : null;
    cartHash = json['cart_hash'];
    orderStockReduced = json['order_stock_reduced'];
    downloadPermissionsGranted = json['download_permissions_granted'];
    newOrderEmailSent = json['new_order_email_sent'];
    recordedSales = json['recorded_sales'];
    recordedCouponUsageCounts = json['recorded_coupon_usage_counts'];
    number = json['number'];
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    if (json['address_data'] != null) {
      addressData = <AddressData>[];
      json['address_data'].forEach((v) {
        addressData!.add(AddressData.fromJson(v));
      });
    } else {
      addressData = [];
    }
    orderData = json['order_data'] != null ? OrderData.fromJson(json['order_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    if (commentData != null) {
      data['comment_data'] = commentData!.toJson();
    }
    data['status'] = status;
    data['currency'] = currency;
    data['version'] = version;
    data['prices_include_tax'] = pricesIncludeTax;
    if (dateCreated != null) {
      data['date_created'] = dateCreated!.toJson();
    }
    if (dateModified != null) {
      data['date_modified'] = dateModified!.toJson();
    }
    data['discount_total'] = discountTotal;
    data['subtotal'] = subtotal;
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
    if (datePaid != null) {
      data['date_paid'] = datePaid!.toJson();
    }
    data['cart_hash'] = cartHash;
    data['order_stock_reduced'] = orderStockReduced;
    data['download_permissions_granted'] = downloadPermissionsGranted;
    data['new_order_email_sent'] = newOrderEmailSent;
    data['recorded_sales'] = recordedSales;
    data['recorded_coupon_usage_counts'] = recordedCouponUsageCounts;
    data['number'] = number;
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    if (addressData != null) {
      data['address_data'] = addressData!.map((v) => v.toJson()).toList();
    }
    if (orderData != null) {
      data['order_data'] = orderData!.toJson();
    }
    return data;
  }
}

class DateCreated {
  dynamic date;
  dynamic timezoneType;
  dynamic timezone;

  DateCreated({this.date, this.timezoneType, this.timezone});

  DateCreated.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
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

class MetaData {
  dynamic id;
  dynamic key;
  dynamic value;

  MetaData({this.id, this.key, this.value});

  MetaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class AddressData {
  dynamic homeData;
  dynamic building;
  dynamic floor;
  dynamic address;
  dynamic email;
  dynamic phoneNumber;
  dynamic lat;
  dynamic long;

  AddressData({this.homeData, this.building, this.floor, this.address, this.email, this.phoneNumber, this.lat, this.long});

  AddressData.fromJson(Map<String, dynamic> json) {
    homeData = json['home_data'];
    building = json['Building'];
    floor = json['Floor'];
    address = json['Address'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['home_data'] = homeData;
    data['Building'] = building;
    data['Floor'] = floor;
    data['Address'] = address;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class OrderData {
  dynamic id;
  dynamic status;
  dynamic ordernote;
  dynamic crispyplustextbox;
  dynamic dateCreated;
  dynamic shippingTotal;
  // ignore: non_constant_identifier_names
  dynamic shipoing_tota;
  dynamic totalTax;
  dynamic discountTotal;
  dynamic subtotal;
  dynamic total;
  dynamic currencySymbol;
  dynamic paymentMethodTitle;
  List<LineItems>? lineItems;

  OrderData(
      {this.id,
      this.status,
      this.ordernote,
      this.crispyplustextbox,
      this.dateCreated,
      this.shippingTotal,
      this.totalTax,
      this.discountTotal,
      // ignore: non_constant_identifier_names
      this.shipoing_tota,
      this.subtotal,
      this.total,
      this.currencySymbol,
      this.paymentMethodTitle,
      this.lineItems});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    ordernote = json['order_note'];
    crispyplustextbox = json['crispy_plus_text_box'];
    dateCreated = json['date_created'];
    shippingTotal = json['shipping_total'];
    totalTax = json['total_tax'];
    discountTotal = json['discount_total'];
    shipoing_tota = json['shipoing_tota'];
    subtotal = json['subtotal'];
    total = json['total'];
    currencySymbol = json['currency_symbol'];
    paymentMethodTitle = json['payment_method_title'];
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['order_note'] = ordernote;
    data['crispy_plus_text_box'] = crispyplustextbox;
    data['date_created'] = dateCreated;
    data['shipoing_tota'] = shipoing_tota;
    data['shipping_total'] = shippingTotal;
    data['total_tax'] = totalTax;
    data['discount_total'] = discountTotal;
    data['subtotal'] = subtotal;
    data['total'] = total;
    data['currency_symbol'] = currencySymbol;
    data['payment_method_title'] = paymentMethodTitle;
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItems {
  dynamic id;
  dynamic name;
  dynamic productId;
  dynamic variationId;
  dynamic quantity;
  dynamic total;
  dynamic currencySymbol;

  LineItems({this.id, this.name, this.productId, this.variationId, this.quantity, this.total, this.currencySymbol});

  LineItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    total = json['total'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['quantity'] = quantity;
    data['total'] = total;
    data['currency_symbol'] = currencySymbol;
    return data;
  }
}

class CommentData {
  String? commentAuthor;
  String? commentContent;
  String? commentDate;
  String? rating;

  CommentData({this.commentAuthor, this.commentContent, this.commentDate, this.rating});

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
