import 'package:admin_qurban_mart/values/output_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownButtonComponent extends StatelessWidget {
  const DropdownButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Expanded(
              child: Text(
                'Belum terjual',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: ["Test"]
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        // value: selectedValue,
        onChanged: (value) {
          logO(value);
        },
        iconStyleData: const IconStyleData(
          // icon: Icon(
          //   Icons.arrow_forward_ios_outlined,
          // ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        buttonStyleData: ButtonStyleData(
          height: 32,
          width: 144,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.red,
          ),
          elevation: 2,
        ),
        // dropdownStyleData: DropdownStyleData(
        //   maxHeight: 200,
        //   width: 200,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(14),
        //     color: Colors.redAccent,
        //   ),
        //   offset: const Offset(-20, 0),
        //   scrollbarTheme: ScrollbarThemeData(
        //     radius: const Radius.circular(40),
        //     thickness: MaterialStateProperty.all(6),
        //     thumbVisibility: MaterialStateProperty.all(true),
        //   ),
        // ),
        // menuItemStyleData: const MenuItemStyleData(
        //   height: 40,
        //   padding: EdgeInsets.only(left: 14, right: 14),
        // ),
      ),
    );
  }
}
