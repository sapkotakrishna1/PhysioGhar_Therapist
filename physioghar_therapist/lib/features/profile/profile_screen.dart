import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/therapist_provider.dart';
import '../complaints/complaints_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isNepali = false;

  @override
  Widget build(BuildContext context) {
    final therapist = ref.watch(therapistProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isNepali ? 'खाता' : 'Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 42,
            child: Text(
              therapist.name[0],
              style: const TextStyle(fontSize: 30),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              therapist.name,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow(
                    icon: Icons.email_outlined,
                    label: isNepali ? 'इमेल' : 'Email',
                    value: therapist.email,
                  ),
                  _infoRow(
                    icon: Icons.phone_outlined,
                    label: isNepali ? 'फोन' : 'Phone',
                    value: therapist.phone,
                  ),
                  _infoRow(
                    icon: Icons.medical_services_outlined,
                    label: isNepali ? 'विशेषज्ञता' : 'Specialization',
                    value: therapist.specialization,
                  ),
                  _infoRow(
                    icon: Icons.work_outline,
                    label: isNepali ? 'अनुभव' : 'Experience',
                    value: therapist.experience,
                  ),
                  _infoRow(
                    icon: Icons.location_on_outlined,
                    label: isNepali ? 'ठेगाना' : 'Address',
                    value: therapist.address,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const EditProfileScreen();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: Text(
                isNepali ? 'प्रोफाइल सम्पादन गर्नुहोस्' : 'Edit Profile',
              ),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(isNepali ? 'भाषा' : 'Language'),
              subtitle: Text(
                isNepali ? 'नेपाली / English' : 'English / नेपाली',
              ),
              trailing: Switch(
                value: isNepali,
                onChanged: (value) {
                  setState(() {
                    isNepali = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.report_problem_outlined),
              title: Text(isNepali ? 'गुनासो' : 'Complaints'),
              subtitle: Text(
                isNepali
                    ? 'समस्या वा गुनासो रिपोर्ट गर्नुहोस्'
                    : 'Report an issue or problem',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ComplaintsScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  late TextEditingController _emailController;

  late TextEditingController _phoneController;

  late TextEditingController _specializationController;

  late TextEditingController _experienceController;

  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    final therapist = ref.read(therapistProvider);

    _nameController = TextEditingController(text: therapist.name);

    _emailController = TextEditingController(text: therapist.email);

    _phoneController = TextEditingController(text: therapist.phone);

    _specializationController = TextEditingController(
      text: therapist.specialization,
    );

    _experienceController = TextEditingController(text: therapist.experience);

    _addressController = TextEditingController(text: therapist.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField(controller: _nameController, label: 'Name'),

            _textField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),

            _textField(
              controller: _phoneController,
              label: 'Phone',
              keyboardType: TextInputType.phone,
            ),

            _textField(
              controller: _specializationController,
              label: 'Specialization',
            ),

            _textField(controller: _experienceController, label: 'Experience'),

            _textField(controller: _addressController, label: 'Address'),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentTherapist = ref.read(therapistProvider);

    final updatedTherapist = currentTherapist.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      specialization: _specializationController.text.trim(),
      experience: _experienceController.text.trim(),
      address: _addressController.text.trim(),
    );

    ref.read(therapistProvider.notifier).updateTherapist(updatedTherapist);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Navigator.pop(context);
  }
}
