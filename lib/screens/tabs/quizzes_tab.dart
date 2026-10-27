import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/quiz_models.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';
import '../quiz_play_screen.dart';
import '../true_false_screen.dart';
import '../word_puzzle_screen.dart';

/// Unique MarathonBet Match-Center & RPL Quiz Hub
class QuizzesTab extends StatefulWidget {
  const QuizzesTab({super.key});

  @override
  State<QuizzesTab> createState() => _QuizzesTabState();
}

class _QuizzesTabState extends State<QuizzesTab> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'Все Квизы',
    'Клубы & Арены',
    'Легенды',
    'Рекорды',
    'Тактика',
  ];

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'stadium':
        return Icons.stadium_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'analytics':
        return Icons.analytics_rounded;
      case 'spellcheck':
        return Icons.spellcheck_rounded;
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      default:
        return Icons.sports_soccer_rounded;
    }
  }

  Color _resolveColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoyaltyProvider>();
    final bundle = provider.bundle;

    if (provider.isLoading || bundle == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    final categories = bundle.categories;

    // Filter categories based on selected tab
    List<QuizCategory> filteredCategories = categories;
    if (_selectedFilterIndex == 1) {
      filteredCategories = categories.where((c) => c.id.contains('club') || c.id.contains('arena')).toList();
    } else if (_selectedFilterIndex == 2) {
      filteredCategories = categories.where((c) => c.id.contains('star') || c.id.contains('legend')).toList();
    } else if (_selectedFilterIndex == 3) {
      filteredCategories = categories.where((c) => c.id.contains('record') || c.id.contains('history')).toList();
    } else if (_selectedFilterIndex == 4) {
      filteredCategories = categories.where((c) => c.id.contains('tactic') || c.id.contains('match')).toList();
    }
    if (filteredCategories.isEmpty) {
      filteredCategories = categories;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Live Match-Center Stories / Matchday Ticker
              _buildLiveMatchTicker(context, bundle),

              const SizedBox(height: 14),

              // 2. Central Derby Match Duel Card (Authentic Marathon Matchboard)
              _buildCentralMatchDuelCard(context, categories, provider),

              const SizedBox(height: 18),

              // 3. Special Formats (Dual Sportsbook Arena: Word Puzzle & True/False)
              _buildSpecialModesGrid(context, bundle, categories),

              const SizedBox(height: 20),

              // 4. Interactive Sportsbook Filter Pills
              _buildFilterChips(),

              const SizedBox(height: 14),

              // 5. Section Header with Odds Multiplier Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'МАТЧЕВЫЕ ВИКТОРИНЫ',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      '${filteredCategories.length} матчей',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 6. Athletic Match-Slip Category Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cat = filteredCategories[index];
                  return _buildMatchSlipCard(context, cat);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Horizontal Live Matchday Ticker
  Widget _buildLiveMatchTicker(BuildContext context, dynamic bundle) {
    final tickerItems = [
      {'title': 'ДЕРБИ ДНЯ', 'subtitle': 'Спартак - Зенит', 'color': AppTheme.marathonRed, 'icon': Icons.local_fire_department_rounded},
      {'title': 'ТУР 19', 'subtitle': 'Клубы & Арены', 'color': AppTheme.secondary, 'icon': Icons.stadium_rounded},
      {'title': 'ТОП БОМБАРДИРЫ', 'subtitle': 'История РПЛ', 'color': AppTheme.accentGold, 'icon': Icons.emoji_events_rounded},
      {'title': 'СЛОВО-СПРИНТ', 'subtitle': 'Термины Лиги', 'color': const Color(0xFF00C853), 'icon': Icons.spellcheck_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tickerItems.map((item) {
          final color = item['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withAlpha(90)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item['icon'] as IconData, color: color, size: 16),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['title'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: color,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      item['subtitle'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Authentic Central Match Duel Card (Stadium Scoreboard Style)
  Widget _buildCentralMatchDuelCard(
    BuildContext context,
    List<QuizCategory> categories,
    LoyaltyProvider provider,
  ) {
    final firstCat = categories.firstWhere(
      (c) => c.questions.isNotEmpty,
      orElse: () => categories.first,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.marathonNavyGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(30),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Matchday Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard.withAlpha(160),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border(
                bottom: BorderSide(color: AppTheme.surfaceBorder.withAlpha(80)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.marathonRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'МАТЧ-ЦЕНТР РПЛ • ЦЕНТРАЛЬНОЕ ДЕРБИ',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.accentGold.withAlpha(80)),
                  ),
                  child: Text(
                    'КОЭФФ x${provider.currentRank.bonusMultiplier}',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Duel Scoreboard Representation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Team 1
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppTheme.marathonRed.withAlpha(30),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.marathonRed, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔴', style: TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ФК «Спартак»',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '1.85',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // VS / League Emblem Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'VS',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'ТУР 19',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Team 2
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withAlpha(30),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.secondary, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔵', style: TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ФК «Зенит»',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '2.05',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  'Главная Битва Двух Столиц: ответь на вопросы истории и тактики дерби и забери +150 XP!',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 14),

                // Action Button: Marathon Red
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizPlayScreen(category: firstCat),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                    label: Text(
                      'ВЫЙТИ НА ПОЛЕ (ЭКСПРЕСС-МАТЧ)',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.marathonRed,
                      elevation: 4,
                      shadowColor: AppTheme.marathonRed.withAlpha(140),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Two Special Game Formats (Word Sprint & True/False)
  Widget _buildSpecialModesGrid(
    BuildContext context,
    dynamic bundle,
    List<QuizCategory> categories,
  ) {
    return Row(
      children: [
        // Mode 1: Word Sprint
        Expanded(
          child: InkWell(
            onTap: () {
              final wordCat = categories.firstWhere(
                (c) => c.words.isNotEmpty,
                orElse: () => categories.last,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WordPuzzleScreen(words: wordCat.words),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.secondary.withAlpha(90)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withAlpha(35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.spellcheck_rounded,
                          color: AppTheme.secondary,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'СЛОВА',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Словесный Спринт',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Собери термины РПЛ',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Mode 2: True / False Referee
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TrueFalseScreen(
                    facts: bundle.trueFalseFacts,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withAlpha(90)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '50 / 50',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Правда или Миф',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Факты и рекорды Лиги',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Horizontal Filter Chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                  ),
                ),
                child: Text(
                  _filters[index],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Athletic Match-Slip Category Card
  Widget _buildMatchSlipCard(BuildContext context, QuizCategory cat) {
    final isWordCategory = cat.words.isNotEmpty;
    final countLabel = isWordCategory
        ? '${cat.words.length} терминов'
        : '${cat.questions.length} вопросов';
    final catColor = _resolveColor(cat.colorHex);

    return InkWell(
      onTap: () {
        if (isWordCategory) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WordPuzzleScreen(words: cat.words),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QuizPlayScreen(category: cat),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: catColor.withAlpha(70)),
        ),
        child: Row(
          children: [
            // Category Avatar Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: catColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: catColor.withAlpha(80)),
              ),
              child: Icon(
                _resolveIcon(cat.icon),
                color: catColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cat.description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Match Center Badge & Play Action
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    countLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: catColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
