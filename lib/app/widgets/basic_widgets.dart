import 'package:flutter/material.dart';

class BasicWidget {
  Widget noInternetWidget(BuildContext context) {
    return SizedBox(
      // Background color for no internet
      height: MediaQuery.of(context).size.height, // Full screen height
      width: MediaQuery.of(context).size.width, // Full screen width
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 100, color: Colors.grey),
          // No internet icon
          SizedBox(height: 20),
          Text(
            "No Internet Connection!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Please check your network settings and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget getFilterButton(String buttonText, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(left: 5.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent, // Transparent border for gradient effect
        ),
        gradient: const LinearGradient(
          colors: [Colors.grey, Colors.green, Colors.yellow],
          // Silver, Green, Yellow gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(1),
      // Padding for the gradient border effect
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background inside the border
          borderRadius:
              BorderRadius.circular(6), // Slightly smaller for inner content
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.black, // Text color inside the button
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
