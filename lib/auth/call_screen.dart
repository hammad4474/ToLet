import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCallScreen extends StatelessWidget {
  final String callID;
  final bool isOwner; // If the current user is an owner or tenant

  AudioCallScreen({required this.callID, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(isOwner ? "Owner Audio Call" : "Tenant Audio Call"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
          },
        ),
      ),
      body: ZegoUIKitPrebuiltCall(
        appID: 2042440916, // Replace with your Zego AppID
        appSign:
            'ebe358c62a0e1ebb8313993f0f0b350c077b8d2bb6dd89666c959cb1d0a9119b', // Replace with your Zego AppSign
        userID:
            'user_${DateTime.now().millisecondsSinceEpoch}', // Unique user ID for the current user
        userName: isOwner ? 'Owner' : 'Tenant', // User name, Owner or Tenant
        callID: callID, // Unique call ID for the session
        config: ZegoUIKitPrebuiltCallConfig
            .oneOnOneVoiceCall(), // Configuration for one-on-one voice call
      ),
    );
  }
}
