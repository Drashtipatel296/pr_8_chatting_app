import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_8_chatting_app/controller/auth_controller.dart';
import 'package:pr_8_chatting_app/controller/theme_controller.dart';
import 'package:pr_8_chatting_app/helper/chat_services.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/helper/user_services.dart';
import 'package:pr_8_chatting_app/utils/profile_list.dart';
import 'package:pr_8_chatting_app/view/chat/chat_screen.dart';
import 'package:pr_8_chatting_app/view/login/login_screen.dart';
import 'package:pr_8_chatting_app/view/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffA8B0AF), width: 1),
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: RotationTransition(
                        turns: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    themeController.isDarkTheme.value
                        ? Icons.nights_stay
                        : Icons.wb_sunny,
                    key: ValueKey<bool>(themeController.isDarkTheme.value),
                  ),
                ),
                onPressed: () {
                  themeController.toggleTheme();
                },
              ),
            ),
          ),
        ),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Get.to(const ProfileScreen());
              },
              child: Obx(
                () => Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: authController.url.value.isNotEmpty
                          ? NetworkImage(authController.url.value)
                          : AssetImage('assets/img/homep.webp'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 110.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: statusData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 37,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              AssetImage(statusData[index]["image"]!),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        statusData[index]["name"]!,
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: themeController.containerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 3,
                      indent: 180,
                      endIndent: 180,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                      stream: UserServices.userServices.getUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if(snapshot.hasData){
                            List userList = snapshot.data!.docs.map((e) => e.data(),).toList();
                            return Expanded(
                              child: ListView.builder(
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  var user = userList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      authController.getReceiver(
                                        userList[index]['email'],
                                        userList[index]['name'],
                                        userList[index]['photoUrl'],
                                      );
                                      Get.to(
                                        ChatScreen(),
                                      );
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                        NetworkImage(user['photoUrl']),
                                      ),
                                      title: Text(
                                        user['name'],
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(user['email']),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else{
                            return const Center(
                              child: Text('No users found.'),
                            );
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xff24786D),
        selectedFontSize: 16,
        unselectedFontSize: 14,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 22,
              ),
              label: "Message"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
                size: 22,
              ),
              label: "Calls"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts,
                size: 21,
              ),
              label: "Contacts"),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Log Out",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      content: Text(
                        "Are you sure you want to log out?",
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            authController.emailSignOut();
                            Fluttertoast.showToast(
                              msg: "Logged out successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.of(context).pop();
                            Get.off(() => const LoginScreen());
                          },
                          child: Text(
                            "Yes",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "No",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.logout_sharp,
                size: 22,
              ),
            ),
            label: "Log Out",
          ),
        ],
      ),
    );
  }
}
