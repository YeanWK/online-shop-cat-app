import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../profile_page/address_page/address_book.dart';
import '../provider/address_provider.dart';
import '../provider/cart_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectValue = 0;
  int selectpayment = 0;

  List<String> payment = [
    'ชำระเงินผ่าน QR Code',
    'เก็บเงินปลายทาง',
    'บัตรเครดิต/เดบิต'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0, // กำหนดความสูงของเงา
        shadowColor: Colors.grey, // กำหนดสีของเงา
        iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
        toolbarHeight: 66,
        centerTitle: true,
        title: const Text(
          'ยืนยันคำสั่งซื้อ',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: bodyPayment(),
            ),
          ),
          buttonpayment()
        ],
      ),
    );
  }

  Widget bodyPayment() {
    return Column(
      children: [
        addresslist(),
        const Divider(
          height: 0,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 197, 197, 197),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 10),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcon(
                        PhosphorIcons.truck(),
                      ).icon,
                      size: 30,
                      // color: const Color(0xFFFF914D),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    const Text(
                      'วิธีการจัดส่ง',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    activeColor: Colors.orange,
                    title: const Text(
                      'ขนส่งภายในประเทศ KERRY EXPRESS',
                      style: TextStyle(fontSize: 16),
                    ),
                    value: 0,
                    groupValue: selectValue,
                    onChanged: (value) {
                      setState(() {
                        selectValue = index;
                        // reason = 'ขนส่งภายในประเทศ KERRY EXPRESS';
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 197, 197, 197),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 10),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcon(
                        PhosphorIcons.wallet(),
                      ).icon,
                      size: 30,
                      // color: const Color(0xFFFF914D),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    const Text(
                      'การชำระเงิน',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: payment.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    activeColor: Colors.orange,
                    title: Text(
                      payment[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    value: index,
                    groupValue: selectpayment,
                    onChanged: (value) {
                      setState(() {
                        selectpayment = index;
                        log(selectpayment.toString());
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 197, 197, 197),
        ),
        cartlist(),
        const Divider(
          height: 0,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 197, 197, 197),
        ),
      ],
    );
  }

  Widget addresslist() {
    var addressProvider = context.read<AddressProvider>();
    return InkWell(
        onTap: () {
          debugPrint('Card tapped');
        },
        child: addressProvider.addressdata.isNotEmpty
            ? Container(
                color: Colors.white,
                height: 160,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcon(
                              PhosphorIcons.truck(),
                            ).icon,
                            size: 30,
                            // color: const Color(0xFFFF914D),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          const Text(
                            'ที่อยู่สำหรับจัดส่ง',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 72),
                      child: Row(
                        children: [
                          Text(
                            addressProvider.addressdata[0]["first_name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            addressProvider.addressdata[0]["last_name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 72),
                      child: Row(
                        children: [
                          Text(
                            addressProvider.addressdata[0]["tellphone"],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 72),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${addressProvider.addressdata[0]["address"]}, ${addressProvider.addressdata[0]["province"]}, ${addressProvider.addressdata[0]["amphures"]}, ${addressProvider.addressdata[0]["tambons"]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 72),
                      child: Row(
                        children: [
                          Text(
                            addressProvider.addressdata[0]["zipcode"],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            : Container(
                color: Colors.white,
                height: 100,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcon(
                              PhosphorIcons.truck(),
                            ).icon,
                            size: 30,
                            // color: const Color(0xFFFF914D),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          const Text(
                            'ที่อยู่สำหรับจัดส่ง',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressBook()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'เพิ่มที่อยู่',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ));
  }

  Widget cartlist() {
    var cartListProvider = context.read<CartProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 10),
          child: Row(
            children: [
              Icon(
                PhosphorIcon(
                  PhosphorIcons.package(),
                ).icon,
                size: 30,
                // color: const Color(0xFFFF914D),
              ),
              const SizedBox(
                width: 18,
              ),
              const Text(
                'คำสั่งซื้อ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: cartListProvider.cartList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          cartListProvider.cartList[index]['pathImg'],
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartListProvider.cartList[index]['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cartListProvider.cartList[index]['price'],
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                    ' × ${cartListProvider.cartList[index]["unit"]}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1.5,
                    indent: 10,
                    endIndent: 10,
                    color: Color.fromARGB(255, 197, 197, 197),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget buttonpayment() {
    return Container(
      width: double.infinity,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const Text(
            "รวมทั้งหมด",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          const Text(
            "\u0E3F",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, provider, _) {
              return Text(
                provider.totalPrice.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              );
            },
          ),
          const Spacer(),
          Container(
            width: 120,
            height: 66,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFFFA500),
                Color(0xFFFF6347),
              ]),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                "สั่งสินค้า",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
