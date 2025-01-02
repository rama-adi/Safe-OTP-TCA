# SafeOTP
<img align="left" width="80" height="80" src="safeotp-icon.png" alt="SafeOTP Icon">
SafeOTP is a secure and feature-rich Time-based One-Time Password (TOTP) manager. It provides tools for generating TOTP codes, securely storing sensitive notes, and syncing data across devices via a WebSocket server. SafeOTP is designed with an emphasis on security and user convenience, offering a one-time device synchronization feature to ensure seamless setup without compromising data safety.

This is yet another showcase project for TCA (The Composable Architecture) and SwiftUI, built by the team at [Point-Free](https://www.pointfree.co). This uses the latest and greatest TCA powered with Observable Architecture, so if you're looking to learn more about TCA, this is a great place to start!

---

## Features

- **TOTP Code Generation**
  - Generate and manage TOTP codes for all your online accounts.
  - Compatible with services supporting 2FA (Two-Factor Authentication) using TOTP.
  - Stored accounts are encrypted using a Seed Phrase (BIP39 English Mnemonic).

- **Secured Notes**
  - Store sensitive notes such as passwords, recovery keys, and private information in an encrypted format.
  - Data is encrypted using a Seed Phrase (BIP39 English Mnemonic).
  - Encryption key is securely stored in the Keychain. Key verification is done every time the app is launched, the key in the keychain is compared with a hashed version of the seed phrase.

- **Device Syncing**
  - One-time synchronization across devices using a secure WebSocket connection (the receiver devices will give you the encryption code in the form of a QR code, which you can scan using the sender device).
  - Ensures data consistency without the need for cloud storage.

- **Future Support**
  - FaceID authentication for enhanced security and convenience.
  - Full two-way synchronization between devices, without the need for account creation or cloud storage.
  
---

## Built With

- **SwiftUI**: For building the user interface.
- **The Composable Architecture (TCA)**: For managing app state and business logic.
- **Keychain**: For secure storage of encryption keys.
- **Seed Phrase (BIP39)**: For generating encryption keys using English mnemonics.

---

## Current Progress

This app is still being developed on my spare time. I'm just working on the proof of concept. In the upcoming weeks, I'm going to implement all the MVP features and release the first version. Stay tuned!

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
