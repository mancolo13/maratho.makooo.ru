import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';

/// Unique MarathonBet Fan Passport & RPL Hall of Fame
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoyaltyProvider>();
    final bundle = provider.bundle;

    if (provider.isLoading || bundle == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    final currentRank = provider.currentRank;
    final nextRank = provider.nextRank;
    final achievements = bundle.achievements;
    final allRanks = bundle.ranks;

    final double progress = nextRank == null
        ? 1.0
        : ((provider.xp - currentRank.requiredXp) /
                (nextRank.requiredXp - currentRank.requiredXp))
            .clamp(0.0, 1.0);

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
                'Паспорт Болельщика',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Личный кабинет, аналитика матчей и зал славы Лиги',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // 1. Official Accreditation Badge (Fan ID Card)
              _buildFanPassportCard(context, provider, currentRank, nextRank, progress),

              const SizedBox(height: 20),

              // 2. Tactical Performance & Match Analytics Matrix
              _buildTacticalAnalytics(context, provider),

              const SizedBox(height: 20),

              // 3. League Standings Ladder (Таблица Рангов РПЛ)
              _buildLeagueLadder(context, allRanks, currentRank.level),

              const SizedBox(height: 20),

              // 4. Hall of Fame (Зал Славы и Достижения)
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
                        'ЗАЛ СЛАВЫ • ДОСТИЖЕНИЯ',
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
                    '${achievements.length} трофеев',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Achievements List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: achievements.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final ach = achievements[index];
                  bool isUnlocked = false;
                  if (ach.id == 'ach_first_win' && provider.completedQuizzes >= 1) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_streak_3' && provider.streakDays >= 3) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_points_1000' && provider.xp >= 1000) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_words_5' && provider.getChallengeProgress('dc_3') >= 2) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_shop_buyer' && provider.unlockedRewards.isNotEmpty) {
                    isUnlocked = true;
                  }

                  return _buildAchievementTile(context, ach, isUnlocked);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Official Fan Passport Accreditation Card
  Widget _buildFanPassportCard(
    BuildContext context,
    LoyaltyProvider provider,
    dynamic currentRank,
    dynamic nextRank,
    double progress,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surfaceCard,
            content: Text(
              '🪪 Fan ID верифицирован в Матч-Центре РПЛ! Ваш текущий уровень: ${currentRank.level} («${currentRank.title}»).',
              style: GoogleFonts.inter(
                color: const Color(0xFF00C853),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppTheme.marathonNavyGradient,
          borderRadius: BorderRadius.circular(22),
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
          // Accreditation Top Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard.withAlpha(160),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: AppTheme.surfaceBorder.withAlpha(90))),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF00C853)),
                const SizedBox(width: 6),
                Text(
                  'FAN ID #RPL-${1042 + provider.xp} • ВЕРИФИЦИРОВАН',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF00C853),
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Text(
                  'МАРАФОН',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar Badge
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: AppTheme.redGlow,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        currentRank.badge,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentRank.title,
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Уровень ${currentRank.level} Лиги • ${provider.xp} XP',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Level Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nextRank != null
                          ? 'До ранга «${nextRank.title}»'
                          : 'Максимальный статус достигнут!',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                    if (nextRank != null)
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.surface,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  /// Tactical Performance Sheet & Analytics Matrix
  Widget _buildTacticalAnalytics(BuildContext context, LoyaltyProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'МАТЧЕВАЯ АНАЛИТИКА',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              const Icon(Icons.analytics_rounded, size: 16, color: AppTheme.secondary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricTile(
                context,
                'Матчей сыграно',
                '${provider.completedQuizzes}',
                Icons.sports_soccer_rounded,
                AppTheme.primary,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                'Точность ответов',
                '${provider.accuracyRate.toInt()}%',
                Icons.gps_fixed_rounded,
                const Color(0xFF00C853),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMetricTile(
                context,
                'Серия дней',
                '${provider.streakDays}',
                Icons.local_fire_department_rounded,
                AppTheme.accentGold,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                'Баллов в банке',
                '${provider.coins}',
                Icons.account_balance_wallet_rounded,
                AppTheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.surfaceCard,
              content: Text(
                '📊 $label: $value',
                style: GoogleFonts.inter(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(40)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// League Ladder Standings (Турнирная Таблица Рангов)
  Widget _buildLeagueLadder(BuildContext context, List<dynamic> ranks, int userLevel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_list_numbered_rounded, size: 16, color: AppTheme.accentGold),
              const SizedBox(width: 6),
              Text(
                'ТУРНИРНАЯ ТАБЛИЦА РАНГОВ',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: ranks.map((rank) {
              final isCurrent = rank.level == userLevel;
              return InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppTheme.surfaceCard,
                      content: Text(
                        '${rank.badge} Ранг #${rank.level} «${rank.title}»: бонус x${rank.bonusMultiplier}, требуется ${rank.requiredXp} XP',
                        style: GoogleFonts.inter(
                          color: isCurrent ? AppTheme.primary : AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppTheme.primary.withAlpha(25) : AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCurrent ? AppTheme.primary : AppTheme.surfaceBorder.withAlpha(50),
                      width: isCurrent ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${rank.level}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isCurrent ? AppTheme.primary : AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(rank.badge, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rank.title,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent ? Colors.white : AppTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'x${rank.bonusMultiplier}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? AppTheme.accentGold : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Single Achievement Card
  Widget _buildAchievementTile(BuildContext context, dynamic ach, bool isUnlocked) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surfaceCard,
            content: Text(
              isUnlocked
                  ? '🏆 Достижение «${ach.title}» разблокировано! ${ach.description}'
                  : '🔒 Достижение «${ach.title}»: ${ach.description}',
              style: GoogleFonts.inter(
                color: isUnlocked ? AppTheme.accentGold : AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnlocked
                ? AppTheme.accentGold.withAlpha(80)
                : AppTheme.surfaceBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isUnlocked ? AppTheme.accentGold : AppTheme.surfaceBorder).withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                color: isUnlocked ? AppTheme.accentGold : AppTheme.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ach.title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ach.description,
                    style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Открыто',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
