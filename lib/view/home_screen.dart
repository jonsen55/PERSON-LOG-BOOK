import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Assuming these are your local files. Ensure paths are correct.
import 'package:hive_third/boxes/boxes.dart';
import 'package:hive_third/components/buildTextField.dart';
import 'package:hive_third/models/person.dart';
import 'package:hive_third/view/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Tab & Form Keys
  late TabController tabController = TabController(length: 2, vsync: this);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future<void> clearTextField() async {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Person Log Book',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple[700],
        toolbarHeight: 70,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
               // Navigation to profile or other action
            },
            icon: const Icon(Icons.person_rounded),
          )
        ],
        // "Delete All" button
        leading: IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: _showDeleteAllDialog,
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.contacts), text: "Contacts"),
            Tab(icon: Icon(Icons.search), text: "Search"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildContactList(),
          const Center(child: Text("Search Functionality Coming Soon")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPersonDialog,
        shape: const CircleBorder(),
        backgroundColor: Colors.deepPurple[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContactList() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ValueListenableBuilder<Box<Person>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          final data = box.values.toList().cast<Person>();

          if (data.isEmpty) {
            return const Center(
              child: Text("No contacts added yet."),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final person = data[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  minTileHeight: MediaQuery.of(context).size.height * 0.08,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(item: person),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple[700],
                    backgroundImage: const AssetImage('assets/images/1.jpg'),
                  ),
                  title: Text(
                    person.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    person.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteSingleDialog(person),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Dialog Methods ---

  Future<void> _showDeleteAllDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete all contacts?", style: TextStyle(color: Colors.red)),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final boxData = Boxes.getData();
                boxData.deleteAll(boxData.keys);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All contacts deleted successfully!"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            )
          ],
        );
      },
    );
  }

  Future<void> _showDeleteSingleDialog(Person person) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete ${person.name}?", style: const TextStyle(color: Colors.red)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                person.delete(); // HiveObject delete method
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            )
          ],
        );
      },
    );
  }

  Future<void> _showAddPersonDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Person',
            style: TextStyle(
              color: Colors.deepPurple[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Bind the key here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple[700],
                      backgroundImage: const AssetImage('assets/images/1.jpg'),
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: nameController,
                      hintText: 'Enter name',
                      prefixIcon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: emailController,
                      hintText: 'Enter email',
                      prefixIcon: Icons.email,
                      validator: (value) => value!.isEmpty ? 'Email required' : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: phoneController,
                      hintText: 'Enter phone',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Phone required' : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: addressController,
                      hintText: 'Enter address',
                      prefixIcon: Icons.location_on,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: descriptionController,
                      hintText: 'Enter description',
                      prefixIcon: Icons.description,
                      validator: (value) => null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clearTextField();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final data = Person(
                    name: nameController.text,
                    email: emailController.text,
                    phone: int.tryParse(phoneController.text) ?? 0, 
                    address: addressController.text,
                    description: descriptionController.text,
                  );

                  final box = Boxes.getData();
                  box.add(data);
                  // data.save(); // Not strictly necessary if using box.add, but doesn't hurt

                  clearTextField();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.deepPurple[700],
                      content: const Text('Added successfully!', style: TextStyle(color: Colors.white)),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }
}