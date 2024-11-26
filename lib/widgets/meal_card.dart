import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:campus_dining_web/widgets/add_meal._dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MealCard extends StatelessWidget {
  final String mealId;
  final String name;
  final String description;
  final String photoUrl;
  final String price;
  final bool isHidden;

  const MealCard({
    super.key,
    required this.mealId,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.price,
    required this.isHidden,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.45;
        double cardHeight = cardWidth * 1.2;
        double imageHeight = cardHeight * 0.65;
        double fontSize = cardWidth > 250 ? 18 : 16;
        double iconSize = cardWidth > 250 ? 22 : 18;

        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => context.go('/item_details/$mealId'),
                      tooltip: "See details",
                      icon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
              ),
              // Middle Section
              Image.network(
                photoUrl,
                height: imageHeight,
                fit: screenWidth > 600 ? BoxFit.contain : BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddMealDialog(
                              mealId: mealId,
                              name: name,
                              description: description,
                              price: price,
                              photoUrl: photoUrl,
                              isHidden: isHidden,
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: iconSize,
                      ),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: () {
                        // print('delete food');
                      },
                      icon: Icon(
                        Icons.delete,
                        size: iconSize,
                      ),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
