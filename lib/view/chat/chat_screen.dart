import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pr_8_chatting_app/controller/auth_controller.dart';
import 'package:pr_8_chatting_app/helper/api_services.dart';
import 'package:pr_8_chatting_app/helper/chat_services.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/model/chat_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey,
          title: Obx(() => Row(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(controller.receiverImageUrl.value),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.receiverName.value,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Active now',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              )),
          actions: [
            const Icon(
              Icons.call,
              size: 22,
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.video_camera_back,
                size: 22,
              ),
              onPressed: () {},
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: ChatServices.chatServices.getData(
                      GoogleSignInServices.googleSignInServices
                          .currentUser()!
                          .email!,
                      controller.receiverEmail.value),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var queryData = snapshot.data!.docs;
                    List chats = queryData.map((e) => e.data()).toList();
                    List<ChatModel> chatList = [];
                    List chatId = queryData
                        .map(
                          (e) => e.id,
                        )
                        .toList();

                    for (var chat in chats) {
                      chatList.add(ChatModel.fromMap(chat));
                    }

                    return SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: List.generate(
                            chatList.length,
                            (index) {
                              var chat = chatList[index];
                              if (chatList[index].read == false &&
                                  chatList[index].receiver ==
                                      GoogleSignInServices.googleSignInServices
                                          .currentUser()!
                                          .email!) {
                                ChatServices.chatServices
                                    .updateReadMsg(
                                    controller.receiverEmail.value,
                                    chatId[index],
                                    controller.email.value);
                              }
                              var formatedTime = chat.timestamp != null
                                  ? DateFormat('hh:mm a')
                                      .format(chat.timestamp!.toDate())
                                  : '';
                              bool isCurrentUser = chatList[index].sender ==
                                  GoogleSignInServices.googleSignInServices
                                      .currentUser()!
                                      .email!;

                              return Align(
                                alignment: (chatList[index].sender ==
                                        GoogleSignInServices
                                            .googleSignInServices
                                            .currentUser()!
                                            .email!)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: (chatList[index].sender ==
                                          GoogleSignInServices
                                              .googleSignInServices
                                              .currentUser()!
                                              .email!)
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        showBottomSheet(
                                          context: context, builder: (context) {
                                          return Text('');
                                        },);
                                        // if (chatList[index].sender ==
                                        //     GoogleSignInServices.googleSignInServices.currentUser()!.email) {
                                        //         controller.txtEditMsg = TextEditingController(
                                        //     text: chatList[index].msg,
                                        //   );
                                        //
                                        //   showDialog(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return AlertDialog(
                                        //         title: const Text('Edit'),
                                        //         content: TextField(
                                        //           controller:
                                        //               controller.txtEditMsg,
                                        //         ),
                                        //         actions: [
                                        //           TextButton(
                                        //             onPressed: () {
                                        //               ChatServices.chatServices
                                        //                   .editMsg(
                                        //                       sender:
                                        //                           controller
                                        //                               .email
                                        //                               .value,
                                        //                       receiver: controller
                                        //                           .receiverEmail
                                        //                           .value,
                                        //                       chatId:
                                        //                           chatId[index],
                                        //                       msg: controller
                                        //                           .txtEditMsg
                                        //                           .text);
                                        //               Get.back();
                                        //             },
                                        //             child: const Text('Edit'),
                                        //           ),
                                        //           TextButton(
                                        //             onPressed: () {
                                        //               ChatServices.chatServices
                                        //                   .deleteMsg(
                                        //                 sender: controller
                                        //                     .email.value,
                                        //                 receiver: controller
                                        //                     .receiverEmail
                                        //                     .value,
                                        //                 chatId: chatId[index],
                                        //               );
                                        //               Get.back();
                                        //             },
                                        //             child: const Text('Delete'),
                                        //           ),
                                        //         ],
                                        //       );
                                        //     },
                                        //   );
                                        // }
                                      },
                                      child: Card(
                                        color: isCurrentUser
                                            ? const Color(0xff20A090)
                                            : const Color(0xffF2F7FB),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6,
                                                  right: 6,
                                                  top: 6,
                                                  bottom: 6),
                                              child: chatList[index].mediaUrl !=
                                                      null
                                                  ? Image.network(
                                                      chatList[index].mediaUrl!,
                                                      width: 200,
                                                      height: 300,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Text(
                                                      chatList[index].msg!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: isCurrentUser
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          (chatList[index].sender ==
                                                  GoogleSignInServices
                                                      .googleSignInServices
                                                      .currentUser()!
                                                      .email!)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        (chatList[index].read &&
                                                chatList[index].sender ==
                                                    GoogleSignInServices
                                                        .googleSignInServices
                                                        .currentUser()!
                                                        .email!)
                                            ? Icon(
                                                Icons.done_all_rounded,
                                                color: Colors.blue.shade400,
                                                size: 18,
                                              )
                                            : Container(),
                                        Text(
                                          formatedTime,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xff797C7B),
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF3F6F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controller.txtMsg,
                        cursorColor: const Color(0xff20A090),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Write your message',
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          suffixIcon: Image.asset('assets/img/copy.png'),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        await controller.sendMediaFile(
                          File(image.path),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Map<String, dynamic> chat = {
                        'sender': GoogleSignInServices.googleSignInServices
                            .currentUser()!
                            .email,
                        'receiver': controller.receiverEmail.value,
                        'msg': controller.txtMsg.text,
                        'timestamp': DateTime.now(),
                        'status': null,
                      };
                      ChatServices.chatServices.insertChat(
                          chat,
                          GoogleSignInServices.googleSignInServices
                              .currentUser()!
                              .email!,
                          controller.receiverEmail.value);

                      ApiServices.apiServices.sendMessage(
                          controller.currentLogin.value,
                          controller.txtMsg.text,
                          controller.receiverToken.value,
                      );

                      controller.txtMsg.clear();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff20A090),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset('assets/img/send.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
