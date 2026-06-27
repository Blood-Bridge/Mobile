import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/delete_account_cubit/delete_account_state.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_group.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/user_type_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../widgets/arrow_item.dart';
import '../widgets/language_selector.dart';
import '../widgets/toggle_item.dart';

class SettingViewBody extends StatefulWidget {
  final bool isHospital;

  const SettingViewBody({super.key, this.isHospital = false});

  @override
  State<SettingViewBody> createState() => _SettingViewBodyState();
}

class _SettingViewBodyState extends State<SettingViewBody> {
  bool _locationSharing = true;
  bool _profileVisibility = true;
  bool _darkMode = true;
  int _searchRadius = 5;

  // ── Hospital inventory state ──────────────────────────────────────────────
  final Map<String, TextEditingController> _inventoryControllers = {
    'OPositive': TextEditingController(text: '0'),
    'ONegative': TextEditingController(text: '0'),
    'APositive': TextEditingController(text: '0'),
    'ANegative': TextEditingController(text: '0'),
    'BPositive': TextEditingController(text: '0'),
    'BNegative': TextEditingController(text: '0'),
    'ABPositive': TextEditingController(text: '0'),
    'ABNegative': TextEditingController(text: '0'),
  };

  final Map<String, String> _bloodLabels = {
    'OPositive': 'O+',
    'ONegative': 'O−',
    'APositive': 'A+',
    'ANegative': 'A−',
    'BPositive': 'B+',
    'BNegative': 'B−',
    'ABPositive': 'AB+',
    'ABNegative': 'AB−',
  };

  bool _inventoryLoading = false;

  // ── Active requests state ─────────────────────────────────────────────────
  List<Map<String, dynamic>> _activeRequests = [];
  bool _requestsLoading = false;
  bool _requestsLoaded = false;

