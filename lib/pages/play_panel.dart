import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'playmodule1_page.dart';
import 'playmodule2_page.dart';
import 'playmodule3_page.dart';
import 'playmodule4_page.dart';
import 'playmodule5_page.dart';

// Same color palette and constants as dashboard_panel.dart
const String adminUid = 'QVyiObd7HoXTyNQaoxBzRSW0HGK2';
const List<String> moduleIds = [
  'module1',
  'module2',
  'module3',
  'module4',
  'module5',
];

// Custom color palette for System Integration & Architecture theme
const Color siaPrimary = Color(0xFF415A77);
const Color siaAccent = Color(0xFF778DA9);
const Color siaBackground = Color(0xFFF6F8FB);
const Color siaCard = Colors.white;
const Color siaShadow = Color(0x1A415A77);

class PlayPanel extends StatelessWidget {
  final VoidCallback? onBack;
  const PlayPanel({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user != null && user.uid == adminUid;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: siaBackground,
      child: Center(
        key: const ValueKey("play"),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 4 : 0,
              vertical: isMobile ? 4 : 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: siaCard,
                borderRadius: BorderRadius.circular(isMobile ? 16 : 30),
                boxShadow: [
                  BoxShadow(
                    color: siaShadow,
                    blurRadius: 28,
                    spreadRadius: 3,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: siaAccent.withOpacity(0.10),
                  width: 2,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 38,
                vertical: isMobile ? 22 : 38,
              ),
              child: _PlayPanelContent(onBack: onBack),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayPanelContent extends StatelessWidget {
  final VoidCallback? onBack;
  const _PlayPanelContent({this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final modules = [
      {
        "label": "Play Module 1",
        "page": const PlayModule1Page(),
      },
      {
        "label": "Play Module 2",
        "page": const PlayModule2Page(),
      },
      {
        "label": "Play Module 3",
        "page": const PlayModule3Page(),
      },
      {
        "label": "Play Module 4",
        "page": const PlayModule4Page(),
      },
      {
        "label": "Play Module 5",
        "page": const PlayModule5Page(),
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: siaPrimary),
                onPressed: onBack,
                tooltip: "Back",
              ),
            ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: siaPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: siaPrimary.withOpacity(0.13),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 15),
              Text(
                "Play Modules",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: siaPrimary,
                  fontSize: isMobile ? 22 : 28,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "System Integration & Architecture",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 13 : 17,
              color: siaAccent,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 18),
          ...List.generate(modules.length, (i) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 16),
              ),
              margin: EdgeInsets.only(
                bottom: isMobile ? 12 : 22,
                left: 0,
                right: 0,
              ),
              color: siaAccent.withOpacity(0.10),
              shadowColor: siaShadow,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 26.0,
                  vertical: isMobile ? 12 : 20.0,
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_esports,
                        color: siaPrimary, size: isMobile ? 24 : 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        modules[i]["label"] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 16 : 22,
                          color: siaPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 12 : 18,
                          horizontal: isMobile ? 18 : 28,
                        ),
                        textStyle: TextStyle(
                          fontSize: isMobile ? 14 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(isMobile ? 10 : 16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => modules[i]["page"] as Widget,
                          ),
                        );
                      },
                      child: const Text("Play"),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
