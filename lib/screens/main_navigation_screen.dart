import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/loyalty_provider.dart';
import '../services/local_notification_service.dart';
import '../theme/app_theme.dart';
import 'tabs/daily_challenges_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/quizzes_tab.dart';
import 'tabs/rewards_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _tabs = const [
    QuizzesTab(),
    DailyChallengesTab(),
    RewardsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Prompt for notification permission cleanly after UI is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationService.instance.requestPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoyaltyProvider>();
    final currentRank = provider.currentRank;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 12,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // MarathonBet Signature Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.marathonRed,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: AppTheme.redGlow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sports_soccer_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'МАРАФОН',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'МАТЧ-ЦЕНТР',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Fire streak chip
          FittedBox(
            fit: BoxFit.scaleDown,
            child: InkWell(
              onTap: () => setState(() => _currentIndex = 1),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentRose.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentRose.withAlpha(70)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppTheme.accentRose,
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${provider.streakDays}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentRose,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Coins chip
          FittedBox(
            fit: BoxFit.scaleDown,
            child: InkWell(
              onTap: () => setState(() => _currentIndex = 2),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentGold.withAlpha(70)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentRank.badge,
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${provider.coins}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          selectedLabelStyle: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer_rounded),
              activeIcon: Icon(Icons.sports_soccer_rounded),
              label: 'Квизы',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_outlined),
              activeIcon: Icon(Icons.local_fire_department_rounded),
              label: 'Дейли',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard_rounded),
              label: 'Награды',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
