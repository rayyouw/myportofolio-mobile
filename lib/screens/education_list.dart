import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/state/education_store.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Screen listing every education entry saved through the form.
class EducationListPage extends StatelessWidget {
  const EducationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Education'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EducationFormPage()),
          );
        },
      ),
      body: ListenableBuilder(
        listenable: educationStore,
        builder: (context, _) {
          final items = educationStore.items;
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No education added yet.\nTap "Add Education" to create one.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.school),
                  ),
                  title: Text(item.institution),
                  subtitle: Text(
                    '${item.level} - ${item.major}\n${item.period}'
                    '${item.gpa == null ? '' : '\nGPA ${item.gpa!.toStringAsFixed(2)}'}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => educationStore.removeAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
