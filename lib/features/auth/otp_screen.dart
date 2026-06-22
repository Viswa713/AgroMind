import 'package:flutter/material.dart';
import '../../app/app_state.dart';

class OtpScreen extends StatefulWidget {
  final AppState state;

  const OtpScreen({super.key, required this.state});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verifyOtp() async {
    if (otpController.text.trim() != "1234") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    // ✅ STEP 1: login state
    widget.state.loginSuccess();

    // ✅ STEP 2: IMPORTANT → do NOT navigate to Soil/Profile directly
    // Instead reset to home tab
    widget.state.setTab(TabType.home);

    setState(() => isLoading = false);

    // ✅ STEP 3: clear navigation stack back to root shell
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF4),
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: isLoading ? null : verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}