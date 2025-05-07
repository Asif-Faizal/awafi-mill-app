import 'package:awafi/features/dashboard/presentation/address_screen.dart';
import 'package:awafi/features/dashboard/presentation/profile_screen.dart';
import 'package:awafi/features/orders/presentation/purchase_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awafi/features/login/presentation/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // Utility function to show loading dialog
  static void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if the JWT token exists
    return prefs.containsKey('jwtToken');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn(),
      builder: (context, snapshot) {
        // Show a loading indicator while checking token
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If token is not present, show login prompt
        if (!snapshot.hasData || snapshot.data == false) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Account'),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Image.asset('lib/core/assets/error.png'),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'You are not logged in. Please log in to continue.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF414851),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (r) => false,
                            );
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }

        // If token is present, show the account details
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              const Text('Logout'),
              const SizedBox(width: 10),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF161A1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
            ],
            leading: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF161A1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            children: [
              const SizedBox(height: 20),
              _buildCard(
                context,
                'Profile',
                'Manage your profile information',
                'lib/core/assets/profile.png',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              _buildCard(
                context,
                'Address',
                'Manage your shipping addresses',
                'lib/core/assets/address.png',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddressScreen()));
                },
              ),
              _buildCard(
                context,
                'Purchase History',
                'View your purchase history',
                'lib/core/assets/faq.png',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PurchaseHistoryScreen()));
                },
              ),
              _buildCard(
                context,
                'Frequently Asked Questions',
                'Find answers to common questions',
                'lib/core/assets/help.png',
                onTap: () {
                  // Navigate to FAQ screen
                },
              ),
              _buildCard(
                context,
                'Help and Support',
                'Get help and support from our team',
                'lib/core/assets/support.png',
                onTap: () {
                  // Navigate to Help and Support
                },
              ),
              _buildCard(
                context,
                'Delete Account',
                'Delete your account and all associated data',
                'lib/core/assets/support.png',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text('Delete Account'),
                      content: Text(
                          'Are you sure you want to delete your account? This may clear all your data from our database.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // Close confirmation dialog
                            
                            // Show loading dialog
                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Deleting account...'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            
                            // Add a small delay to ensure dialog is shown
                            await Future.delayed(const Duration(milliseconds: 100));
                            
                            try {
                              // Get the last login email
                              final prefs = await SharedPreferences.getInstance();
                              final lastLoginEmail = prefs.getString('last_login_email');
                              
                              // Store the deleted email
                              List<String> deletedEmails = prefs.getStringList('deleted_emails') ?? [];
                              if (lastLoginEmail != null) {
                                deletedEmails.add(lastLoginEmail);
                              }
                              
                              // Clear preferences but save the deleted emails list
                              await prefs.clear();
                              
                              // Restore the deleted emails list
                              await prefs.setStringList('deleted_emails', deletedEmails);
                              
                              // Ensure context is still valid before navigation
                              if (!context.mounted) return;
                              
                              // Close the loading dialog
                              Navigator.of(context).pop();
                              
                              // Navigate to login screen
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              // If there's an error, close the loading dialog
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to delete account. Please try again.'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    String assetPath, {
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFFAFB5BB),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        leading: Image.asset(assetPath, scale: 3),
        title: Text(title, style: const TextStyle(fontSize: 18.0)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
