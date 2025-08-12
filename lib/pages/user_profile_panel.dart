import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// SIA Color Palette
const Color siaPrimary = Color(0xFF415A77);
const Color siaAccent = Color(0xFF778DA9);
const Color siaBackground = Color(0xFFF6F8FB);
const Color siaCard = Colors.white;
const Color siaShadow = Color(0x1A415A77);

class UserProfilePanel extends StatefulWidget {
  final bool isDialog;
  const UserProfilePanel({super.key, this.isDialog = false});

  @override
  State<UserProfilePanel> createState() => _UserProfilePanelState();
}

class _UserProfilePanelState extends State<UserProfilePanel> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? debugMsg;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final adminUid = 'QVyiObd7HoXTyNQaoxBzRSW0HGK2';
      try {
        DocumentSnapshot<Map<String, dynamic>> doc;
        if (user.uid == adminUid) {
          doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
        } else {
          doc = await FirebaseFirestore.instance
              .collection('admin')
              .doc('students')
              .collection('users')
              .doc(user.uid)
              .get();
        }
        setState(() {
          userData = doc.exists ? doc.data() : null;
          isLoading = false;
          debugMsg =
              'UID: ${user.uid}\nExists: ${doc.exists}\nData: ${doc.data()}';
        });
      } catch (e) {
        setState(() {
          userData = null;
          isLoading = false;
          debugMsg = 'Error: $e';
        });
      }
    } else {
      setState(() {
        userData = null;
        isLoading = false;
        debugMsg = 'No current user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminUid = 'QVyiObd7HoXTyNQaoxBzRSW0HGK2';
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user != null && user.uid == adminUid;
    final isMobile = MediaQuery.of(context).size.width < 600;

    Widget content;
    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (userData == null && !isAdmin) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Failed to load profile data.",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (debugMsg != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  debugMsg!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: () => _loadUserData(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    } else {
      // Same card look as dashboard, but content centered!
      content = Container(
        color: siaBackground,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade400,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade200.withOpacity(0.26),
                              blurRadius: 18,
                              spreadRadius: 6,
                            )
                          ],
                        ),
                        width: isMobile ? 70 : 110,
                        height: isMobile ? 70 : 110,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: isMobile ? 40 : 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isAdmin
                          ? "ADMIN"
                          : "${userData!['firstName'] ?? ''} ${userData!['lastName'] ?? ''}"
                              .trim(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 22 : 28,
                        color: Colors.purple.shade400,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isAdmin
                          ? user.email ?? ""
                          : userData!['email'] ??
                              FirebaseAuth.instance.currentUser?.email ??
                              'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isMobile ? 14 : 16,
                        color: siaAccent,
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isAdmin) ...[
                      const SizedBox(height: 20),
                      _ProfileField(
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: userData!['age']?.toString() ?? 'N/A',
                      ),
                      const SizedBox(height: 16),
                      _ProfileField(
                        icon: Icons.wc_outlined,
                        label: 'Sex',
                        value: userData!['sex'] ?? 'N/A',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.isDialog) {
      return Material(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
        child: SizedBox(width: 340, child: content),
      );
    } else {
      return content;
    }
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple.shade400),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
