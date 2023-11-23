import 'package:cloud_firestore/cloud_firestore.dart';
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
  late Future _getMyGames;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchGamesData() async {
    var _gamesForUser = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: "OpTic_yupper3")
        .get()
        .then((value) =>
            value.docs.first.reference.collection('games_for_user').get());
    return _gamesForUser.docs;
  }

  @override
  void initState() {
    _getMyGames = fetchGamesData();
    super.initState();
  }

  // TODO: add a page view instead of all on one page? and last page is
  // review and post page then show success screen (like payout screen)
  // then animate back to first page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,

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
                        style: AppStyles.giga18Text,
                        decoration: const InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none),
                        onSaved: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Caption (${_hideDesc ? 'none' : 'optional'})',
                          style: AppStyles.giga18Text.copyWith(fontSize: 16),
                        ),
                        Spacer(),
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
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(6)),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          maxLines: 4,
                          cursorColor: Colors.white,
                          controller: _descriptionController,
                          style: AppStyles.giga18Text.copyWith(fontSize: 16),
                          decoration: const InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 15),
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none),
                        ),
                      ),
                    if (_titleController.text.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            'Select game:',
                            style: AppStyles.giga18Text.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    if (_titleController.text.isNotEmpty)
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'My Games',
                              style:
                                  AppStyles.giga18Text.copyWith(fontSize: 16),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Search Games',
                              style:
                                  AppStyles.giga18Text.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    if (_titleController.text.isNotEmpty)
                      FutureBuilder(
                          future: _getMyGames,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    height: 50,
                                    padding: const EdgeInsets.all(10),
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) {
                                          return Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white10,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Text(
                                                  snapshot.data[i]
                                                      .data()['game_title'],
                                                  style: AppStyles.giga18Text),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              );
                            }
                          })
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
