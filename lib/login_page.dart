import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    // Show SIM selection dialog immediately when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSimSelectionDialog();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showSimSelectionDialog() async {
    if (_hasShownDialog) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Check and request permissions
      bool? hasPermission = await MobileNumber.hasPhonePermission;
      
      if (hasPermission == false) {
        await MobileNumber.requestPhonePermission;
        hasPermission = await MobileNumber.hasPhonePermission;
      }

      if (hasPermission == true) {
        // Get SIM cards - try accessing as getter first, then as function
        List<SimCard>? simCards;
        try {
          // Try as getter (Future<List<SimCard>>)
          final future = MobileNumber.getSimCards;
          if (future != null) {
            simCards = await future;
          }
        } catch (e) {
          debugPrint('Error getting SIM cards: $e');
          simCards = null;
        }
        
        if (simCards == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasShownDialog = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SIM card access not available on this device'),
              ),
            );
          }
          return;
        }
        
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasShownDialog = true;
          });

          if (simCards.isNotEmpty) {
            // Show dialog with SIM card options
            _displaySimSelectionDialog(simCards);
          } else {
            // No SIM cards found
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No SIM cards found on this device'),
                ),
              );
            }
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasShownDialog = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission denied. Please grant phone permission to continue.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasShownDialog = true;
        });
        // Handle error gracefully - show dialog with message or allow manual entry
        debugPrint('Error fetching SIM cards: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accessing SIM cards: $e'),
          ),
        );
      }
    }
  }

  void _displaySimSelectionDialog(List<SimCard> simCards) {
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
                // Access properties dynamically as mobile_number package API may vary
                final dynamic simCardDynamic = simCard;
                final phoneNumber = simCardDynamic.line1Number ?? 
                                    simCardDynamic.number ?? 
                                    simCardDynamic.phoneNumber ?? 
                                    'Unknown';
                final carrierName = simCardDynamic.carrierName ?? '';
                
                return ListTile(
                  leading: const Icon(Icons.sim_card),
                  title: Text(
                    phoneNumber,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: carrierName.isNotEmpty
                      ? Text(carrierName)
                      : Text('SIM ${index + 1}'),
                  onTap: () {
                    _phoneController.text = phoneNumber;
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
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a mobile number'),
        ),
      );
      return;
    }

    // Handle continue action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continue with: $phoneNumber'),
      ),
    );
    // Navigate to next screen or perform login action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
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
              enabled: !_isLoading,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
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
            if (!_hasShownDialog)
              TextButton(
                onPressed: _isLoading ? null : _showSimSelectionDialog,
                child: const Text('Select from SIM cards'),
              ),
          ],
        ),
      ),
    );
  }
}

