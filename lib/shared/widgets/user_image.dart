import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/resources/svg.dart';
import '../../core/style/app_colors.dart';
import '../../feature/user/domain/entities/user_details.dart';

class UserImage extends StatelessWidget {
  const UserImage({required this.user, super.key});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    final url = user?.image;
    return Container(
      constraints: const BoxConstraints.expand(height: 50.0, width: 50.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.color6,
      ),
      child: user == null
          ? SvgPicture.asset(SvgAssets.notAuthUser, height: 30.0, width: 30.0)
          : url == null
          ? SvgPicture.asset(
              SvgAssets.user,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 30.0,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(81.0),
              child: Image.network(
                url,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
