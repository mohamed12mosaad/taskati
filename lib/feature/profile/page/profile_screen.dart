import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';
import 'package:taskati_app/core/styles/widgets/custem_text_form_fielf.dart';
import 'package:taskati_app/core/styles/widgets/custome_svg_picture.dart';
import 'package:taskati_app/core/styles/widgets/dialogs.dart';
import 'package:taskati_app/core/styles/widgets/main_button.dart';
import 'package:taskati_app/core/styles/widgets/tab_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? path;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    String? savedName = HiveHelper.getData(HiveHelper.nameKey);
    String? savedPath = HiveHelper.getData(HiveHelper.imageKey);

    setState(() {
      if (savedName != null) {
        controller.text = savedName;
      }
      if (savedPath != null && savedPath.isNotEmpty && File(savedPath).existsSync()) {
        path = savedPath;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            AppImage.back,
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyles.title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: const [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Gap(86),
              Row(
                children: [
                  Text(
                    'Profile Image',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.seconderyColor,
                    ),
                  ),
                ],
              ),
              const Gap(21),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 82,
                    backgroundImage: path != null
                        ? FileImage(File(path!))
                        : const AssetImage(AppImage.user) as ImageProvider,
                  ),
                  if (path != null)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              title: const Text('Delete Image'),
                              content: const Text(
                                'Are you sure you want to delete',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      path = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.whiteColor,
                          child: CustomSvgPicture(
                            path: AppImage.deleteSvg,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: 'From Camera',
                    onPress: () async {
                      var image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        setState(() {
                          path = image.path;
                        });
                      }
                    },
                  ),
                  const Gap(12),
                  TabButton(
                    text: 'From Gallery',
                    onPress: () async {
                      var image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          path = image.path;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Gap(45),
              Row(
                children: [
                  Text(
                    'Your Name',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.seconderyColor,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              CustomTextFormField(
                controller: controller,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
        child: MainButton(
          text: "Save",
          onPress: () async {
            if (path != null && controller.text.isNotEmpty) {
              await HiveHelper.setUserData(controller.text, path!);
              if (mounted) {
                Navigator.pop(context, true);
              }
            } else if (path == null && controller.text.isNotEmpty) {
              showErrorDialog(context, 'Select profile image');
            } else if (path != null && controller.text.isEmpty) {
              showErrorDialog(context, 'Enter your name');
            } else {
              showErrorDialog(
                context,
                'Select profile image and Enter your name',
              );
            }
          },
        ),
      ),
    );
  }
}
