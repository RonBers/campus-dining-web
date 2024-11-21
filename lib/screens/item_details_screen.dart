import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dashboard', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Center(
        child: Container(
          height: 700,
          width: 1200,
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black, width: 2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'assets/img/beefOntamaBukakeUdon.png',
                height: 350,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Beef Ontama Bukake Udon",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Flavorful Bukkake sauce, topped with thinly-sliced sauteed beef and half-boiled egg.",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Php 210.00",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
