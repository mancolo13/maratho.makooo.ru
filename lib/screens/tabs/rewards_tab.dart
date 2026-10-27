import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/quiz_models.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';

/// Unique MarathonBet Fan Shop & Digital Fan Card
class RewardsTab extends StatefulWidget {
  const RewardsTab({super.key});

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = const [
    'Все Лоты',
    'Усилители',
    'Билеты',
    'Трофеи',
    'Инвентарь',
  ];

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'confirmation_number':
        return Icons.confirmation_number_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'palette':
        return Icons.palette_rounded;
      default:
        return Icons.card_giftcard_rounded;
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

    final allRewards = bundle.rewards;

    // Filter items
    List<LoyaltyReward> displayedRewards = allRewards;
    if (_selectedCategoryIndex == 1) {
      displayedRewards = allRewards.where((r) => r.category.toLowerCase().contains('усилитель') || r.category.toLowerCase().contains('расходник')).toList();
    } else if (_selectedCategoryIndex == 2) {
      displayedRewards = allRewards.where((r) => r.category.toLowerCase().contains('эксклюзив') || r.category.toLowerCase().contains('билет') || r.category.toLowerCase().contains('статус')).toList();
    } else if (_selectedCategoryIndex == 3) {
      displayedRewards = allRewards.where((r) => r.category.toLowerCase().contains('трофей') || r.category.toLowerCase().contains('оформление')).toList();
    } else if (_selectedCategoryIndex == 4) {
      // Inventory: only purchased items
      displayedRewards = allRewards.where((r) => provider.isRewardPurchased(r.id)).toList();
    }
    if (displayedRewards.isEmpty && _selectedCategoryIndex != 4) {
      displayedRewards = allRewards;
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
              // Header
              Text(
                'Фан-Шоп & Награды',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Обменивай баллы матч-центра на эксклюзивные привилегии',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // 1. Digital VIP Fan Card (Realistic Debit/Membership Card)
              _buildDigitalFanCard(context, provider),

              const SizedBox(height: 18),

              // 2. Filter Category Pills
              _buildCategoryPills(),

              const SizedBox(height: 16),

              // 3. Section Title & Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppTheme.marathonRed,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedCategoryIndex == 4 ? 'МОЙ ИНВЕНТАРЬ' : 'ВИТРИНА ФАН-ШОПА',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${displayedRewards.length} лотов',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 4. Products Grid or Empty State
              if (displayedRewards.isEmpty && _selectedCategoryIndex == 4)
                _buildEmptyInventoryState()
              else
                _buildProductsGrid(context, displayedRewards, provider),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Digital Fan Card with EMV Chip & Metallic Finish
  Widget _buildDigitalFanCard(BuildContext context, LoyaltyProvider provider) {
    final currentRank = provider.currentRank;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.marathonNavyGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.primary.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Club Brand & Contactless
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.marathonRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'МАРАФОН',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FAN CLUB PASS',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.contactless_rounded, color: Colors.white70, size: 22),
            ],
          ),

          const SizedBox(height: 16),

          // Chip & Balance
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Golden Chip
              Container(
                width: 38,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withAlpha(60),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.accentGold, width: 1.5),
                ),
                child: const Icon(Icons.memory_rounded, size: 16, color: AppTheme.accentGold),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'БАЛАНС БОЛЕЛЬЩИКА',
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${provider.coins}',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('⚽', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom Row: Holder & Tier
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'СТАТУС КАРТЫ',
                    style: GoogleFonts.outfit(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    currentRank.title.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGold.withAlpha(90)),
                ),
                child: Text(
                  'МНОЖИТЕЛЬ x${currentRank.bonusMultiplier}',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accentGold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Category Filter Pills
  Widget _buildCategoryPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
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
                  _categories[index],
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

  /// 2-Column Responsive Products Grid
  Widget _buildProductsGrid(
    BuildContext context,
    List<LoyaltyReward> rewards,
    LoyaltyProvider provider,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final isPurchased = provider.isRewardPurchased(reward.id);
        final canAfford = provider.coins >= reward.cost;
        final rewardColor = _resolveColor(reward.colorHex);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPurchased
                  ? const Color(0xFF00C853).withAlpha(90)
                  : AppTheme.surfaceBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge & Category Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: rewardColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _resolveIcon(reward.icon),
                      color: rewardColor,
                      size: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      reward.category,
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                reward.title,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Text(
                  reward.description,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              // Price Tag
              Row(
                children: [
                  const Icon(Icons.sports_soccer_rounded, size: 14, color: AppTheme.accentGold),
                  const SizedBox(width: 4),
                  Text(
                    '${reward.cost}',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: isPurchased
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00C853).withAlpha(80)),
                        ),
                        child: Text(
                          'В инвентаре',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00C853),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: canAfford
                            ? () {
                                final success = provider.purchaseReward(reward);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTheme.surfaceCard,
                                      content: Text(
                                        '🎉 «${reward.title}» успешно приобретено!',
                                        style: GoogleFonts.inter(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAfford ? AppTheme.primary : AppTheme.surfaceBorder,
                          foregroundColor: canAfford ? Colors.white : AppTheme.textMuted,
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          canAfford ? 'Купить' : 'Мало баллов',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Empty Inventory Placeholder
  Widget _buildEmptyInventoryState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'Инвентарь пока пуст',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Проходи викторины, зарабатывай баллы лояльности и приобретай эксклюзивные лоты!',
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
