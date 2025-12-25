import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

enum GroceryTap { groceries, search }

class _GroceryListState extends State<GroceryList> {
  GroceryTap _currentTap = GroceryTap.groceries;
  String? inputText = "";

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (dummyGroceryItems.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile
      content = ListView.builder(
        itemCount: dummyGroceryItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
      );
    }

    Widget search = const Center(child: Text("No search result"));

    if (inputText != null) {
      search = Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(children: [
          TextField(
          decoration: const InputDecoration(label: Text('Search')),
          onChanged: (value) {
            setState(() {
              inputText = value;
            });
            print(inputText);
          },
        ),
        Column(children: [...dummyGroceryItems.map((e) {
          if (e.name == inputText) {
            return GroceryTile(grocery: e);
          } 
        })],)
        
        ],)
      );

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: IndexedStack(index: _currentTap.index, children: [content, search]),

      // bottomNavigationBar: BottomNavigationBar(items: [BottomNavigationBarItem(icon: Icon(Icons.local_grocery_store), label: "Groceries")]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: "Groceries",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        onTap: (index) {
          setState(() {
            _currentTap = GroceryTap.values[index];
          });
        },
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
