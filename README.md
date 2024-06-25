# HealthCare
## Deskripsi singkat 
Healthcare merupakan aplikasi reservasi dokter dengan berbagai fitur yang dapat membantu user untuk membeli obat, mencari lokasi klinik, mencari tau atau reservasi dokter yang sesuai.

## Design Figma (prototype)
![WelcomePage](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.52.20.png?raw=true)


![LoginPage](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.56.06.png?raw=true)


![RegisterPage](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.56.17.png?raw=true)


![Main Menu](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.56.49.png?raw=true)


![Doctor Page](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.57.01.png?raw=true)


![Doctor 1 page](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.57.08.png?raw=true)

![Schedule made](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2021.57.22.png?raw=true)

## Pembahasan
- Welcome Page
 ini adalah page awal dalam aplikasi. Disini terdapat 2 buah button yang mengarahkan user ke Login page atau Register page.

Tampilan: ![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2022.28.39.png?raw=true)

Kode untuk memindahkan dari welcome page ke Register page dan Login page:

    onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },

---

    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },


---
- Register Page
Didalam page ini kita bisa melakukan register menggunakan Email dan NIK dan data tersebut akan distore dalam firebase database.

Tampilan
![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2022.40.07.png?raw=true)


Kode untuk nge POST data user ke Firebase.



    Future<void> signUserUp(BuildContext context) async {
    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmpasswordController.text.isEmpty ||
          usernameController.text.isEmpty ||
          nikController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      if (passwordController.text == confirmpasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': usernameController.text,
          'nik': nikController.text,
          'email': emailController.text,
        });

        // Navigate to homepage if sign-up is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Show error message if passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Show an error message if sign-up fails
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    }

---
- Login Page
Di dalam page ini, kita bisa melakukan Login dengan data register yang sudah disimpan dalam Firebase. Bisa login menggunakan 1 Password dan 1 email/ menggunakan NIK.

Tampilan
![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2022.45.22.png?raw=true)

Kode untuk login ke aplikasi

    // Sign user in method
      Future<void> signUserIn(BuildContext context) async {
        try {
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill in both fields')),
            );
            return;
          }
    
          String input = emailController.text.trim();
          String password = passwordController.text.trim();
    
          // Check if input is an email or NIK
          String? email;
          if (input.contains('@')) {
            // Input is an email
            email = input;
          } else {
            // Input is assumed to be a NIK, get email from Firestore
            email = await _getEmailFromNik(input);
            if (email == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No user found for that NIK.')),
              );
              return;
            }
          }
    
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
    
          // Navigate to homepage if sign-in is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homepage()),
          );
        } on FirebaseAuthException catch (e) {
          // Show an error message if sign-in fails
          String message;
          if (e.code == 'user-not-found') {
            message = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            message = 'Wrong password provided.';
          } else {
            message = 'An error occurred. Please try again.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    
      // Method to get email from NIK
      Future<String?> _getEmailFromNik(String nik) async {
        try {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('nik', isEqualTo: nik)
              .limit(1)
              .get();
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.get('email');
          }
          return null;
        } catch (e) {
          print(e);
          return null;
        }
      }

--- 
- Homepage
Ini adalah bagian Beranda dari Aplikasi HealthCare. Dari homepage ini kita bisa mengakses fitur lain yang ada pada aplikasi.

Tampilan
![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2023.23.22.png?raw=true)

Kode ini digunakan untuk mendapatkan data dari koleksi "doctors" di Firestore.


      Future<Map<String, dynamic>> getData() async {
        QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.data() as Map<String, dynamic>;
        } else {
          return {};
        }
      }


kode untuk menampilkan our doctor dari database firestore.

 

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
                                                builder: (context) =>
                                                    DoctorMenu(doctorId: id),
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


---
- Medicine Page
Page ini digunakan untuk menampilkan obat dari database firestore.

Tampilan
![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2023.33.22.png?raw=true)

Kode ini untuk menampilkan obat sesuai dari database firestore.

      StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('medicine').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
    
                          final medicines = snapshot.data!.docs.where((doc) {
                            final name = doc['name'].toString().toLowerCase();
                            return name.contains(_searchQuery);
                          }).toList();
    
                          if (medicines.isEmpty) {
                            return const Center(child: Text('No medicines found'));
                          }

--- 
- Maps
Untuk menampilkan lokasi dari device yang digunakan dan mencari tempat yang akan dituju (klinik) tentu dengan persetujuan dari user jika ingin mengizinkan akses lokasi.

![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2023.37.54.png?raw=true)

Kode ini untuk meminta izin kepada user untuk mengakses fitur GPS pada Device.

     // Memeriksa status izin lokasi
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location permissions are denied')),
            );
            return;
          }
        }
    
        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Location permissions are permanently denied, we cannot request permissions')),
          );
          return;
        }

Kode ini untuk mendapatkan lokasi terkini user.
   

     Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _center = LatLng(position.latitude, position.longitude);
---

- Doctor Menu
Untuk melihat profile detail doktor yang tersedia di HealthCare.

Tampilan
![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2023.43.41.png?raw=true)

kode untuk mengambil data doctor dari firebase

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


---
- Kamera
Dapat mengakses kamera dari device untuk melakukan scan barcode dan qr. (fitur scan belum tersedia, hanya kameranya saja)

![enter image description here](https://github.com/AndrianKusumaP/Health-Care/blob/main/assets/FotoDump/Screenshot%202024-06-25%20at%2023.50.00.png?raw=true)

kode ini untuk menginisialisasi kamera yang tersedia pada device.

      Future<void> _initializeCamera() async {
        try {
          // Ambil kamera yang tersedia
          final cameras = await availableCameras();
    
          // Buat instance CameraController
          _controller = CameraController(cameras[0], ResolutionPreset.high);
    
          // Inisialisasi pengontrol kamera
          _initializeControllerFuture = _controller.initialize();
    
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        } catch (e) {
          // Tangani kesalahan
          print('Error initializing camera: $e');
        }
      }


## Instalasi Guide

1. Buat folder dengan nama bebas
2. Buka aplikasi Visual Studio Code
3. Open Folder yang telah dibuat tadi
4. Run Terminal
5. Ketik `git clone https://github.com/AndrianKusumaP/Health-Care ` Di terminal lalu tekan enter
6. Sekarang open folder yang sudah diclone (healthCare), folder yang diclone seharusnya ada pada folder di poin 1.
7. Setelah folder clone dibuka, `run` terminal dan ketik `flutter pub get`
8. Selesai, aplikasi sudah bisa di run melalui main.


## Link Youtube

[https://youtu.be/KLsl3mUBZvE](https://youtu.be/KLsl3mUBZvE)