  @override
  void dispose() {
    for (final c in _inventoryControllers.values) c.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hospital: Update Inventory
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _updateInventory() async {
    setState(() => _inventoryLoading = true);
    try {
      final body = _inventoryControllers.entries
          .map(
            (e) => {
              'bloodType': e.key,
              'unitsAvailable': int.tryParse(e.value.text) ?? 0,
            },
          )
          .toList();

      final response = await DioHelper.putData(
        path: 'Hospital/inventory',
        body: body,
      );

      if (response.statusCode == 200) {
        showSnackBar(
          'Success',
          'Inventory updated successfully',
          SnackbarType.success,
        );
      } else {
        showSnackBar(
          'Error',
          response.data?['message'] ?? 'Update failed',
          SnackbarType.error,
        );
      }
    } catch (e) {
      showSnackBar('Error', e.toString(), SnackbarType.error);
    } finally {
      setState(() => _inventoryLoading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hospital: Fetch Active Requests
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _fetchActiveRequests() async {
    setState(() {
      _requestsLoading = true;
      _requestsLoaded = false;
    });
    try {
      final response = await DioHelper.getData(path: 'Requests/active');
      if (response.statusCode == 200) {
        final raw = response.data?['data'];
        final List items = raw is List
            ? raw
            : (raw is Map ? (raw['items'] ?? raw['data'] ?? []) : []);
        setState(() {
          _activeRequests = items.whereType<Map<String, dynamic>>().toList();
          _requestsLoaded = true;
        });
      }
    } catch (e) {
      showSnackBar('Error', e.toString(), SnackbarType.error);
    } finally {
      setState(() => _requestsLoading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dialogs (shared)
  // ─────────────────────────────────────────────────────────────────────────
  void _showSearchRadiusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Search Radius', style: TextStyleHelper.h3(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [5, 10, 20, 50].map((radius) {
            return ListTile(
              title: Text(
                '$radius km',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() => _searchRadius = radius);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('About Blood Bridge', style: TextStyleHelper.h3(context)),
        content: Text(
          'Blood Bridge is a platform designed to connect blood donors directly with recipient requests and hospital inventory systems to save lives in emergency situations.',
          style: TextStyleHelper.small(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Help Center', style: TextStyleHelper.h3(context)),
        content: Text(
          'If you have questions about donating blood, account management, or request creation, please visit support.bloodbridge.org or contact our team.',
          style: TextStyleHelper.small(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Contact Support', style: TextStyleHelper.h3(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: support@bloodbridge.org',
              style: TextStyleHelper.small(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: +20 123 456 789',
              style: TextStyleHelper.small(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Hours: 24/7 emergency support',
              style: TextStyleHelper.small(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Privacy Policy', style: TextStyleHelper.h3(context)),
        content: SingleChildScrollView(
          child: Text(
            'We value your privacy. Your personal information, contact info, and medical details are securely stored. Location sharing is exclusively used to display active matching requests in your area and is not shared with third parties.',
            style: TextStyleHelper.small(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showSwitchToDonorDialog() {
    final formKey = GlobalKey<FormState>();
    final nationalIdController = TextEditingController();
    final weightController = TextEditingController();
    final medicalHistoryController = TextEditingController();
    DateTime? selectedDob;

    showDialog(
      context: context,
      builder: (dlgContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text('Switch to Donor', style: TextStyleHelper.h3(context)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'To register as a donor, you must meet eligibility criteria.',
                    style: TextStyleHelper.xs(
                      context,
                    ).copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nationalIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'National ID',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final w = double.tryParse(v);
                      if (w == null || w < 45) return 'Must be at least 45 kg';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: medicalHistoryController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Medical History',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      hintText: 'None, diabetes, etc.',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDob == null
                            ? 'Select Date of Birth'
                            : 'DOB: ${selectedDob!.toLocal().toString().split(' ').first}',
                        style: TextStyleHelper.small(context),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              const Duration(days: 365 * 18),
                            ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() => selectedDob = date);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && selectedDob != null) {
                  Navigator.pop(dlgContext);
                  context.read<SwitchRoleCubit>().switchToDonor(
                    weight: double.parse(weightController.text),
                    dateOfBirth: selectedDob!.toIso8601String(),
                    medicalHistory: medicalHistoryController.text.isEmpty
                        ? 'None'
                        : medicalHistoryController.text,
                    nationalId: nationalIdController.text,
                    latitude: 30.071,
                    longitude: 31.250,
                  );
                } else if (selectedDob == null) {
                  showSnackBar(
                    'Error',
                    'Please select Date of Birth',
                    SnackbarType.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Switch',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSwitchToRecipient() {
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Switch to Recipient', style: TextStyleHelper.h3(context)),
        content: Text(
          'Are you sure you want to switch your role back to Recipient?',
          style: TextStyleHelper.small(
            context,
          ).copyWith(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dlgContext);
              context.read<SwitchRoleCubit>().switchToRecipient();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Switch', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Delete Account',
          style: TextStyleHelper.h3(context).copyWith(color: Colors.red),
        ),
        content: Text(
          'WARNING: This will permanently delete your account. This action is irreversible.',
          style: TextStyleHelper.small(
            context,
          ).copyWith(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dlgContext);
              context.read<DeleteAccountCubit>().deleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Delete Permanently',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hospital: Inventory Sheet
  // ─────────────────────────────────────────────────────────────────────────
  void _showInventorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Update Blood Inventory', style: TextStyleHelper.h3(ctx)),
                const SizedBox(height: 4),
                Text(
                  'Enter current units for each blood type',
                  style: TextStyleHelper.xs(
                    ctx,
                  ).copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                ..._inventoryControllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _bloodLabels[entry.key] ?? entry.key,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: entry.value,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.bg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              suffixText: 'units',
                              suffixStyle: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _inventoryLoading
                        ? null
                        : () async {
                            Navigator.pop(ctx);
                            await _updateInventory();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _inventoryLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Inventory',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hospital: Active Requests Sheet
  // ─────────────────────────────────────────────────────────────────────────
  void _showActiveRequestsSheet() async {
    if (!_requestsLoaded) await _fetchActiveRequests();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (ctx, scrollController) => Column(
          children: [
            // handle + header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Requests', style: TextStyleHelper.h3(ctx)),
                      TextButton.icon(
                        onPressed: () async {
                          await _fetchActiveRequests();
                          Navigator.pop(ctx);
                          _showActiveRequestsSheet();
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Refresh',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _requestsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _activeRequests.isEmpty
                  ? Center(
                      child: Text(
                        'No active requests',
                        style: TextStyleHelper.small(
                          ctx,
                        ).copyWith(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: _activeRequests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) =>
                          _RequestTile(data: _activeRequests[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final currentRole = HiveHelper.getUserRole();
    final isDonor = currentRole == 'Donor';

    return MultiBlocListener(
      listeners: [
        BlocListener<SwitchRoleCubit, SwitchRoleState>(
          listener: (context, state) {
            if (state is SwitchRoleSuccess) {
              showSnackBar('Success', state.message, SnackbarType.success);
              context.read<AuthCubit>().logout(context);
            }
          },
        ),
        BlocListener<DeleteAccountCubit, DeleteAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              showSnackBar(
                'Success',
                'Your account has been deleted.',
                SnackbarType.success,
              );
              context.read<AuthCubit>().logout(context);
            } else if (state is DeleteAccountError) {
              showSnackBar('Error', state.message, SnackbarType.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.foreground,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Settings', style: TextStyleHelper.h1(context)),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          children: [
            const LanguageSelector(),

            widget.isHospital ? const SizedBox() : UserTypeSelector(),
            // ── Notifications (all users) ─────────────────────────────────
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return SettingsGroup(
                  sectionTitle: 'Notifications',
                  children: [
                    ToggleItem(
                      title: 'Emergency Alerts',
                      subtitle: 'Critical blood requests',
                      value: state.emergencyAlerts,
                      onChanged: (val) => context
                          .read<NotificationsCubit>()
                          .toggleEmergencyAlerts(val),
                    ),
                    ToggleItem(
                      title: 'Request Notifications',
                      subtitle: 'Standard blood requests',
                      value: state.requestNotifications,
                      onChanged: (val) => context
                          .read<NotificationsCubit>()
                          .toggleRequestNotifications(val),
                    ),
                    ToggleItem(
                      title: 'Donation Reminders',
                      subtitle: 'When eligible to donate again',
                      value: state.donationReminders,
                      onChanged: (val) => context
                          .read<NotificationsCubit>()
                          .toggleDonationReminders(val),
                    ),
                  ],
                );
              },
            ),

            // ── Privacy (all users) ───────────────────────────────────────
            SettingsGroup(
              sectionTitle: 'Privacy',
              children: [
                ToggleItem(
                  title: 'Location Sharing',
                  subtitle: 'For nearby matching',
                  value: _locationSharing,
                  onChanged: (val) => setState(() => _locationSharing = val),
                ),
                ToggleItem(
                  title: 'Profile Visibility',
                  subtitle: 'Show to other users',
                  value: _profileVisibility,
                  onChanged: (val) => setState(() => _profileVisibility = val),
                ),
              ],
            ),

            // ── Preferences (all users) ───────────────────────────────────
            SettingsGroup(
              sectionTitle: 'Preferences',
              children: [
                ToggleItem(
                  title: 'Dark Mode',
                  subtitle: 'Always on for eye comfort',
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
                ArrowItem(
                  title: 'Search Radius',
                  subtitle: '$_searchRadius km',
                  onTap: _showSearchRadiusDialog,
                ),
                // Switch Role — Donor & Recipient only
                if (isDonor || currentRole == 'Recipient')
                  ArrowItem(
                    title: 'Current Role',
                    subtitle: currentRole ?? 'None',
                    onTap: () {
                      if (isDonor) {
                        _confirmSwitchToRecipient();
                      } else {
                        _showSwitchToDonorDialog();
                      }
                    },
                  ),
                // My Donations — Donor only
                if (isDonor)
                  ArrowItem(
                    title: 'My Donations',
                    subtitle: 'View history & confirm status',
                    onTap: () => Get.toNamed('/donations'),
                  ),
              ],
            ),

            // ── Hospital Management ───────────────────────────────────────
            if (widget.isHospital)
              SettingsGroup(
                sectionTitle: 'Hospital Management',
                children: [
                  ArrowItem(
                    title: 'Blood Inventory',
                    subtitle: 'Update blood stock levels',
                    onTap: _showInventorySheet,
                    icon: Icons.bloodtype_outlined,
                    iconColor: AppColors.primary,
                  ),
                  ArrowItem(
                    title: 'Active Requests',
                    subtitle: 'View open blood requests',
                    onTap: _showActiveRequestsSheet,
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFFFF6900),
                  ),
                ],
              ),

            // ── Support (all users) ───────────────────────────────────────
            SettingsGroup(
              sectionTitle: 'Support',
              children: [
                ArrowItem(title: 'Help Center', onTap: _showHelpCenterDialog),
                ArrowItem(
                  title: 'Contact Support',
                  onTap: _showContactSupportDialog,
                ),
                ArrowItem(title: 'About', onTap: _showAboutDialog),
              ],
            ),

            const SizedBox(height: 12),

            // Privacy Policy
            _BottomTile(
              icon: Icons.shield_outlined,
              label: 'Privacy Policy',
              color: AppColors.textMuted,
              onTap: _showPrivacyPolicyDialog,
            ),

            // Sign Out
            _BottomTile(
              icon: Icons.logout,
              label: 'Sign Out',
              color: AppColors.primary,
              onTap: () => context.read<AuthCubit>().logout(context),
            ),

            // Delete Account
            _BottomTile(
              icon: Icons.delete_forever,
              label: 'Delete Account',
              color: Colors.red,
              onTap: _confirmDeleteAccount,
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Blood Bridge v1.0.0',
                style: TextStyleHelper.xs(context),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Request Tile (inside active requests sheet)
// ─────────────────────────────────────────────
class _RequestTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RequestTile({required this.data});

  static const _btMap = {
    'OPositive': 'O+',
    'ONegative': 'O−',
    'APositive': 'A+',
    'ANegative': 'A−',
    'BPositive': 'B+',
    'BNegative': 'B−',
    'ABPositive': 'AB+',
    'ABNegative': 'AB−',
  };

  String get _bloodType {
    final raw = data['bloodType']?.toString() ?? '';
    return _btMap[raw] ?? raw;
  }

  String get _urgency {
    final raw = (data['urgencyLevel'] ?? data['urgency'] ?? 'Normal')
        .toString()
        .toLowerCase();
    if (raw == 'critical') return 'Critical';
    if (raw == 'urgent') return 'Urgent';
    return 'Normal';
  }

  Color get _urgencyColor {
    if (_urgency == 'Critical') return const Color(0xFFE53935);
    if (_urgency == 'Urgent') return const Color(0xFFFF8F00);
    return const Color(0xFF4CAF50);
  }

  String get _timeAgo {
    final iso =
        data['createdAt']?.toString() ?? data['requestDate']?.toString();
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _urgencyColor.withOpacity(0.35), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _urgencyColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _bloodType,
                style: TextStyle(
                  color: _urgencyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _urgencyColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _urgency,
                        style: TextStyle(
                          color: _urgencyColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_timeAgo.isNotEmpty)
                      Text(
                        _timeAgo,
                        style: TextStyleHelper.xs(
                          context,
                        ).copyWith(color: AppColors.textMuted),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data['patientName']?.toString() ??
                      data['location']?.toString() ??
                      'Blood Request',
                  style: TextStyleHelper.small(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Action Tile
// ─────────────────────────────────────────────
class _BottomTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyleHelper.small(
                  context,
                ).copyWith(color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
