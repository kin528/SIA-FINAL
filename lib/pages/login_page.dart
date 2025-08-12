import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';

// Add your color constants here for consistency
const Color siaAccent = Color(0xFF00E0FF);

class LoginPage extends StatefulWidget {
  final bool showSplash;
  const LoginPage({super.key, this.showSplash = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late bool _showSplash;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  late AnimationController _logoController;

  // --- Key for the title if you need to scroll to it programmatically
  final GlobalKey _titleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _showSplash = widget.showSplash;
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Password required. Enter your password to continue.";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/user');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'missing-password') {
        setState(() {
          _errorMessage = "Password required. Enter your password to continue.";
        });
      } else if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        setState(() {
          _errorMessage = "Invalid username or password";
        });
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundNetworkPainter(),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: _showSplash ? _buildSplash(context) : _buildLogin(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSplash(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_showSplash) {
          setState(() {
            _showSplash = false;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B263B), Color(0xFF415A77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _logoController,
                      curve: Curves.elasticOut,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 22,
                            spreadRadius: 1,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(44.0),
                      child: Icon(
                        Icons.school, // College cap graduation icon
                        size: 80,
                        color: siaAccent,
                        shadows: [
                          Shadow(
                            color: siaAccent.withOpacity(0.12),
                            offset: Offset(0, 3),
                            blurRadius: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Information Assurance & Security II',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.4,
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
                    "Empowering Connections, Engineering Success",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      letterSpacing: 0.7,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 8,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 44),
                  GestureDetector(
                    onTap: () {
                      if (_showSplash) {
                        setState(() {
                          _showSplash = false;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      decoration: BoxDecoration(
                        color: siaAccent.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: siaAccent.withOpacity(0.38),
                          width: 1.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.13),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, color: siaAccent, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Tap to continue',
                            style: TextStyle(
                              color: siaAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 7,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '© 2025 SIA - Information Assurance & Security II',
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;
    final contentMaxWidth = isWide ? 430.0 : double.infinity;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: isWide ? 36.0 : 14.0,
      vertical: isWide ? 36.0 : 17.0,
    );

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: contentPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: Container(
              padding: EdgeInsets.all(isWide ? 38 : 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.98),
                borderRadius: BorderRadius.circular(isWide ? 28 : 16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 28,
                    spreadRadius: 3,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.09),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---- LOGO CENTERED ----
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.14),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.09),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.school, // College cap graduation icon
                        size: isWide ? 62 : 46,
                        color: siaAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: isWide ? 20 : 14),
                  Center(
                    child: Text(
                      "Welcome to IAS Portal",
                      key: _titleKey,
                      style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isWide ? 29 : 21,
                          letterSpacing: .7),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Information Assurance & Security II",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor.withOpacity(0.87),
                        fontSize: isWide ? 17 : 14.5,
                        letterSpacing: 0.27,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Divider(
                    color: theme.primaryColor.withOpacity(0.17),
                    thickness: 1.6,
                    height: 20,
                  ),
                  const SizedBox(height: 18),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                    ),
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    keyboardType: TextInputType.text,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        tooltip: _obscurePassword
                            ? "Show password"
                            : "Hide password",
                      ),
                    ),
                    onSubmitted: (_) => _handleLogin(),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: isWide ? 18 : 14),
                              textStyle: TextStyle(
                                fontSize: isWide ? 20 : 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(isWide ? 15 : 10),
                              ),
                              elevation: 3,
                            ),
                            onPressed: _handleLogin,
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: isWide ? 20 : 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: TextStyle(
                              fontSize: isWide ? 16 : 13,
                              color: Colors.grey[800])),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF415A77)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: theme.primaryColor.withOpacity(0.13),
                    thickness: 1.2,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "© 2025 IAS - Information Assurance & Security II",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      letterSpacing: .2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.11)
      ..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.12)
      ..strokeWidth = 2;
    final nodes = [
      Offset(size.width * 0.12, size.height * 0.22),
      Offset(size.width * 0.38, size.height * 0.12),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.65, size.height * 0.71),
      Offset(size.width * 0.23, size.height * 0.82),
      Offset(size.width * 0.79, size.height * 0.85),
    ];
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }
    for (final node in nodes) {
      canvas.drawCircle(node, 15, nodePaint);
      canvas.drawCircle(
          node, 7, nodePaint..color = Colors.blueGrey.withOpacity(0.18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
