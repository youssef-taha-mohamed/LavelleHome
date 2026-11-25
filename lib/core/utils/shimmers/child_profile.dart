import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// لون العناصر داخل الشيمر
const Color _shimmerItemColor = Color(0xFFE0E0E0);

class ChildProfileShimmer extends StatelessWidget {
  const ChildProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 16,
          children: [
            _buildAppBarShimmer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 24,
                  children: [
                    _buildHeaderCardShimmer(),
                    _buildProfileDetailsShimmer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  //       APP BAR SHIMMER
  // --------------------------
  Widget _buildAppBarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        decoration: BoxDecoration(
          color: Colors.transparent, // ✔ منع تغطية الشيمر
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة البروفايل
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: _shimmerItemColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),

            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _shimmerItemColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 13,
                    decoration: BoxDecoration(
                      color: _shimmerItemColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            // أيقونة الترايلينج
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _shimmerItemColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  //       HEADER CARD SHIMMER
  // --------------------------
  Widget _buildHeaderCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent, // ✔ منع التغطية
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          spacing: 8,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: _shimmerItemColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: _shimmerItemColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: _shimmerItemColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  //     PROFILE DETAILS SHIMMER
  // --------------------------
  Widget _buildProfileDetailsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDetailRowShimmer(),
            _buildDetailRowShimmer(),
            _buildDetailRowShimmer(),
            _buildDetailRowShimmer(),
            _buildDetailRowShimmer(isLast: true),
          ],
        ),
      ),
    );
  }

  // --------------------------
  //     ROW ITEM SHIMMER
  // --------------------------
  Widget _buildDetailRowShimmer({bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        spacing: 16,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _shimmerItemColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _shimmerItemColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 15,
                  decoration: BoxDecoration(
                    color: _shimmerItemColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
