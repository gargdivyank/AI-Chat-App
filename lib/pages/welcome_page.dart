import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie animation package (optional)
import 'home_page.dart'; // Import the HomePage

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 168, 154, 207), // Attractive background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation (Optional)
            Lottie.asset(
              'assets/animations/Welcome.json', // Add a Lottie animation
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            // Welcome Text
            const Text(
              'Welcome to Gemini AI Chat!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Subtitle
            const Text(
              'Ask anything, get AI-powered responses instantly.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // "Ask Anything" Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                 elevation: 25, // Controls the height of the shadow
                 shadowColor: Colors.black.withOpacity(0.4),

              ),
              child: const Text(
                'Ask Anything',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
