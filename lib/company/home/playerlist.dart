import 'package:flutter/material.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({
    this.initialCount = 1,
  });

  final int initialCount;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  int fieldCount = 0;
  int nextIndex = 0;
  List<TextEditingController> controllers = <TextEditingController>[];

  List<Widget> _buildList() {
    int i;
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
        controllers.add(TextEditingController());
      }
    }

    i = 0;
    return controllers.map<Widget>((TextEditingController controller) {
      int displayNumber = i + 1;
      i++;
      return TextField(
        controller: controller,
        maxLength: 20,
        decoration: InputDecoration(
          labelText: "Player $displayNumber",
          counterText: "",
          prefixIcon: const Icon(Icons.person),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                fieldCount--;
                controllers.remove(controller);
              });
            },
          ),
        ),
      );
    }).toList(); // convert to a list
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _buildList();

    children.add(
      GestureDetector(
        onTap: () {
          setState(() {
            fieldCount++;
          });
        },
        child: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'add player',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    // build the ListView
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  @override
  void initState() {
    super.initState();
    fieldCount = widget.initialCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}