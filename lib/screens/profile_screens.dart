import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleprofileapp/model/profile_data.dart';
import 'package:sampleprofileapp/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final images = [
    'assets/images/Rectangle 4.png',
    'assets/images/Rectangle 5.png',
    'assets/images/Rectangle 6.png',
    'assets/images/Rectangle 4.png',
    'assets/images/Rectangle 4.png',
    'assets/images/Rectangle 5.png',
    'assets/images/Rectangle 6.png',
    'assets/images/Rectangle 4.png',
    'assets/images/Rectangle 5.png',
    'assets/images/Rectangle 6.png'
  ];
  ProfileData data = ProfileData(
      'assets/images/Ellipse 2.png',
      'Melissa Peters',
      'melpeters@gmail.com',
      'hotpot123',
      DateTime(1995, 5, 23),
      'Nigeria');
  File? imageFile;

  void _onImageAdded(File image){
    setState(() {
      imageFile = image;
    });
  }

  void _onProfileDataUpdate(ProfileData newData) {
    setState(() {
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/images/profile_background.png',),
                Positioned(
                  bottom: -50,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90.0),

                      child:imageFile == null
                          ? Image.asset(data.image ?? "none",fit: BoxFit.fill,height: 115,width: 115,)
                          : Image.file(imageFile!,fit: BoxFit.fill,height: 115,width: 115, ),
                    ),),
                ),
              ],
            ),
          ),
          Text(
            data.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242760),
            ),
          ),
          const Text(
            'Interior Designer',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF544C4C),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pin_drop),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  data.country,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF544C4C),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TextItem(firstText: "122", secondText: "followers"),
              SizedBox(
                width: 30,
              ),
              TextItem(firstText: "67", secondText: "following"),
              SizedBox(
                width: 30,
              ),
              TextItem(firstText: "37K", secondText: "likes"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                              data: data,onImageChanged:_onImageAdded,
                              onProfileDataUpdate: _onProfileDataUpdate)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    backgroundColor: const Color(0xFF242760),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit Profile')),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    backgroundColor: const Color(0xFF242760),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Friends')),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TabBarSection(
            images: images,
          ),
        ],
      ),
    );
  }
}

class TextItem extends StatelessWidget {
  final String firstText;
  final String secondText;

  const TextItem(
      {super.key, required this.firstText, required this.secondText});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          firstText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF242760),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(secondText),
      ],
    );
  }
}

class TabBarSection extends StatefulWidget {
  const TabBarSection({super.key, required this.images});
  final List<String> images;
  @override
  State<StatefulWidget> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabBarSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          children: [
        TabBar(
          controller: _tabController,
          unselectedLabelStyle: const TextStyle(
              color: Color(0xFF9B9494),
              fontWeight: FontWeight.w400,
              fontSize: 14),
          labelStyle: const TextStyle(
              color: Color(0xFF242760),
              fontWeight: FontWeight.w600,
              fontSize: 14),
          tabs: const [
            Tab(
              text: 'Photos',
            ),
            Tab(
              text: 'Likes',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: widget.images.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.fill,
                    ),
                  );
                }),
            const Center(child: Text('No Likes for now')),
          ]),
        ),
      ]),
    );
  }
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: const Color(0XFFC7C6C5),
      selectedItemColor: const Color(0xFF242760),
      onTap: (index) {},
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined), label: "Messages"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: "Settings"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profle"),
      ],
    );
  }
}
