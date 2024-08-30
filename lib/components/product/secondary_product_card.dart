import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qurban_mart/models/cart_model.dart';
import 'package:qurban_mart/values/output_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class SecondaryProductCard extends StatelessWidget {
  const SecondaryProductCard({
    super.key,
    required this.data,
    this.press,
    this.style,
  });

  final Cart data;
  final VoidCallback? press;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.decimalPattern('id');

    Future<void> openWhatsAppOrCall(String phoneNumber, String message) async {
      final whatsappUrl = Uri.parse(
          'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      final phoneUrl = Uri.parse('tel:$phoneNumber');

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl, mode: LaunchMode.externalApplication);
      } else {
        logO('Could not launch WhatsApp or Phone');
      }
    }

    Future<void> openMaps(double latitude, double longitude) async {
      final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return OutlinedButton(
      onPressed: press,
      style: style ??
          OutlinedButton.styleFrom(
              minimumSize: const Size(256, 110),
              maximumSize: const Size(256, 110),
              padding: const EdgeInsets.all(8)),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(data.image.toString(),
                    radius: defaultBorderRadious),
              ],
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.kategori.toString().toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    data.nama.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp. ${currencyFormat.format(data.harga)}",
                        style: const TextStyle(
                          color: Color(0xFF31B0D8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 30,
                            child: IconButton(
                              icon: Icon(Icons.chat,
                                  size: 20, color: Colors.green),
                              onPressed: () {
                                openWhatsAppOrCall(data.noHp.toString(),
                                    'Halo, saya tertarik dengan produk ini.');
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                            child: IconButton(
                              icon: const Icon(Icons.location_on,
                                  size: 20, color: Colors.red),
                              onPressed: () {
                                if (data.lokasi != null) {
                                  openMaps(data.lokasi!.latitude,
                                      data.lokasi!.longitude);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
