import 'package:computer_price/components/Pc_Details.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Center(
              child: Text('Price Predictor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ))),
          backgroundColor: const Color.fromARGB(255, 11, 147, 189),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      'https://m.media-amazon.com/images/G/31/Laptops/July24_Laptop_CLP_Targeting/Smartchoice_Header_1400._CB567444914_.gif',
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 20,
                      child: Text(
                        'Complex Layout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Welcome to Computer Price App',
                      style: TextStyle(fontSize: 25)),
                ),
                Text(
                  'Please enter the details of the computer you want to buy',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                PcDetails(),
              ],
            ),
          ),
        ));
  }
}
