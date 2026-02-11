import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';


class Message {
  final String text;
  final bool isMe;
  final String time;
  final bool isSeen;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    this.isSeen = false,
  });
}

class MassageScreen extends StatefulWidget {
  const MassageScreen({super.key});

  @override
  State<MassageScreen> createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _allSuggestions = [
    "I'm mahfujar",
    "I'm here",
    "I'm heading there",
    "I'm looking for you",
    "Wait a moment",
    "Coming in 2 mins",
  ];
  List<String> _filteredSuggestions = [];

  final List<Message> _messages = [
    Message(text: "Hello Where are you", isMe: false, time: "9:41 AM"),
    Message(
      text: "Hello Where are you\nHello Where are you",
      isMe: true,
      time: "9:41 AM",
      isSeen: true,
    ),
    Message(
      text: "Hello Where are you\nHello Where are you",
      isMe: false,
      time: "9:41 AM",
    ),
    Message(
      text: "Hello Where are you\nHello Where are you",
      isMe: true,
      time: "9:41 AM",
      isSeen: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _allSuggestions;
    _messageController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _onSearchChanged() {
    setState(() {
      if (_messageController.text.isEmpty) {
        _filteredSuggestions = _allSuggestions;
      } else {
        _filteredSuggestions = _allSuggestions
            .where(
              (s) => s.toLowerCase().contains(
                _messageController.text.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: _messageController.text.trim(),
            isMe: true,
            time: "9:45 AM",
            isSeen: false,
          ),
        );
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.c202020,
              child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.cFFFFFF,
              size: 20.sp,
            ),
            ),
            UIHelper.horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kulwinder A.",
                  style: TextFontStyle.textStyle14cFFFFFFDMSans600,
                ),
                Text(
                  "Gray Toyota RAV4 Hybrid",
                  style: TextFontStyle.textStyle12c606060DMSans400,
                ),
              ],
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () => NavigationService.goBack,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.cFFFFFF,
              size: 20.sp,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(color: AppColors.allPrimaryColor, thickness: 1),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

             _buildSuggestions(),
    
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (_filteredSuggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _filteredSuggestions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _messageController.text = _filteredSuggestions[index];
                _messageController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _messageController.text.length),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.c949494),
              ),
              child: Center(
                child: Text(
                  _filteredSuggestions[index],
                  style: TextFontStyle.textStyle12c606060DMSans400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(Message msg) {
    final isMe = msg.isMe;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[_buildAvatar(), UIHelper.horizontalSpaceSmall],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.c202020,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: isMe
                      ? Radius.circular(15.r)
                      : Radius.circular(2.r),
                  bottomRight: isMe
                      ? Radius.circular(2.r)
                      : Radius.circular(15.r),
                ),
              ),
              child: Text(
                msg.text,
                style: TextFontStyle.textStyle16c606060DMSans400,
              ),
            ),
          ),
          if (isMe) ...[
            UIHelper.horizontalSpaceSmall,
            _buildAvatar(isMe: true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar({bool isMe = false}) {
    return Container(
      height: 32.h,
      width: 32.w,
      decoration: const BoxDecoration(
        color: AppColors.c4CAF50,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.cFFFFFF,
              size: 20.sp,
            ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.c202020,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type here.........",
                        hintStyle: TextFontStyle.textStyle12c606060DMSans400,
                    
                      ),
                    ),
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.c172B4D,
                    size: 20.sp,
                  ),
                  UIHelper.horizontalSpace(16.w),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Icon(
                      Icons.send_outlined,
                      color: AppColors.c172B4D,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIHelper.horizontalSpaceSmall,
          GestureDetector(
            onTap: () {
         //     NavigationService.navigateTo(Routes.reportScreen);
            },
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF241E2B),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.call, color: AppColors.c172B4D, size: 20.sp),
                  UIHelper.horizontalSpace(5.w),
                  Text(
                    "Call now",
                    style: TextFontStyle.textStyle16c606060DMSans400.copyWith(
                      color: AppColors.c172B4D,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.removeListener(_onSearchChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
