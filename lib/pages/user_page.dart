import 'package:flutter/material.dart';
import 'module_sheet.dart';
import 'play_panel.dart';
import 'dashboard_panel.dart';
import 'user_profile_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';

// IT-inspired Gradient Color Palette
const Color siaPrimary = Color(0xFF23297A); // deep tech blue
const Color siaAccent = Color(0xFF00E0FF); // neon cyan
const Color siaPurp = Color(0xFF6D41A7); // tech purple
const Color siaCard = Colors.white;
const Color siaShadow = Color(0x1A23297A);

final BoxDecoration contentBorderDecoration = BoxDecoration(
  color: Colors.transparent,
  border: Border(
    right: BorderSide(
      color: siaAccent.withOpacity(0.10),
      width: 2,
    ),
    left: BorderSide(
      color: siaAccent.withOpacity(0.10),
      width: 2,
    ),
  ),
);

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  String? _centerContent;

  void _showModules() {
    setState(() {
      _centerContent = "modules";
    });
  }

  void _showPlay() {
    setState(() {
      _centerContent = "play";
    });
  }

  void _showDashboard() {
    setState(() {
      _centerContent = "dashboard";
    });
  }

  void _showProfile() {
    setState(() {
      _centerContent = "profile";
    });
  }

  void _showWelcome() {
    setState(() {
      _centerContent = null;
    });
  }

  void _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    if (result == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: siaPrimary,
          elevation: 2,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: siaAccent.withOpacity(0.21), width: 2),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.school_rounded,
                    color: siaPrimary, size: 38),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'System Integration & Architecture',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
              child: Tooltip(
                message: "Logout",
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                  onPressed: _logout,
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: UserProfilePanel(),
      ),
      body: Stack(
        children: [
          // 1. Gradient background fills the screen
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF222B64),
                    Color(0xFF23297A),
                    Color(0xFF6D41A7),
                    Color(0xFF00E0FF)
                  ],
                  stops: [0.0, 0.45, 0.75, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // 2. Tech network overlay fills all background
          Positioned.fill(
            child: CustomPaint(
              painter: _ITNetworkPainter(),
            ),
          ),
          // 3. App content and nav menu
          SafeArea(
            child: Row(
              children: [
                // Sidebar with only nav icons (no burger menu)
                Container(
                  width: 80,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const SizedBox(height: 26),
                      _SidebarIconButton(
                        icon: Icons.home_rounded,
                        selected: _centerContent == null,
                        onTap: _showWelcome,
                        tooltip: "Home",
                      ),
                      _SidebarIconButton(
                        icon: Icons.menu_book_rounded,
                        selected: _centerContent == "modules",
                        onTap: _showModules,
                        tooltip: "Modules",
                      ),
                      _SidebarIconButton(
                        icon: Icons.play_circle_fill_rounded,
                        selected: _centerContent == "play",
                        onTap: _showPlay,
                        tooltip: "Play",
                      ),
                      _SidebarIconButton(
                        icon: Icons.dashboard_customize_rounded,
                        selected: _centerContent == "dashboard",
                        onTap: _showDashboard,
                        tooltip: "Dashboard",
                      ),
                      _SidebarIconButton(
                        icon: Icons.person_rounded,
                        selected: _centerContent == "profile",
                        onTap: _showProfile,
                        tooltip: "Profile",
                      ),
                    ],
                  ),
                ),
                // The rest of the content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _buildCenterContent(
                        theme,
                        BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 80,
                          maxHeight: MediaQuery.of(context).size.height,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(ThemeData theme, BoxConstraints constraints) {
    switch (_centerContent) {
      case "modules":
        return ModuleSheet(
          isDialog: false,
          isStandalone: true,
          onBack: _showWelcome,
        );
      case "play":
        return PlayPanel(
          onBack: _showWelcome,
        );
      case "dashboard":
        return DashboardPanel(
          onBack: _showWelcome,
        );
      case "profile":
        return UserProfilePanel(isDialog: false);
      default:
        // Welcome/empty state, always centered
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 600 ? 16 : 36,
                vertical: constraints.maxHeight < 600 ? 24 : 36,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF222B64),
                      Color(0xFF6D41A7),
                      Color(0xFF00E0FF)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(2, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Icon(Icons.school_rounded,
                          size: 100, color: siaAccent),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "Welcome to System Integration & Architecture Portal!",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: constraints.maxWidth < 600 ? 26 : 36,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 10,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Explore modules, play interactive challenges, or view your dashboard.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(.89),
                        fontSize: constraints.maxWidth < 600 ? 16 : 22,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 8,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}

class _SidebarIconButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String tooltip;

  const _SidebarIconButton({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: selected ? siaAccent.withOpacity(0.36) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

// IT/Circuit themed network painter
class _ITNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFF00E0FF).withOpacity(0.13)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final Paint nodePaint = Paint()
      ..color = const Color(0xFF00E0FF).withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final nodes = [
      Offset(size.width * 0.1, size.height * 0.18),
      Offset(size.width * 0.3, size.height * 0.11),
      Offset(size.width * 0.5, size.height * 0.20),
      Offset(size.width * 0.8, size.height * 0.16),
      Offset(size.width * 0.17, size.height * 0.36),
      Offset(size.width * 0.42, size.height * 0.32),
      Offset(size.width * 0.67, size.height * 0.29),
      Offset(size.width * 0.25, size.height * 0.60),
      Offset(size.width * 0.55, size.height * 0.45),
      Offset(size.width * 0.82, size.height * 0.46),
      Offset(size.width * 0.15, size.height * 0.83),
      Offset(size.width * 0.37, size.height * 0.78),
      Offset(size.width * 0.62, size.height * 0.86),
      Offset(size.width * 0.84, size.height * 0.79),
    ];

    // Draw "network" lines
    for (int i = 0; i < nodes.length; i++) {
      for (int j = 0; j < nodes.length; j++) {
        if (i != j && ((i + j) % 3 == 0 || (i - j).abs() == 4)) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    // Draw nodes
    for (final node in nodes) {
      canvas.drawCircle(node, 15, nodePaint);
      canvas.drawCircle(node, 6,
          nodePaint..color = const Color(0xFF00E0FF).withOpacity(0.22));
      canvas.drawCircle(
          node, 2.5, Paint()..color = Colors.white.withOpacity(0.82));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
