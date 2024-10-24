import 'package:flutter/material.dart';
import 'package:medigo/screens/SearchPharcmacieAll.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String qid = '';

  @override
  void initState() {
    super.initState();
    getqid();
  }

  Future<void> getqid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      qid = prefs.getString('qid') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPharmacieAll(id: qid)),
            );
          },
          icon: const Icon(Icons.shop_two),
          iconSize: 40,
          color: Colors.white,
        ),
      ],
    );
  }
}
