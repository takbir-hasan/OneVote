import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildExpansionTile(
                title: 'Our Mission',
                content:
                    'Our mission is to provide a secure and transparent platform for online voting, ensuring that every voice counts and every vote is protected. We aim to make the voting process easier, faster, and more accessible to everyone.',
              ),
              _buildExpansionTile(
                title: 'How We Work',
                content:
                    'Our platform uses cutting-edge technology to offer a secure, transparent, and user-friendly voting experience. Voters can cast their votes using their mobile phones or computers, and results are displayed in real-time. We adhere to the highest standards of privacy and security.',
              ),
              _buildExpansionTile(
                title: 'Why Choose Us?',
                content:
                    'We provide a reliable, accessible, and secure voting system with a focus on ease of use. Whether for local elections, organizational decisions, or surveys, our platform offers accurate results and a hassle-free experience. We believe in democracy, transparency, and user empowerment.',
              ),
              _buildExpansionTile(
                title: 'Our Vision',
                content:
                    'Our vision is to become the leading platform for online voting, helping organizations, governments, and communities to make decisions efficiently and securely. We strive to innovate and improve the democratic process for the betterment of society.',
              ),
              _buildExpansionTile(
                title: 'Our Team Members',
                content: '''
                  1. Sajid Hasan Takbir - CEO\n
                  2. Md Saniul Basir Saz - CTO\n
                ''',
              ),
              _buildExpansionTile(
                title: 'Payment Agreement',
                content:
                    'Our platform accepts various forms of payment including credit cards, debit cards, and digital wallets. Payments are securely processed through our trusted payment partners. By using our platform, you agree to the payment terms which include timely payment for voting services, refunds (if applicable), and all associated fees. Please refer to our Terms of Service for more details.',
              ),
              _buildExpansionTile(
                title: 'Voting Security Details',
                content:
                    'We take security very seriously. Our voting platform is protected by advanced encryption methods, ensuring that your votes are private and secure. We implement multi-factor authentication for users to access their accounts and use blockchain technology to verify the integrity of each vote. Additionally, we continuously monitor for any suspicious activity and adhere to best practices in cybersecurity to protect voter data.',
              ),
              _buildExpansionTile(
                title: 'Contact Us',
                content:
                    'Have any questions or feedback? Reach out to us at contact@votingapp.com. We are here to help you with any inquiries or support you might need.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build each ExpansionTile with Card
  Widget _buildExpansionTile({required String title, required String content}) {
    return Card(
      elevation: 4.0,
      // Adds shadow to the card for a material look
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      // Space between cards
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for the card
      ),
      color: Colors.transparent,
      // Transparent card background
      child: Container(
        color: Colors.white, // White background for the ExpansionTile content
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content),
            ),
          ],
        ),
      ),
    );
  }
}
