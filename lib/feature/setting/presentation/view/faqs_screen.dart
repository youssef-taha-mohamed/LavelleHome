import 'package:flutter/material.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../../shared/widgets/custom_header.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';

class FAQsScreen extends StatefulWidget {
  static const String routeName = '/faqs';

  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  int? _expandedIndex;
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FAQ> _getFAQs() {
    return [
      FAQ(
        question: context.l10n.faq_q1,
        answer: context.l10n.faq_a1,
        category: 'general',
      ),
      FAQ(
        question: context.l10n.faq_q2,
        answer: context.l10n.faq_a2,
        category: 'account',
      ),
      FAQ(
        question: context.l10n.faq_q3,
        answer: context.l10n.faq_a3,
        category: 'payment',
      ),
      FAQ(
        question: context.l10n.faq_q4,
        answer: context.l10n.faq_a4,
        category: 'payment',
      ),
      FAQ(
        question: context.l10n.faq_q5,
        answer: context.l10n.faq_a5,
        category: 'account',
      ),
      FAQ(
        question: context.l10n.faq_q6,
        answer: context.l10n.faq_a6,
        category: 'courses',
      ),
      FAQ(
        question: context.l10n.faq_q7,
        answer: context.l10n.faq_a7,
        category: 'technical',
      ),
      FAQ(
        question: context.l10n.faq_q8,
        answer: context.l10n.faq_a8,
        category: 'courses',
      ),
    ];
  }

  List<FAQ> get _filteredFAQs {
    var faqs = _getFAQs();

    // Filter by category
    if (_selectedCategory != 'all') {
      faqs = faqs.where((faq) => faq.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      faqs = faqs.where((faq) {
        return faq.question
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return faqs;
  }

  @override
  Widget build(BuildContext context) {
    final filteredFAQs = _filteredFAQs;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            CustomStudentHeader(
              title: context.l10n.faqs,
              subTitle: context.l10n.frequently_asked,
              showLeading: true,
              leadingIcon: Icons.arrow_forward_ios_outlined,
              onLeadingTap: () => Navigator.pop(context),
            ),
            16.ph,
            // Categories
            _buildCategories(),
            // FAQs List
            Expanded(
              child: filteredFAQs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredFAQs.length,
                      itemBuilder: (context, index) {
                        return _buildFAQCard(
                          faq: filteredFAQs[index],
                          index: index,
                          isExpanded: _expandedIndex == index,
                          onTap: () {
                            setState(() {
                              _expandedIndex =
                                  _expandedIndex == index ? null : index;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategories() {
    final categories = [
      {'id': 'all', 'label': context.l10n.all_categories},
      {'id': 'general', 'label': context.l10n.general},
      {'id': 'account', 'label': context.l10n.account},
      {'id': 'payment', 'label': context.l10n.payment},
      {'id': 'technical', 'label': context.l10n.technical},
      {'id': 'courses', 'label': context.l10n.courses},
    ];

    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => 8.pw,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category['id']!;
                _expandedIndex = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? MyColors.primaryColor
                    : (context.isDark ? const Color(0xFF1E1E1E) : Colors.white),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? MyColors.primaryColor
                      : (context.isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE8E8E8)),
                  width: 1,
                ),
              ),
              child: Center(
                child: MainText(
                  category['label']!,
                  fontSize: 13,
                  color: isSelected
                      ? Colors.white
                      : (context.isDark ? Colors.white70 : MyColors.textDark),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQCard({
    required FAQ faq,
    required int index,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 32,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: MainText.bigText(
                      faq.question,
                      fontSize: 14.5,
                      color: context.isDark ? Colors.white : MyColors.textDark,
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  10.pw,
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.isDark ? Colors.white60 : MyColors.grey4,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(34, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: context.isDark
                        ? const Color(0xFF252525)
                        : const Color(0xFFF0F0F0),
                  ),
                  MainText(
                    faq.answer,
                    fontSize: 13,
                    color: context.isDark ? Colors.white60 : MyColors.grey4,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: (context.isDark ? Colors.white : MyColors.grey4)
                .withValues(alpha: 0.3),
          ),
          16.ph,
          MainText.bigText(
            context.l10n.no_results,
            fontSize: 17,
            color: context.isDark ? Colors.white : MyColors.textDark,
          ),
          8.ph,
          MainText(
            context.l10n.no_results_desc,
            fontSize: 13,
            color: context.isDark ? Colors.white60 : MyColors.grey4,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;
  final String category;

  FAQ({
    required this.question,
    required this.answer,
    required this.category,
  });
}
