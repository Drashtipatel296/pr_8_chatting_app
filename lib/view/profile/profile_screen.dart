import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_8_chatting_app/controller/theme_controller.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/helper/user_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: UserServices.userServices.getCurrentUser(
            GoogleSignInServices.googleSignInServices.currentUser()!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading ....');
          }
          Map<String, dynamic> currentUser = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              SizedBox(
                height: 310,
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(currentUser['photoUrl']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      currentUser['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      currentUser['email'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 45,
                      width: 275,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/icons.png'),
                        ),
                      ),
                    ),
                  ],
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 3,
                            indent: 170,
                            endIndent: 170,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Image.asset('assets/img/key.png'),
                            title: Text(
                              '  Account',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '  Privacy, security, change number',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff797C7B), fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Image.asset('assets/img/chat.png'),
                            title: Text(
                              '  Chat',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '  Chat history,theme,wallpapers',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff797C7B), fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Image.asset('assets/img/notification.png'),
                            title: Text(
                              '  Notification',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '  Messages, group and others',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff797C7B), fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Image.asset('assets/img/help.png'),
                            title: Text(
                              '  Help',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '  Help center,contact us, privacy policy',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff797C7B), fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Image.asset('assets/img/data.png'),
                            title: Text(
                              '  Storage and data',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '  Network usage, storage usage',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff797C7B), fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListTile(
                            leading: Image.asset('assets/img/user.png'),
                            title: Text(
                              '  Invite a friend',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
