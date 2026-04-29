import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSectionView extends StatelessWidget {
  final String collectionPath;
  final String title;

  const FirestoreSectionView({
    super.key,
    required this.collectionPath,
    required this.title,
  });

  Future<void> _moveDocument(BuildContext context, QueryDocumentSnapshot doc, String targetCollection) async {
    final data = doc.data() as Map<String, dynamic>;
    final originalId = doc.id;

    try {
      // 1. Copy to target collection
      await FirebaseFirestore.instance.collection(targetCollection).add(data);
      // 2. Delete from current collection
      await FirebaseFirestore.instance.collection(collectionPath).doc(originalId).delete();

      if (context.mounted) {
        Navigator.pop(context); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Moved to $targetCollection")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _showActionSheet(BuildContext context, QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Move to Marketplace'),
                onTap: () => _transferDocument(context, doc, 'marketplace'),
              ),
              ListTile(
                leading: const Icon(Icons.build),
                title: const Text('Repairs'),
                onTap: () => _transferDocument(context, doc, 'repair'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _transferDocument(BuildContext context, QueryDocumentSnapshot doc, String targetCollection) =>
      _moveDocument(context, doc, targetCollection);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionPath).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Center(child: Text("No data in $collectionPath"));

        final docs = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              debugPrint("Raw Document [$collectionPath]: $data");

              return InkWell(
                onTap: collectionPath == 'carrier' ? () => _showActionSheet(context, doc) : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data.toString(),
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                      if (collectionPath == 'carrier')
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
