import 'package:flutter/material.dart';
import 'package:gg_tv/styles.dart';

class CreateContentScreen extends StatefulWidget {
  const CreateContentScreen({super.key});

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _hideDesc = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true, //test thesefor nav bar
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create',
          style: AppStyles.giga18Text.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              Form(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Text(
                            'Clip title',
                            style: AppStyles.giga18Text,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _titleController,
                        style: AppStyles.giga18Text.copyWith(fontSize: 16),
                        decoration: const InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Description (optional)',
                          style: AppStyles.giga18Text.copyWith(fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _hideDesc = !_hideDesc;
                              });
                            },
                            icon: Icon(_hideDesc ? Icons.edit : Icons.cancel,
                                color: Colors.white, size: 24))
                      ],
                    ),
                    if (!_hideDesc)
                      TextFormField(
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.white,
                        style: AppStyles.giga18Text.copyWith(fontSize: 16),
                        controller: _descriptionController,
                        maxLength: 300,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none),
                      )
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
