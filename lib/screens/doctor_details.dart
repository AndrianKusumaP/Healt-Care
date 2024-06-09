import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DoctorDetailsScreen extends StatelessWidget {
  final String doctorId;

  const DoctorDetailsScreen({Key? key, required this.doctorId}) : super(key: key);

  // void _onNavBarTap(BuildContext context, int index) {
  //   // Implement navigation logic 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('doctors').doc(doctorId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            final doctorData = snapshot.data!;
            Map<String, dynamic> data = doctorData.data() as Map<String, dynamic>;
            String doctorName = data['name'] ?? 'Tidak tersedia';
            String specialist = data['specialist'] ?? 'Tidak tersedia';
            String imageUrl = data['image'] ?? '';
            String bio = data['bio'] ?? 'Tidak tersedia';

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor's Profile Picture
                  Container(
                    width: double.infinity,
                    height: 200, // Ptinggi untuk gambar
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : AssetImage('assets/images/doctor_profile.jpg') as ImageProvider,
                        fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area tanpa distorsi
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Doctor's Name and Specialization
                  Text(
                    doctorName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    specialist,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Doctor's Bio
                  Text(
                    bio,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Button to Book Appointment
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: Text('Book Appointment'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidBell),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'Settings',
          ),
        ],
        currentIndex: 0, 
        selectedItemColor: Colors.blue[800],
      ),
    );
  }
}


