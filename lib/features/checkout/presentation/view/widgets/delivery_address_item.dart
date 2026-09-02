import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryAddressItem extends StatefulWidget {
  const DeliveryAddressItem({super.key});

  @override
  State<DeliveryAddressItem> createState() => _DeliveryAddressItemState();
}

class _DeliveryAddressItemState extends State<DeliveryAddressItem> {
  @override
  Widget build(BuildContext context) {
    String? _deliveryTime = 'standard';
  
    return Container(
  
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white90.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: 'standard',
                        groupValue: _deliveryTime,
                        onChanged: (value) {
                          setState(() {
                            _deliveryTime = value;
                          });
                        },
                      ),
                      Text("Home"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("2XVP+XC - Sheikh Zayed"),
                  ),
                ],
              ),
            ],
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.edit))
        ],
      ),
    );
  }
}
