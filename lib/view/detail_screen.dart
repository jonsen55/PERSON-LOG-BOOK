import 'package:flutter/material.dart';
import 'package:hive_third/models/person.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Person item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.deepPurple[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.deepPurple[700],
                backgroundImage: const AssetImage('assets/images/1.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.item.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),
            
            // Info Cards
            _buildInfoTile(Icons.email, widget.item.email),
            _buildInfoTile(Icons.phone, widget.item.phone.toString()),
            _buildInfoTile(Icons.location_on, widget.item.address ?? "No address"),
            
            const SizedBox(height: 20),
            const Divider(indent: 40, endIndent: 40),
            const SizedBox(height: 20),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurple.shade100),
                    ),
                    constraints: const BoxConstraints(minHeight: 100),
                    child: Text(
                      (widget.item.description == null || widget.item.description!.isEmpty)
                          ? "No description added yet."
                          : widget.item.description!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple[700],
        foregroundColor: Colors.white,
        onPressed: _showEditAllDialog,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Details'),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
  Future<void> _showEditAllDialog() async {
    final emailController = TextEditingController(text: widget.item.email);
    final phoneController = TextEditingController(text: widget.item.phone.toString());
    final addressController = TextEditingController(text: widget.item.address);
    final descController = TextEditingController(text: widget.item.description ?? '');

    bool isSensitiveLocked = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Contact'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSensitiveLocked ? Colors.red[50] : Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSensitiveLocked ? Colors.red.shade200 : Colors.green.shade200
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isSensitiveLocked ? Icons.lock : Icons.lock_open,
                                  color: isSensitiveLocked ? Colors.red : Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSensitiveLocked ? "Info Locked" : "Editing Enabled",
                                  style: TextStyle(
                                    color: isSensitiveLocked ? Colors.red : Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: !isSensitiveLocked,
                              activeThumbColor: Colors.green,
                              onChanged: (value) {
                                setState(() {
                                  isSensitiveLocked = !value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildDialogTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                        enabled: !isSensitiveLocked, 
                      ),
                      const SizedBox(height: 12),

                      _buildDialogTextField(
                        controller: phoneController,
                        label: "Phone",
                        icon: Icons.phone,
                        isNumber: true,
                        enabled: !isSensitiveLocked,
                      ),
                      const SizedBox(height: 12),

                      _buildDialogTextField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.location_on,
                        enabled: true, 
                      ),
                      const SizedBox(height: 12),

                      _buildDialogTextField(
                        controller: descController,
                        label: "Description",
                        icon: Icons.description,
                        maxLines: 3,
                        enabled: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[700],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Update Hive Object
                    widget.item.email = emailController.text.trim();
                    widget.item.phone = int.tryParse(phoneController.text.trim()) ?? widget.item.phone;
                    widget.item.address = addressController.text.trim();
                    widget.item.description = descController.text.trim();

                    await widget.item.save();
                    if (mounted) {
                      setState(() {}); // Updates the main screen behind dialog
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Details updated successfully!"),
                          backgroundColor: Colors.deepPurple,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      maxLines: maxLines,
      enabled: enabled, // This controls the lock
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? Colors.deepPurple : Colors.grey),
        filled: true,
        fillColor: enabled ? Colors.white38 : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}