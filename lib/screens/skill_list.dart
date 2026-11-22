import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/state/skill_store.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_card.dart';

/// Screen listing every skill saved through the form.
class SkillListPage extends StatelessWidget {
  const SkillListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SkillFormPage()),
          );
        },
      ),
      body: ListenableBuilder(
        listenable: skillStore,
        builder: (context, _) {
          final items = skillStore.items;
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No skills added yet.\nTap "Add Skill" to create one.',
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
              return SkillCard(
                skill: item,
                onDelete: () => skillStore.remove(item),
              );
            },
          );
        },
      ),
    );
  }
}
