import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

// Add color constant for siaAccent
const Color siaAccent = Color(0xFF00E0FF);

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  String? _selectedSex;
  final List<String> _sexOptions = ['Male', 'Female', 'Other'];

  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _ageFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      UserCredential? userCredential;
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = userCredential.user;
        if (user == null) throw Exception("User creation failed");

        await user.updateProfile(
          displayName:
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        );

        final studentDoc = FirebaseFirestore.instance
            .collection('admin')
            .doc('students')
            .collection('users')
            .doc(user.uid);

        await studentDoc.set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': _ageController.text.trim(),
          'sex': _selectedSex ?? "",
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account created successfully! Please log in.')),
        );

        await FirebaseAuth.instance.signOut();

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'An unknown error occurred (${e.code}).';
        }
        if (!mounted) return;
        setState(() {
          _errorMessage = errorMessage;
        });
      } on FirebaseException catch (e) {
        if (userCredential?.user != null) {
          await userCredential!.user!.delete();
        }
        if (!mounted) return;
        setState(() {
          _errorMessage =
              'Account creation failed (database error): ${e.message}';
        });
      } catch (e) {
        if (userCredential?.user != null) {
          await userCredential!.user!.delete();
        }
        if (!mounted) return;
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;
    final contentMaxWidth = isWide ? 430.0 : double.infinity;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: isWide ? 36.0 : 14.0,
      vertical: isWide ? 36.0 : 17.0,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundNetworkPainter(),
            ),
          ),
          SafeArea(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Animated logo, cap icon, siaAccent
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _logoController,
                              curve: Curves.elasticOut,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: siaAccent.withOpacity(0.13),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: siaAccent.withOpacity(0.09),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Icon(
                                Icons.school,
                                size: isWide ? 62 : 46,
                                color: siaAccent,
                              ),
                            ),
                          ),
                          SizedBox(height: isWide ? 20 : 14),
                          Text(
                            "Sign Up to SIA Portal",
                            style: theme.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isWide ? 29 : 21,
                                letterSpacing: .7),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "System, Integration & Architecture",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor.withOpacity(0.87),
                              fontSize: isWide ? 17 : 14.5,
                              letterSpacing: 0.27,
                            ),
                            textAlign: TextAlign.center,
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
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  focusNode: _firstNameFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.blueGrey[50],
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'First name required'
                                      : null,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lastNameFocus);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    prefixIcon: Icon(Icons.person_4_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.blueGrey[50],
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Last name required'
                                      : null,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_ageFocus);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _ageController,
                            focusNode: _ageFocus,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              prefixIcon: Icon(Icons.cake_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Age required' : null,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Sex',
                              prefixIcon: Icon(Icons.wc_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            value: _selectedSex,
                            items: _sexOptions
                                .map((sex) => DropdownMenuItem(
                                      value: sex,
                                      child: Text(sex),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSex = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select sex' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value!.isEmpty ? 'Email required' : null,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscurePassword,
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
                            validator: (value) => value!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                            onFieldSubmitted: (_) => _handleSignup(),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
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
                                        borderRadius: BorderRadius.circular(
                                            isWide ? 15 : 10),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: _handleSignup,
                                    child: Text(
                                      'Sign Up',
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
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginPage(showSplash: false)),
                                ),
                                child: const Text(
                                  'Log in',
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
                            "© 2025 SIA - System, Integration & Architecture",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              letterSpacing: .2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
