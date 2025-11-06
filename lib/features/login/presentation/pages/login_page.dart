import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_bloc.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_event.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    // Show SIM selection dialog immediately when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSimCardSelection();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeSimCardSelection() {
    if (_hasShownDialog) return;
    
    // Check permission first
    context.read<LoginBloc>().add(const CheckPhonePermission());
  }

  void _showSimSelectionDialog(List<dynamic> simCards) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select SIM Number'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: simCards.length,
              itemBuilder: (context, index) {
                final simCard = simCards[index];
                return ListTile(
                  leading: const Icon(Icons.sim_card),
                  title: Text(
                    simCard.phoneNumber,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: simCard.carrierName != null && simCard.carrierName!.isNotEmpty
                      ? Text(simCard.carrierName!)
                      : Text('SIM ${index + 1}'),
                  onTap: () {
                    context.read<LoginBloc>().add(SelectSimCard(simCard));
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleContinue() {
    final phoneNumber = _phoneController.text.trim();
    context.read<LoginBloc>().add(ContinueWithPhoneNumber(phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is PhonePermissionChecked) {
            if (state.hasPermission) {
              // Get SIM cards
              context.read<LoginBloc>().add(const GetSimCards());
            } else {
              // Request permission
              context.read<LoginBloc>().add(const RequestPhonePermission());
            }
          } else if (state is SimCardsLoaded) {
            if (!_hasShownDialog && state.simCards.isNotEmpty) {
              _hasShownDialog = true;
              _showSimSelectionDialog(state.simCards);
            }
            // Update phone controller if a number is selected
            if (state.selectedPhoneNumber != null) {
              _phoneController.text = state.selectedPhoneNumber!;
            }
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Continue with: ${state.phoneNumber}'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to next screen or perform login action here
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Mobile Number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : _handleContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                if (!_hasShownDialog && state is! SimCardsLoaded)
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            _hasShownDialog = false;
                            _initializeSimCardSelection();
                          },
                    child: const Text('Select from SIM cards'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}



