import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MealCard extends StatelessWidget {
  const MealCard({Key? key, String? title, String? imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '4.5',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber[300],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => context.go('/item_details'),
                  tooltip: "See details",
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Middle Section
          Image.asset(
            'assets/img/beefOntamaBukakeUdon.png',
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            height: 20,
          ),
          // Bottom Section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Food Name
                const Expanded(
                  child: Text(
                    'Beef Ontama Bukake Udon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Action Buttons
                IconButton(
                  onPressed: () {
                    print('edit food');
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () {
                    print('delete food');
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
