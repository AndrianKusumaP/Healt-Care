import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorMenu extends StatelessWidget {
  final String doctorId;

  const DoctorMenu({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('doctors').doc(doctorId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found'));
        } else {
          final doctorData = snapshot.data!;
          Map<String, dynamic> data = doctorData.data() as Map<String, dynamic>;
          String name = data['name'] ?? 'Tidak Tersedia';
          String specialist = data['specialist'] ?? 'Tidak Tersedia';
          String imageUrl = data['image'] ?? '';
          String bio = data['bio'] ?? 'Tidak Tersedia';

          return Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/images/doctor_profile.jpg') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromRGBO(32, 82, 149, 1)
                                  .withOpacity(0.9),
                              const Color.fromRGBO(32, 82, 149, 1)
                                  .withOpacity(0.3),
                              const Color.fromRGBO(32, 82, 149, 1).withOpacity(0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, top: 30, right: 20),
                            ),
                            SizedBox(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Patients",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "1.2K",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Experience",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "40 yr",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Schedule",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "10.00-18.00",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color.fromRGBO(28, 101, 211, 1),
                              fontSize: 28,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                specialist,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            bio,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Book Date",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(28, 101, 211, 1)
                                .withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Container(
                                    margin: const EdgeInsetsDirectional.symmetric(
                                        horizontal: 8, vertical: 5),
                                    padding: const EdgeInsetsDirectional.symmetric(
                                        vertical: 5, horizontal: 25),
                                    decoration: BoxDecoration(
                                        color: index == 1
                                            ? const Color.fromRGBO(28, 101, 211, 1)
                                            : const Color(0xFFF2F8FF),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${index + 8}",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: index == 1
                                                ? Colors.white
                                                : Colors.black.withOpacity(0.6),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          "APR",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: index == 1
                                                  ? Colors.white
                                                  : Colors.black.withOpacity(0.6)),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Book Time",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Color.fromRGBO(28, 101, 211, 0.6),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 11,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 8, vertical: 5),
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: index == 2
                                        ? const Color.fromRGBO(28, 101, 211, 1)
                                        : const Color(0xFFF2F8FF),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          spreadRadius: 2),
                                    ]),
                                child: Center(
                                    child: Text(
                                  "${index + 8}: 00",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 17,
                                    color: index == 2
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.6),
                                  ),
                                )),
                              );
                            },
                          ),
                        ),
                          const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: const Text('Book Appointment'),
                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: 0,
              selectedItemColor: Colors.blue[800],
            ),
          );
        }
      },
    );
  }
}
