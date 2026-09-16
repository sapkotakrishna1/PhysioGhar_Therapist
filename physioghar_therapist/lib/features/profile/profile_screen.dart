import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/providers/therapists_provider.dart';

//import '../../providers/therapist_provider.dart';
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
    final therapistAsync = ref.watch(therapistProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isNepali ? 'खाता' : 'Account')),
      body: therapistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(
                  isNepali
                      ? 'प्रोफाइल लोड गर्न सकिएन'
                      : 'Unable to load profile',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(therapistProvider);
                  },
                  child: Text(isNepali ? 'पुन: प्रयास' : 'Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (therapist) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 42,
                child: Text(
                  therapist.name.isNotEmpty
                      ? therapist.name[0].toUpperCase()
                      : 'T',
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
                        value: '${therapist.experience} years',
                      ),

                      _infoRow(
                        icon: Icons.info_outline,
                        label: isNepali ? 'बायो' : 'Bio',
                        value: therapist.bio.isEmpty
                            ? isNepali
                                  ? 'बायो उपलब्ध छैन'
                                  : 'No bio available'
                            : therapist.bio,
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
          );
        },
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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();

  bool _controllersInitialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final therapistAsync = ref.watch(therapistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: therapistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load profile.', textAlign: TextAlign.center),
          ),
        ),
        data: (therapist) {
          if (!_controllersInitialized) {
            _nameController.text = therapist.name;
            _emailController.text = therapist.email;
            _phoneController.text = therapist.phone;
            _specializationController.text = therapist.specialization;
            _experienceController.text = therapist.experience.toString();
            _bioController.text = therapist.bio;

            _controllersInitialized = true;
          }

          return Form(
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

                _textField(
                  controller: _experienceController,
                  label: 'Experience',
                  keyboardType: TextInputType.number,
                ),

                _textField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final experience = int.tryParse(_experienceController.text.trim());

    if (experience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Experience must be a valid number.')),
      );
      return;
    }

    final therapistAsync = ref.read(therapistProvider);

    final currentTherapist = therapistAsync.value;

    if (currentTherapist == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load current profile.')),
      );
      return;
    }

    final updatedTherapist = currentTherapist.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      specialization: _specializationController.text.trim(),
      experience: experience,
      bio: _bioController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(therapistProvider.notifier)
          .updateTherapist(updatedTherapist);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
