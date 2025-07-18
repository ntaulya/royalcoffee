import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../../../../models/CheckOut/ItemProduct.dart';
import '../../../../../services/Api/ImageHelper.dart';

typedef OnDeleteCallback = void Function();

Widget buildProductItem(ItemProduct item, OnDeleteCallback onDelete) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        FutureBuilder<Uint8List?>(
          future: (item.image != null && item.image!.isNotEmpty)
              ? ImageHelper.loadImage(item.image!)
              : Future.value(null),
          builder: (context, snapshot) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: snapshot.hasData
                  ? Image.memory(snapshot.data!, width: 50, height: 50, fit: BoxFit.cover)
                  : Container(width: 50, height: 50, color: Colors.grey),
            );
          },
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(item.nama_product  + ' - ' + item.nama_varian)),
        Text('${item.qty}x', style: const TextStyle(color: Colors.grey)),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    ),
  );
}
