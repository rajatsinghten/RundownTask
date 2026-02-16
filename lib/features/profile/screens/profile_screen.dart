import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _gmailConnected = true;
  bool _outlookConnected = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildProfileCard(),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 28),
              _buildSectionTitle('CONNECTED ACCOUNTS'),
              const SizedBox(height: 12),
              _buildConnectedAccounts(),
              const SizedBox(height: 28),
              _buildSectionTitle('PREFERENCES'),
              const SizedBox(height: 12),
              _buildPreferences(),
              const SizedBox(height: 28),
              _buildSectionTitle('ABOUT'),
              const SizedBox(height: 12),
              _buildAboutSection(),
              const SizedBox(height: 32),
              _buildSignOutButton(),
              const SizedBox(height: 16),
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textSlate600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Profile',
            style: GoogleFonts.dmMono(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.textSlate600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8CA9FF),
                    Color(0xFF3B82F6),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'RS',
                  style: GoogleFonts.workSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Name, email, badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rajat Singh',
                    style: GoogleFonts.workSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSlate900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'rajat@rundown.app',
                    style: GoogleFonts.dmMono(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.blue200),
                    ),
                    child: Text(
                      'PRO MEMBER',
                      style: GoogleFonts.dmMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue600,
                        letterSpacing: 1,
                      ),
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

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatItem('Tasks Done', '128', Icons.check_circle_outline),
          const SizedBox(width: 12),
          _buildStatItem('Streak', '14d', Icons.local_fire_department_outlined),
          const SizedBox(width: 12),
          _buildStatItem('Inbox Zero', '6x', Icons.inbox_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primarySoft),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.workSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textSlate800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.workSans(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.dmMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSlate400,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectedAccounts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          children: [
            _buildAccountTile(
              icon: Icons.mail_outline,
              name: 'Gmail',
              detail: 'rajat.singh@gmail.com',
              iconColor: AppColors.gmailRed,
              bgColor: AppColors.gmailBg,
              borderColor: AppColors.gmailBorder,
              isConnected: _gmailConnected,
              onToggle: (val) => setState(() => _gmailConnected = val),
            ),
            Divider(height: 1, color: AppColors.gray100),
            _buildAccountTile(
              icon: Icons.mail_outline,
              name: 'Outlook',
              detail: 'rajat@company.com',
              iconColor: AppColors.outlookBlue,
              bgColor: AppColors.outlookBg,
              borderColor: AppColors.outlookBorder,
              isConnected: _outlookConnected,
              onToggle: (val) => setState(() => _outlookConnected = val),
            ),
            Divider(height: 1, color: AppColors.gray100),
            _buildAddAccountTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String name,
    required String detail,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required bool isConnected,
    required ValueChanged<bool> onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: GoogleFonts.dmMono(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isConnected,
            onChanged: onToggle,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountTile() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: AppColors.textSlate400,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Add Account',
              style: GoogleFonts.workSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primarySoft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferences() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          children: [
            _buildPreferenceTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Push & email alerts',
              hasSwitch: true,
              switchValue: _notificationsEnabled,
              onSwitchChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            Divider(height: 1, color: AppColors.gray100),
            _buildPreferenceTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Coming soon',
              hasSwitch: true,
              switchValue: _darkModeEnabled,
              onSwitchChanged: (val) => setState(() => _darkModeEnabled = val),
            ),
            Divider(height: 1, color: AppColors.gray100),
            _buildPreferenceTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English (US)',
              hasSwitch: false,
            ),
            Divider(height: 1, color: AppColors.gray100),
            _buildPreferenceTile(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Manage your data',
              hasSwitch: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasSwitch,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.textSlate600),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (hasSwitch)
            Switch.adaptive(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: AppColors.primary,
            )
          else
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.textSlate400,
            ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          children: [
            _buildSimpleTile(Icons.help_outline, 'Help & Support'),
            Divider(height: 1, color: AppColors.gray100),
            _buildSimpleTile(Icons.description_outlined, 'Terms of Service'),
            Divider(height: 1, color: AppColors.gray100),
            _buildSimpleTile(Icons.shield_outlined, 'Privacy Policy'),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTile(IconData icon, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.textSlate600),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.workSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSlate800,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.textSlate400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFECACA)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout,
                size: 20,
                color: AppColors.red500,
              ),
              const SizedBox(width: 10),
              Text(
                'Sign Out',
                style: GoogleFonts.workSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'RunDown v1.0.0',
      style: GoogleFonts.dmMono(
        fontSize: 12,
        color: AppColors.textSlate300,
      ),
    );
  }
}
