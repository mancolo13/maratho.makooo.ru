import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/quiz_models.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';

/// Unique MarathonBet Daily Sports Arena & Fan Express Hub
class DailyChallengesTab extends StatelessWidget {
  const DailyChallengesTab({super.key});

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'spellcheck':
        return Icons.spellcheck_rounded;
      case 'verified':
        return Icons.verified_rounded;
      default:
        return Icons.sports_soccer_rounded;
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

    final challenges = bundle.dailyChallenges;
    final completedCount = challenges.where((c) => provider.isChallengeCompleted(c.id)).length;
    final expressProgress = challenges.isNotEmpty ? (completedCount / challenges.length) : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Live Clock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Марафон Дейли',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Календарь матчей и испытания болельщика',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: AppTheme.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '24 ч',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 1. Interactive Football Pitch Track (7-Day Matchday Circuit)
              _buildFootballPitchTrack(context, provider),

              const SizedBox(height: 16),

              // 2. Daily Stadium Ticket Check-in Stub
              _buildTicketCheckInStub(context, provider),

              const SizedBox(height: 16),

              // 3. Daily Express Accumulator Card
              _buildExpressAccumulatorCard(context, completedCount, challenges.length, expressProgress),

              const SizedBox(height: 20),

              // 4. Missions Section Header
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
                        'ЛИСТ ЗАДАНИЙ ДНЯ',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$completedCount из ${challenges.length} готово',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: completedCount == challenges.length
                          ? const Color(0xFF00C853)
                          : AppTheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 5. Challenges List with Athletic Mission Slip Styling
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: challenges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return _buildChallengeCard(context, challenge, provider);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Interactive Football Pitch 7-day track
  Widget _buildFootballPitchTrack(BuildContext context, LoyaltyProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.marathonNavyGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00C853).withAlpha(100), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853).withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.sports_soccer_rounded,
                  color: Color(0xFF00C853),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'СТАДИОННЫЙ МАРШРУТ • СЕРИЯ ВХОДОВ',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00C853),
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '${provider.streakDays} дней в игре без пропусков!',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 7-day checkpoints
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(7, (i) {
                final dayNum = i + 1;
                final isPassed = dayNum <= provider.streakDays;
                final isToday = dayNum == provider.streakDays;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? AppTheme.accentGold.withAlpha(30)
                        : AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday
                          ? AppTheme.accentGold
                          : (isPassed
                              ? AppTheme.accentGold.withAlpha(120)
                              : AppTheme.surfaceBorder),
                      width: isToday ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ДЕНЬ $dayNum',
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: isPassed ? AppTheme.accentGold : AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        isPassed ? Icons.sports_soccer_rounded : Icons.lock_outline_rounded,
                        size: 16,
                        color: isPassed ? AppTheme.accentGold : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPassed ? 'ПРОЙДЕН' : '+${50 + dayNum * 10}',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isPassed ? const Color(0xFF00C853) : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Ticket Stub Check-in Banner
  Widget _buildTicketCheckInStub(BuildContext context, LoyaltyProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.marathonNavyGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(30),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.confirmation_number_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'МАТЧ-ДЕЙ БИЛЕТ',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  provider.dailyBonusClaimed ? 'Билет уже активирован' : 'Ежедневный бонус готов!',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '+100 баллов лояльности • +50 XP',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: provider.dailyBonusClaimed
                ? null
                : () {
                    provider.claimDailyBonus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.surfaceCard,
                        content: Text(
                          '🎉 Ежедневный бонус получен: +100 баллов, +50 XP!',
                          style: GoogleFonts.inter(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              provider.dailyBonusClaimed ? 'Забран' : 'Забрать',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Accumulator / Super Express Card
  Widget _buildExpressAccumulatorCard(
    BuildContext context,
    int completedCount,
    int totalCount,
    double progress,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentGold.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'СУПЕР-ЭКСПРЕСС ДНЯ',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accentGold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'КОЭФФ 3.0',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Закрой все события дня в экспрессе, чтобы забрать максимальную прибавку к рангу!',
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }

  /// Individual Challenge Slip
  Widget _buildChallengeCard(
    BuildContext context,
    DailyChallenge challenge,
    LoyaltyProvider provider,
  ) {
    final isCompleted = provider.isChallengeCompleted(challenge.id);
    final isClaimed = provider.isChallengeClaimed(challenge.id);
    final progress = provider.getChallengeProgress(challenge.id);
    final progressRatio = (progress / challenge.target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF00C853).withAlpha(90)
              : AppTheme.surfaceBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: (isCompleted ? const Color(0xFF00C853) : AppTheme.secondary).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _resolveIcon(challenge.icon),
                  color: isCompleted ? const Color(0xFF00C853) : AppTheme.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      challenge.description,
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress & Rewards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Прогресс: $progress / ${challenge.target}',
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text('+${challenge.xpReward} XP', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.secondary, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('+${challenge.coinsReward} ⚽', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.accentGold, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progressRatio,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? const Color(0xFF00C853) : AppTheme.primary,
              ),
              minHeight: 5,
            ),
          ),

          const SizedBox(height: 12),

          // Claim or Status
          SizedBox(
            width: double.infinity,
            child: isClaimed
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF00C853)),
                        const SizedBox(width: 6),
                        Text(
                          'Награда получена',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF00C853)),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: isCompleted
                        ? () {
                            provider.claimDailyChallenge(challenge);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppTheme.surfaceCard,
                                content: Text(
                                  '🏆 Награда получена: +${challenge.coinsReward} баллов, +${challenge.xpReward} XP!',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF00C853),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? const Color(0xFF00C853) : AppTheme.surfaceBorder,
                      foregroundColor: isCompleted ? Colors.white : AppTheme.textMuted,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isCompleted ? 'Забрать награду' : 'В процессе выполнения',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
