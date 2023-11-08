class ModelCreateOrderResponse {
  dynamic status;
  dynamic orderId;
  dynamic total;
  Data? data;
  dynamic message;

  ModelCreateOrderResponse(
      {this.status, this.orderId, this.total, this.data, this.message});

  ModelCreateOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['order_id'];
    total = json['total'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['order_id'] = orderId;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
  // Null? dateCompleted;
  dynamic datePaid;
  dynamic cartHash;
  dynamic number;
  List<MetaData>? metaData;
  List<LineItems>? lineItems;
  // List<Null>? taxLines;
  // List<Null>? shippingLines;
  // List<Null>? feeLines;
  List<CouponLines>? couponLines;
  // List<Null>? refunds;
  dynamic paymentUrl;
  bool? isEditable;
  bool? needsPayment;
  bool? needsProcessing;
  dynamic dateCreatedGmt;
  dynamic dateModifiedGmt;
  // Null? dateCompletedGmt;
  dynamic datePaidGmt;
  dynamic currencySymbol;
  Links? lLinks;

  Data(
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
        // this.dateCompleted,
        this.datePaid,
        this.cartHash,
        this.number,
        this.metaData,
        this.lineItems,
        // this.taxLines,
        // this.shippingLines,
        // this.feeLines,
        this.couponLines,
        // this.refunds,
        this.paymentUrl,
        this.isEditable,
        this.needsPayment,
        this.needsProcessing,
        this.dateCreatedGmt,
        this.dateModifiedGmt,
        // this.dateCompletedGmt,
        this.datePaidGmt,
        this.currencySymbol,
        this.lLinks});

  Data.fromJson(Map<String, dynamic> json) {
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
    // dateCompleted = json['date_completed'];
    datePaid = json['date_paid'];
    cartHash = json['cart_hash'];
    number = json['number'];
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    // if (json['tax_lines'] != null) {
    //   taxLines = <Null>[];
    //   json['tax_lines'].forEach((v) {
    //     taxLines!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['shipping_lines'] != null) {
    //   shippingLines = <Null>[];
    //   json['shipping_lines'].forEach((v) {
    //     shippingLines!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['fee_lines'] != null) {
    //   feeLines = <Null>[];
    //   json['fee_lines'].forEach((v) {
    //     feeLines!.add(Null.fromJson(v));
    //   });
    // }
    if (json['coupon_lines'] != null) {
      couponLines = <CouponLines>[];
      json['coupon_lines'].forEach((v) {
        couponLines!.add(CouponLines.fromJson(v));
      });
    }
    // if (json['refunds'] != null) {
    //   refunds = <Null>[];
    //   json['refunds'].forEach((v) {
    //     refunds!.add(Null.fromJson(v));
    //   });
    // }
    paymentUrl = json['payment_url'];
    isEditable = json['is_editable'];
    needsPayment = json['needs_payment'];
    needsProcessing = json['needs_processing'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModifiedGmt = json['date_modified_gmt'];
    // dateCompletedGmt = json['date_completed_gmt'];
    datePaidGmt = json['date_paid_gmt'];
    currencySymbol = json['currency_symbol'];
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
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
    // data['date_completed'] = dateCompleted;
    data['date_paid'] = datePaid;
    data['cart_hash'] = cartHash;
    data['number'] = number;
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    // if (taxLines != null) {
    //   data['tax_lines'] = taxLines!.map((v) => v.toJson()).toList();
    // }
    // if (shippingLines != null) {
    //   data['shipping_lines'] =
    //       shippingLines!.map((v) => v.toJson()).toList();
    // }
    // if (feeLines != null) {
    //   data['fee_lines'] = feeLines!.map((v) => v.toJson()).toList();
    // }
    if (couponLines != null) {
      data['coupon_lines'] = couponLines!.map((v) => v.toJson()).toList();
    }
    // if (refunds != null) {
    //   data['refunds'] = refunds!.map((v) => v.toJson()).toList();
    // }
    data['payment_url'] = paymentUrl;
    data['is_editable'] = isEditable;
    data['needs_payment'] = needsPayment;
    data['needs_processing'] = needsProcessing;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified_gmt'] = dateModifiedGmt;
    // data['date_completed_gmt'] = dateCompletedGmt;
    data['date_paid_gmt'] = datePaidGmt;
    data['currency_symbol'] = currencySymbol;
    if (lLinks != null) {
      data['_links'] = lLinks!.toJson();
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
  // List<Null>? taxes;
  List<MetaData>? metaData;
  dynamic sku;
  dynamic price;
  Imagess? image;
  // Null? parentName;

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
        this.metaData,
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
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    sku = json['sku'];
    price = json['price'];
    image = json['image'] != null ? Imagess.fromJson(json['image']) : null;
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
    // if (taxes != null) {
    //   data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    // }
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    data['sku'] = sku;
    data['price'] = price;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    // data['parent_name'] = parentName;
    return data;
  }
}

// class MetaData {
//   dynamic id;
//   dynamic key;
//   List<Value>? value;
//   dynamic displayKey;
//   // List<DisplayValue>? displayValue;
//
//   MetaData({this.id, this.key, this.value, this.displayKey, this.displayValue});
//
//   MetaData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     key = json['key'];
//     if (json['value'] != null) {
//       value = <Value>[];
//       json['value'].forEach((v) {
//         value!.add(Value.fromJson(v));
//       });
//     }
//     displayKey = json['display_key'];
//     if (json['display_value'] != null) {
//       displayValue = <DisplayValue>[];
//       json['display_value'].forEach((v) {
//         displayValue!.add(DisplayValue.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['key'] = key;
//     if (value != null) {
//       data['value'] = value!.map((v) => v.toJson()).toList();
//     }
//     data['display_key'] = this.displayKey;
//     if (this.displayValue != null) {
//       data['display_value'] =
//           this.displayValue!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Value {
  // List<Null>? tmcpPostFields;
  dynamic productId;
  bool? perProductPricing;
  bool? cpfProductPrice;
  bool? variationId;
  dynamic formPrefix;
  dynamic tcAddedInCurrency;
  dynamic tcDefaultCurrency;

  Value(
      {
        // this.tmcpPostFields,
        this.productId,
        this.perProductPricing,
        this.cpfProductPrice,
        this.variationId,
        this.formPrefix,
        this.tcAddedInCurrency,
        this.tcDefaultCurrency});

  Value.fromJson(Map<String, dynamic> json) {
    // if (json['tmcp_post_fields'] != null) {
    //   tmcpPostFields = <Null>[];
    //   json['tmcp_post_fields'].forEach((v) {
    //     tmcpPostFields!.add(Null.fromJson(v));
    //   });
    // }
    productId = json['product_id'];
    perProductPricing = json['per_product_pricing'];
    cpfProductPrice = json['cpf_product_price'];
    variationId = json['variation_id'];
    formPrefix = json['form_prefix'];
    tcAddedInCurrency = json['tc_added_in_currency'];
    tcDefaultCurrency = json['tc_default_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (tmcpPostFields != null) {
    //   data['tmcp_post_fields'] =
    //       tmcpPostFields!.map((v) => v.toJson()).toList();
    // }
    data['product_id'] = productId;
    data['per_product_pricing'] = perProductPricing;
    data['cpf_product_price'] = cpfProductPrice;
    data['variation_id'] = variationId;
    data['form_prefix'] = formPrefix;
    data['tc_added_in_currency'] = tcAddedInCurrency;
    data['tc_default_currency'] = tcDefaultCurrency;
    return data;
  }
}

class Imagess {
  dynamic id;
  dynamic src;

  Imagess({this.id, this.src});

  Imagess.fromJson(Map<String, dynamic> json) {
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

class CouponLines {
  dynamic id;
  dynamic code;
  dynamic discount;
  dynamic discountTax;
  // List<Null>? metaData;

  CouponLines(
      {this.id, this.code, this.discount, this.discountTax,
        // this.metaData
      });

  CouponLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    discount = json['discount'];
    discountTax = json['discount_tax'];
    // if (json['meta_data'] != null) {
    //   metaData = <Null>[];
    //   json['meta_data'].forEach((v) {
    //     metaData!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['discount'] = discount;
    data['discount_tax'] = discountTax;
    // if (metaData != null) {
    //   data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Links {
  List<Self>? self;
  // List<Collection>? collection;
  // List<Customer>? customer;

  Links({this.self,
    // this.collection,
    // this.customer
  });

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(Self.fromJson(v));
      });
    }
    // if (json['collection'] != null) {
    //   collection = <Collection>[];
    //   json['collection'].forEach((v) {
    //     collection!.add(Collection.fromJson(v));
    //   });
    // }
    // if (json['customer'] != null) {
    //   customer = <Customer>[];
    //   json['customer'].forEach((v) {
    //     customer!.add(Customer.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data['self'] = self!.map((v) => v.toJson()).toList();
    }
    // if (collection != null) {
    //   data['collection'] = collection!.map((v) => v.toJson()).toList();
    // }
    // if (customer != null) {
    //   data['customer'] = customer!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Self {
  dynamic href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}
