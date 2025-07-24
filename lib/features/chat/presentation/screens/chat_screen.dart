import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/home/client-details/chat';

  const ChatScreen({super.key});

  @override
  Widget build(context) {
    final controller = Get.find<ChatController>();
    final args = Get.arguments as Map<String, dynamic>;
    final participantId = args['participantId'] as String;

    controller.setupChat(participantId);

    return Scaffold(
      backgroundColor: AdminTheme.colors['background'],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _buildHeader(controller),
      ),
      body: Obx(() {
        if (controller.isLoadingMessages.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  if (msg.isAudio) {
                    return _buildAudioPlayer(msg.audioUrl, controller);
                  } else {
                    return ListTile(
                      title: Align(
                        alignment:
                            msg.senderId ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color:
                                msg.senderId ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? AdminTheme.colors['primary']
                                : AdminTheme.colors['surfaceVariant'],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                msg.senderId ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.content,
                                style: AdminTheme.textStyles['bodyMedium']
                                    ?.copyWith(
                                      color:
                                          msg.senderId ==
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  ?.uid
                                          ? AdminTheme.colors['onPrimary']
                                          : AdminTheme.colors['onSurface'],
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('hh:mm a').format(msg.timestamp),
                                    style: AdminTheme.textStyles['bodySmall']
                                        ?.copyWith(
                                          color: AdminTheme
                                              .colors['onSurfaceVariant'],
                                        ),
                                  ),
                                  if (msg.senderId ==
                                      FirebaseAuth
                                          .instance
                                          .currentUser
                                          ?.uid) ...[
                                    SizedBox(width: 4.w),
                                    _buildMessageStatusIcon(msg.status),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onLongPress: () {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              'Message Options',
                              style: AdminTheme.textStyles['titleMedium'],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(
                                    'Copy',
                                    style: AdminTheme.textStyles['bodyMedium'],
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: msg.content),
                                    );
                                    Get.back();
                                    Get.snackbar(
                                      'Copied',
                                      'Message copied to clipboard',
                                      backgroundColor:
                                          AdminTheme.colors['primary'],
                                      colorText: AdminTheme.colors['onPrimary'],
                                    );
                                  },
                                ),
                                ListTile(
                                  title: Text(
                                    'Delete',
                                    style: AdminTheme.textStyles['bodyMedium']
                                        ?.copyWith(
                                          color: AdminTheme.colors['error'],
                                        ),
                                  ),
                                  onTap: () {
                                    controller.deleteMessages(msg.id);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            _buildMessageInput(controller),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(ChatController controller) {
  return SafeArea(
    bottom: false, // we only care about top padding here
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AdminTheme.colors['surface'],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AdminTheme.colors['primary']),
            onPressed: () => Get.back(),
          ),
          Obx(() => CircleAvatar(
                radius: 16.r,
                backgroundImage: CachedNetworkImageProvider(
                  controller.participantImage.value.isNotEmpty
                      ? controller.participantImage.value
                      : 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                ),
              )),
          SizedBox(width: 8.w),
          Obx(() => Text(
                controller.participantName.value,
                style: AdminTheme.textStyles['titleMedium']?.copyWith(
                  color: AdminTheme.colors['onSurface'],
                ),
              )),
          const Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AdminTheme.colors['primary']),
            onSelected: (value) {
              if (value == 'delete') {
                Get.dialog(
                  AlertDialog(
                    title: Text('Delete Chat', style: AdminTheme.textStyles['titleMedium']),
                    content: Text('Are you sure you want to delete this chat?', style: AdminTheme.textStyles['bodyMedium']),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel', style: AdminTheme.textStyles['bodyMedium']),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteChats();
                          Get.back();
                        },
                        child: Text('Delete', style: AdminTheme.textStyles['bodyMedium']?.copyWith(color: AdminTheme.colors['error'])),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete Chat', style: AdminTheme.textStyles['bodyMedium']),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildAudioPlayer(String? audioUrl, ChatController controller) {
    if (audioUrl == null) return const SizedBox.shrink();
    return Obx(() {
      final isPlaying =
          controller.currentAudioUrl.value == audioUrl &&
          controller.isPlaying.value;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: AdminTheme.colors['onSurface'],
            ),
            onPressed: () {
              isPlaying
                  ? controller.stopAudio()
                  : controller.playAudio(audioUrl);
            },
          ),
          StreamBuilder<Duration>(
            stream: controller.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = controller.audioDuration.value;
              return Text(
                '${position.inSeconds}/${duration.inSeconds}s',
                style: AdminTheme.textStyles['bodySmall']?.copyWith(
                  color: AdminTheme.colors['onSurface'],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icon(
          Icons.check,
          size: 16.sp,
          color: AdminTheme.colors['onSurfaceVariant'],
        );
      case 'delivered':
        return Icon(
          Icons.done_all,
          size: 16.sp,
          color: AdminTheme.colors['onSurfaceVariant'],
        );
      case 'read':
        return Icon(
          Icons.done_all,
          size: 16.sp,
          color: AdminTheme.colors['primary'],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AdminTheme.colors['surface'],
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.messageController,
              labelText: 'Type a message...',
              onChanged: controller.updateMessage,
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => controller.isRecording.value
                ? CustomButton(
                    text: 'Stop',
                    onPressed: controller.stopRecording,
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: AdminTheme.colors['primary'],
                        ),
                        onPressed: controller.startRecording,
                      ),
                      CustomButton(
                        text: 'Send',
                        onPressed: controller.sendMessages,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
