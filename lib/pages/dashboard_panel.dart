import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String adminUid = 'QVyiObd7HoXTyNQaoxBzRSW0HGK2';
const List<String> moduleIds = [
  'module1',
  'module2',
  'module3',
  'module4',
  'module5',
];

const Color siaPrimary = Color(0xFF415A77);
const Color siaAccent = Color(0xFF778DA9);
const Color siaBackground = Color(0xFFF6F8FB);
const Color siaCard = Colors.white;
const Color siaShadow = Color(0x1A415A77);
const Color hoverHighlight = Color(0xFFE3EDF7);

class DashboardPanel extends StatelessWidget {
  final VoidCallback? onBack;
  const DashboardPanel({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user != null && user.uid == adminUid;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      color: siaBackground,
      child: Center(
        key: const ValueKey("dashboard"),
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
              child: isAdmin
                  ? _AdminDashboard(onBack: onBack)
                  : _StudentDashboard(onBack: onBack),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  final VoidCallback? onBack;
  const _AdminDashboard({this.onBack});

  void _showAllStudentsDialog(BuildContext context,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> students) {
    showDialog(
      context: context,
      builder: (context) => _AllStudentsDialog(students: students),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('admin')
          .doc('students')
          .collection('users')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final students = snapshot.data!.docs;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : 14,
            vertical: isMobile ? 0 : 8,
          ),
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
                    // CHANGED ICON HERE!
                    child: const Icon(Icons.dashboard_customize,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Admin Dashboard",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 22 : 28,
                        color: siaPrimary,
                        letterSpacing: 1.1),
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
              GestureDetector(
                onTap: () => _showAllStudentsDialog(context, students),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                      vertical: isMobile ? 10 : 20,
                    ),
                    decoration: BoxDecoration(
                      color: siaAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: siaPrimary.withOpacity(0.18),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: siaAccent.withOpacity(0.10),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people_alt,
                            color: siaPrimary, size: isMobile ? 27 : 32),
                        const SizedBox(width: 11),
                        Text(
                          "Total Students: ",
                          style: TextStyle(
                            color: siaPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 18 : 22,
                          ),
                        ),
                        Text(
                          "${students.length}",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w900,
                            fontSize: isMobile ? 23 : 28,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.visibility,
                            color: siaAccent, size: isMobile ? 22 : 26),
                        const SizedBox(width: 6),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: siaAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : 17,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ...List.generate(students.length, (i) {
                final student = students[i].data();
                final userId = students[i].id;
                final firstName = student['firstName'] ?? '';
                final lastName = (student['lastName'] ?? '').toString();
                final name = "$firstName $lastName".trim();
                final lastNameInitial = lastName.isNotEmpty
                    ? lastName.substring(0, 1).toUpperCase()
                    : (firstName.isNotEmpty
                        ? firstName.substring(0, 1).toUpperCase()
                        : '?');

                return _HoverableUserCard(
                  name: name.isNotEmpty ? name : userId,
                  userId: userId,
                  student: student,
                  lastNameInitial: lastNameInitial,
                  isMobile: isMobile,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _AllStudentsDialog extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> students;
  const _AllStudentsDialog({required this.students});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Dialog(
      backgroundColor: siaBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        width: isWide ? 570 : double.infinity,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: EdgeInsets.symmetric(
            horizontal: isWide ? 32 : 12, vertical: isWide ? 30 : 16),
        decoration: BoxDecoration(
          color: siaCard,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: siaShadow.withOpacity(0.18),
              blurRadius: 30,
              spreadRadius: 3,
            ),
          ],
          border: Border.all(
            color: siaAccent.withOpacity(0.13),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: siaPrimary, size: 30),
                SizedBox(width: 12),
                Text(
                  "All Students",
                  style: TextStyle(
                    color: siaPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red.shade300),
                  tooltip: "Close",
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 6),
            Divider(thickness: 1.2, color: siaAccent.withOpacity(0.19)),
            SizedBox(height: 8),
            Expanded(
              child: students.isEmpty
                  ? Center(
                      child: Text(
                        "No students found.",
                        style: TextStyle(color: siaAccent, fontSize: 18),
                      ),
                    )
                  : ListView.separated(
                      itemCount: students.length,
                      separatorBuilder: (_, __) => Divider(
                        color: siaAccent.withOpacity(0.10),
                        thickness: 1,
                        height: 12,
                      ),
                      itemBuilder: (context, i) {
                        final student = students[i].data();
                        final firstName = student['firstName'] ?? '';
                        final lastName = (student['lastName'] ?? '').toString();
                        final name = "$firstName $lastName".trim();
                        final lastNameInitial = lastName.isNotEmpty
                            ? lastName.substring(0, 1).toUpperCase()
                            : (firstName.isNotEmpty
                                ? firstName.substring(0, 1).toUpperCase()
                                : '?');
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: siaAccent.withOpacity(0.33),
                            radius: 21,
                            child: Text(
                              lastNameInitial,
                              style: TextStyle(
                                color: siaPrimary,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            name.isNotEmpty ? name : students[i].id,
                            style: TextStyle(
                              color: siaPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            student['email'] ?? '',
                            style: TextStyle(
                              color: siaAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => _UserDetailDialog(
                                userId: students[i].id,
                                student: student,
                              ),
                            );
                          },
                          hoverColor: hoverHighlight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded,
                              color: siaAccent, size: 18),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableUserCard extends StatefulWidget {
  final String name;
  final String userId;
  final Map<String, dynamic> student;
  final String lastNameInitial;
  final bool isMobile;

  const _HoverableUserCard({
    required this.name,
    required this.userId,
    required this.student,
    required this.lastNameInitial,
    required this.isMobile,
  });

  @override
  State<_HoverableUserCard> createState() => _HoverableUserCardState();
}

class _HoverableUserCardState extends State<_HoverableUserCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered ? hoverHighlight : siaCard,
          borderRadius: BorderRadius.circular(widget.isMobile ? 14 : 24),
          boxShadow: [
            BoxShadow(
              color: siaShadow.withOpacity(_isHovered ? 0.13 : 0.08),
              blurRadius: _isHovered ? 18 : 10,
              spreadRadius: _isHovered ? 4 : 2,
            ),
          ],
          border: Border.all(
            color: _isHovered
                ? siaAccent.withOpacity(0.22)
                : siaAccent.withOpacity(0.10),
            width: 2,
          ),
        ),
        margin: EdgeInsets.only(
            bottom: widget.isMobile ? 16 : 24, left: 0, right: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.isMobile ? 14 : 24),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => _UserDetailDialog(
                userId: widget.userId,
                student: widget.student,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.isMobile ? 14 : 22,
                horizontal: widget.isMobile ? 14 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: siaAccent.withOpacity(0.33),
                      radius: widget.isMobile ? 21 : 28,
                      child: Text(
                        widget.lastNameInitial,
                        style: TextStyle(
                          color: siaPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: widget.isMobile ? 20 : 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: widget.isMobile ? 19 : 25,
                          color: siaPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _StudentScores(
                    userId: widget.userId, isMobile: widget.isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserDetailDialog extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> student;
  const _UserDetailDialog({required this.userId, required this.student});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Dialog(
      backgroundColor: siaBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: isWide ? 520 : double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40 : 16, vertical: isWide ? 38 : 22),
        decoration: BoxDecoration(
          color: siaCard,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: siaShadow,
              blurRadius: 36,
              spreadRadius: 6,
              offset: const Offset(0, 18),
            ),
          ],
          border: Border.all(
            color: siaAccent.withOpacity(0.10),
            width: 2,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('admin')
              .doc('students')
              .collection('users')
              .doc(userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 54),
                  const SizedBox(height: 14),
                  Text('Error loading user info.',
                      style: TextStyle(fontSize: 20, color: Colors.red)),
                  const SizedBox(height: 14),
                  _closeButton(context)
                ],
              );
            }
            if (!snapshot.hasData) {
              return SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final userData = snapshot.data!.data() ?? {};
            final fullName =
                "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}"
                    .trim();
            final lastName = (userData['lastName'] ?? '').toString();
            final lastNameInitial = lastName.isNotEmpty
                ? lastName.substring(0, 1).toUpperCase()
                : (userData['firstName'] ?? '').toString().isNotEmpty
                    ? (userData['firstName'] as String)
                        .substring(0, 1)
                        .toUpperCase()
                    : '?';

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        siaPrimary.withOpacity(0.2),
                        siaAccent.withOpacity(0.18)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: siaPrimary.withOpacity(0.16),
                        blurRadius: 30,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    lastNameInitial,
                    style: TextStyle(
                      color: siaPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fullName.isNotEmpty ? fullName : userId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 29,
                    color: siaPrimary,
                    letterSpacing: 1.12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 9),
                Container(
                  decoration: BoxDecoration(
                    color: siaAccent.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                          "Gmail", userData['email'] ?? 'N/A', Icons.email),
                      _infoRow("Age", (userData['age'] ?? 'N/A').toString(),
                          Icons.cake),
                      _infoRow("Sex", userData['sex'] ?? 'N/A', Icons.wc),
                      _infoRow("First Name", userData['firstName'] ?? 'N/A',
                          Icons.badge),
                      _infoRow("Last Name", userData['lastName'] ?? 'N/A',
                          Icons.badge),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _closeButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton.icon(
        icon: Icon(Icons.close, color: siaPrimary),
        label: Text("Close",
            style: TextStyle(color: siaPrimary, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: siaPrimary.withOpacity(0.3), width: 1.8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: siaAccent, size: 23),
          const SizedBox(width: 14),
          Text(
            "$label: ",
            style: TextStyle(
                fontWeight: FontWeight.w700, color: siaPrimary, fontSize: 17),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentScores extends StatelessWidget {
  final String userId;
  final bool isMobile;
  const _StudentScores({required this.userId, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: Future.wait(moduleIds.map((moduleId) async {
        final snap = await FirebaseFirestore.instance
            .collection('Quiz')
            .doc(moduleId)
            .collection('scores')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: false)
            .get();
        return snap.docs.map((d) => d.data()).toList();
      })),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allScores = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < moduleIds.length; i++)
              if (allScores[i].isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 16)),
                  margin: EdgeInsets.only(
                      bottom: isMobile ? 12 : 22, left: 0, right: 0),
                  color: siaAccent.withOpacity(0.11),
                  shadowColor: siaShadow,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 11 : 21.0,
                        vertical: isMobile ? 10 : 17.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.extension_rounded,
                                color: siaPrimary, size: isMobile ? 18 : 26),
                            const SizedBox(width: 8),
                            Text(
                              "${moduleIds[i].replaceAll('module', 'Module ')} Scores",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 15 : 22,
                                color: siaPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 10 : 16),
                        ...List.generate(allScores[i].length, (j) {
                          final score = allScores[i][j];
                          final take = j + 1;
                          final date = score['timestamp'] != null &&
                                  score['timestamp'] is Timestamp
                              ? (score['timestamp'] as Timestamp).toDate()
                              : null;
                          String formattedDate = '';
                          if (date != null) {
                            final hour =
                                date.hour % 12 == 0 ? 12 : date.hour % 12;
                            final minute =
                                date.minute.toString().padLeft(2, '0');
                            final ampm = date.hour >= 12 ? 'PM' : 'AM';
                            formattedDate =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $hour:$minute $ampm";
                          }
                          return Column(
                            children: [
                              if (j > 0)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: isMobile ? 2.0 : 5.0),
                                  child: Divider(
                                      height: 2,
                                      color: siaPrimary.withOpacity(0.3),
                                      thickness: 2),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: Colors.green,
                                      size: isMobile ? 18 : 30),
                                  SizedBox(width: isMobile ? 6 : 12),
                                  Text(
                                    "Take $take:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: isMobile ? 13 : 18,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(width: isMobile ? 7 : 14),
                                  Text(
                                    "${score['score']} pts",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isMobile ? 14 : 22,
                                        color: siaPrimary),
                                  ),
                                  const Spacer(),
                                  if (formattedDate.isNotEmpty)
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                          fontSize: isMobile ? 10 : 14,
                                          color: Colors.grey.shade700,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                              if (j == allScores[i].length - 1)
                                SizedBox(
                                    height: isMobile
                                        ? 4
                                        : 10), // Extra gap after last take
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _StudentDashboard extends StatelessWidget {
  final VoidCallback? onBack;
  const _StudentDashboard({this.onBack});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (user == null) {
      return const Center(child: Text("Not logged in."));
    }
    return Column(
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
              child: const Icon(Icons.analytics, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 15),
            Text(
              "My Dashboard",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: siaPrimary,
                  fontSize: isMobile ? 22 : 28,
                  letterSpacing: 1.1),
            ),
          ],
        ),
        const SizedBox(height: 7),
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
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: isMobile ? 4 : 10),
            children: [
              for (final moduleId in moduleIds)
                _MyModuleScores(
                  moduleId: moduleId,
                  userId: user.uid,
                  isMobile: isMobile,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyModuleScores extends StatelessWidget {
  final String moduleId;
  final String userId;
  final bool isMobile;
  const _MyModuleScores(
      {required this.moduleId, required this.userId, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('Quiz')
          .doc(moduleId)
          .collection('scores')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade100.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final scores = snapshot.data!.docs;
        if (scores.isEmpty) return const SizedBox.shrink();
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isMobile ? 10 : 16)),
          margin:
              EdgeInsets.only(bottom: isMobile ? 12 : 22, left: 0, right: 0),
          color: siaAccent.withOpacity(0.10),
          shadowColor: siaShadow,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 26.0,
                vertical: isMobile ? 12 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.extension_rounded,
                        color: siaPrimary, size: isMobile ? 18 : 26),
                    const SizedBox(width: 8),
                    Text(
                      "${moduleId.replaceAll('module', 'Module ')} Scores",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 15 : 22,
                          color: siaPrimary,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 16),
                ...List.generate(scores.length, (i) {
                  final score = scores[i].data();
                  final take = i + 1;
                  final date = score['timestamp'] != null &&
                          score['timestamp'] is Timestamp
                      ? (score['timestamp'] as Timestamp).toDate()
                      : null;
                  String formattedDate = '';
                  if (date != null) {
                    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
                    final minute = date.minute.toString().padLeft(2, '0');
                    final ampm = date.hour >= 12 ? 'PM' : 'AM';
                    formattedDate =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $hour:$minute $ampm";
                  }
                  return Column(
                    children: [
                      if (i > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 2.0 : 5.0),
                          child: Divider(
                              height: 2,
                              color: siaPrimary.withOpacity(0.3),
                              thickness: 2),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.green, size: isMobile ? 18 : 30),
                          SizedBox(width: isMobile ? 6 : 12),
                          Text(
                            "Take $take:",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: isMobile ? 13 : 18,
                                color: Colors.black87),
                          ),
                          SizedBox(width: isMobile ? 7 : 14),
                          Text(
                            "${score['score']} pts",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 14 : 22,
                                color: siaPrimary),
                          ),
                          const Spacer(),
                          if (formattedDate.isNotEmpty)
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: isMobile ? 10 : 14,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                      if (i == scores.length - 1)
                        SizedBox(height: isMobile ? 4 : 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
