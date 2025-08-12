import 'package:flutter/material.dart';
import 'module1_page.dart';
import 'module2_page.dart';
import 'module3_page.dart';
import 'module4_page.dart';
import 'module5_page.dart';

const String adminUid = 'QVyiObd7HoXTyNQaoxBzRSW0HGK2';
// Demo: change to your Firebase logic if needed
bool get isAdmin => true; // Set to true for testing

const Color siaPrimary = Color(0xFF415A77);
const Color siaAccent = Color(0xFF778DA9);
const Color siaBackground = Color(0xFFF6F8FB);
const Color siaCard = Colors.white;
const Color siaShadow = Color(0x1A415A77);

class ModuleSheet extends StatefulWidget {
  final bool isDialog;
  final bool isStandalone;
  final VoidCallback? onBack;
  const ModuleSheet({
    super.key,
    this.isDialog = false,
    this.isStandalone = false,
    this.onBack,
  });

  @override
  State<ModuleSheet> createState() => _ModuleSheetState();
}

class _ModuleSheetState extends State<ModuleSheet> {
  final List<Widget Function()> _moduleBuilders = [
    () => Module1Page(),
    () => Module2Page(),
    () => Module3Page(),
    () => Module4Page(),
    () => Module5Page(),
  ];

  final List<String> _moduleNames = [
    'Module 1',
    'Module 2',
    'Module 3',
    'Module 4',
    'Module 5',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final maxWidth = 1200.0;

    final child = Container(
      decoration: BoxDecoration(
        color: siaCard,
        borderRadius: widget.isDialog
            ? const BorderRadius.horizontal(left: Radius.circular(24))
            : BorderRadius.circular(isMobile ? 16 : 30),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isStandalone && widget.onBack != null)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: siaPrimary),
                  onPressed: widget.onBack,
                  tooltip: "Back",
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: const Icon(Icons.menu_book,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Select a Module",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: siaPrimary,
                      fontSize: isMobile ? 22 : 28,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                // Removed plus icon and function
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Information Assurance & Security II",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 13 : 17,
                color: siaAccent,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(_moduleBuilders.length, (i) {
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
                      Icon(Icons.book,
                          color: siaPrimary, size: isMobile ? 24 : 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _moduleNames[i],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 16 : 22,
                            color: siaPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: siaPrimary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 10 : 14,
                                horizontal: isMobile ? 14 : 20,
                              ),
                              textStyle: TextStyle(
                                fontSize: isMobile ? 13 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(isMobile ? 8 : 12),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => _moduleBuilders[i](),
                                ),
                              );
                            },
                            child: const Text("Open"),
                          ),
                          // Removed delete button and function
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );

    if (widget.isDialog) {
      return Material(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
        child: SizedBox(
          width: isMobile ? 280 : 360,
          child: child,
        ),
      );
    }
    return Container(
      color: siaBackground,
      child: Center(
        key: const ValueKey("modules"),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
