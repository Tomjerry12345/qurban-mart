import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    required this.price,
    required this.weight,
    required this.age,
    required this.press,
  });
  final String image, category, title;
  final int? price, weight;
  final int? age;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.decimalPattern('id');

    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 220),
        maximumSize: const Size(140, 220),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
                Positioned(
                  right: defaultPadding / 2,
                  top: defaultPadding / 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    height: 16,
                    decoration: const BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadious)),
                    ),
                    child: Text(
                      "$weight kg",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10),
                      ),
                      const Spacer(),
                      Text(
                        "$age tahun",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 1),
                  Text(
                    "$title",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "Rp. ${currencyFormat.format(price)}",
                        style: const TextStyle(
                          color: Color(0xFF31B0D8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
