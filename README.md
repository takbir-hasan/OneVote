# OneVote Application

## Introduction
The **OneVote Application** is a user-friendly and secure voting platform that provides an easy way to conduct and manage polls. This application enables users to quickly create Polls and cast their votes. It includes a secure payment system, unique voter IDs. OneVote offers a simple and efficient platform that keeps the voting process transparent and secure.

---

## Technology and Tools
- **Frontend**: Flutter, Dart
- **Backend**: Firebase Firestore, Firebase Functions
- **Payment Gateways**: Bkash Payment Gateway, Uddokta Payment Gateway
- **Development Tools**: Visual Studio Code, Android Studio
- **Version Control**: Git, GitHub

---
## OneVote Design
You can view the OneVote design below:
[Images](https://www.canva.com/design/DAGcuy_P6Ns/ABtgXOYltWZcNVMekgV-rQ/view?utm_content=DAGcuy_P6Ns&utm_campaign=designshare&utm_medium=embeds&utm_source=link)

## Implemented Features

### 1. User Profile
- Users can create and manage their profiles.
- Profiles include basic information and a history of past polls.
- Users can update their profile information (e.g., name, email, and contact details).

### 2. Admin Profile
- Admins can view total earnings generated from polls, including payments for voter registrations.

### 3. Set Price Per Voter
- Admins can define a cost per voter while creating polls.
- Payment amount is calculated based on the number of registered voters.

### 4. Create Poll
- Polls can be created with details such as title, description, and time window.

### 5. Add Voters
- Users can upload voter lists in CSV file format via email.
- Each voter receives a unique voter ID via email after being added to a poll.

### 6. Payment System
- Integrated **Bkash** and **Uddokta Mobile Banking** for smooth and secure payments.
- Users can pay for poll creation and voter registration through these gateways.

### 7. Notifications
- Our app supports sending notifications to users for real-time updates and alerts. This feature ensures that users stay informed about important activities, updates, or changes within the application.

### 8. Feedback System
- Users can share their voting experience through a feedback form.
- Feedback is stored for future improvements to the platform.

### 9. User Login & Sign-Up
- A simple and secure registration system allows users to sign up with an email and password.

### 11. Unique Voter ID System
- Each registered voter receives a unique ID via email when a poll is created.
- This ID is used to cast votes anonymously, ensuring data integrity and voter privacy.

### 12. Home Page
- Displays a list of Paid Polls available for participation.

### 13. Poll Creator Access to Results
- Poll creators are redirected to the Results Page upon clicking a poll.
- The Results Page displays running and completed poll statuses.

### 14. Validation for Other Users
- Ensures users are authorized to participate in the poll.
- Valid users are redirected to the Voting Page to cast their votes.

### 15. Vote Casting Page
- The Voting Page will allow users to:
  - Cast their votes securely and anonymously.

---

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/takbir-hasan/OneVote.git
   ```

2. Navigate to the project directory:
   ```bash
   cd onevote
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Configure Firebase:
   - Add your Firebase configuration file (`google-services.json`) to the `android/app` directory.

5. Run the application:
   ```bash
   flutter run -t lib\widgets\main.dart
   ```

---

## Contact
For more information or queries, please contact:
- **Name**: Md Saniul Basir Saz
- **Email**: saniul.cse.just@gmail.com
- **LinkedIn**: [Md Saniul Basir Saz](https://www.linkedin.com/in/md-saniul-basir-saz/)
---
- **Name**: Sajid Hasan Takbir
- **Email**: takbirhasan274@gmail.com
- **LinkedIn**: [Sajid Hasan Takbir](https://www.linkedin.com/in/sajid-hasan-takbir/)
