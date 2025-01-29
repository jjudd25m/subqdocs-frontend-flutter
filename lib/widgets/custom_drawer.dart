import 'package:flutter/material.dart';
import 'package:subqdocs/widgets/rounded_image_widget.dart';

import 'drawer_item.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<String> items = [
    "Dashboard",
    "Lead",
    "Deals",
    "Contacts",
    "Accounts",
    "Activities",
    "Calendar",
    "Email",
    "Streams",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(50))),
      width: 321,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 33,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.close), // Dummy Svg for close icon
                    ],
                  ),
                  Row(
                    children: [
                      RoundedImageWidget(),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Doe", // Dummy user data
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "johndoe@example.com", // Dummy email
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Organization",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Ipoint Solution", // Dummy organization
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        "Switch Account", // Dummy string
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: items.map((item) {
                          return InkWell(
                            onTap: () {
                              // Handle item selection
                              Navigator.pop(context);
                            },
                            child: DrawerItem(
                              itemName: item,
                              iconPath: "", // Add any dummy icon path here
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 34,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/loginScreen', // Dummy route
                    (route) => false,
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18.5,
                    ),
                    Icon(Icons.logout), // Dummy logout icon
                    SizedBox(
                      width: 10.5,
                    ),
                    Text(
                      "Logout", // Dummy string
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
