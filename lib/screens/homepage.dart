import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uts/screens/doctor_details.dart';
import 'package:uts/screens/medicine.dart';

class homepage extends StatefulWidget {
  homepage({super.key});
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username = "";

  Future<Map<String, dynamic>> getData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        username = userDoc['username'];
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/hutao.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hello', style: TextStyle(fontSize: 15)),
                        Text(
                          '$username!',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.blue.shade900),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.mapLocationDot,
                                  color: Colors.white,
                                )),
                              ),
                              const SizedBox(height: 10.0),
                              const Text('Map'),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.circular(
                                        10.0)), // Warna isi kotak
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.list,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text('List Doctor')
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Medicine()),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade900,
                                      borderRadius: BorderRadius.circular(
                                          10.0)), // Warna isi kotak
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.kitMedical,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                const Text('Medicine')
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.circular(
                                        10.0)), // Warna isi kotak
                                child: const Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text('More')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                      child: Image.asset(
                        "assets/images/Doctor.png",
                        scale: 0.5,
                        width: 120.0,
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Have a routine checkup \nwith our doctor',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () => {},
                                  style: TextButton.styleFrom(
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      foregroundColor: Colors.blue.shade900,
                                      backgroundColor: Colors.white),
                                  child: const Text('Find Now')),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Check Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    "In Current 7 Days",
                                    style: TextStyle(fontSize: 12.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    shape: BoxShape.circle),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.pen,
                                    size: 24.0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Recepies",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color:
                                            Color.fromARGB(255, 18, 79, 170)),
                                  ),
                                  Text(
                                    "Your recepies",
                                    style: TextStyle(fontSize: 12.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.purple[100],
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FaIcon(
                                    // ignore: deprecated_member_use
                                    FontAwesomeIcons.history, size: 20.0,
                                    color: Colors.purple[500],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "History",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color:
                                            Color.fromARGB(255, 175, 47, 197)),
                                  ),
                                  Text(
                                    "In Current 30 Days",
                                    style: TextStyle(fontSize: 12.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    shape: BoxShape.circle),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.calendar,
                                    size: 21,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reminder",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    "Today",
                                    style: TextStyle(fontSize: 12.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  height: 200,
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Our Doctor',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('tap');
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'View More',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('doctors')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else {
                            final doctors = snapshot.data!.docs;
                            if (doctors.isEmpty) {
                              return const Center(child: Text("No Data Found"));
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: doctors.map((doctor) {
                                    final imageUrl = doctor['image'];
                                    final name = doctor['name'];
                                    final specialist = doctor['specialist'];
                                    final id = doctor.id;

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DoctorDetailsScreen(doctorId: id),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 130,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 130,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.white,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 130,
                                              width: 100,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      specialist,
                                                      style: const TextStyle(
                                                          fontSize: 10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 50.0,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
