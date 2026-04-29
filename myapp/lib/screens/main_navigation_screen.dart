import 'package:flutter/material.dart';
import '../widgets/firestore_section_view.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FirestoreSectionView(collectionPath: 'requests', title: 'Deliveries'),
    const FirestoreSectionView(collectionPath: 'carrier', title: 'Collecting'),
    const FirestoreSectionView(collectionPath: 'repair', title: 'Repairs'),
    const Center(child: Text("Support Chat coming soon...")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Deliveries', 'Collecting', 'Repairs', 'Support Chat'][_selectedIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Deliveries'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Collecting'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Repairs'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Support'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
