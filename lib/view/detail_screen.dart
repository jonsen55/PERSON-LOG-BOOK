// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_third/models/person.dart';
// import your model type
// import 'models/my_model.dart';

class DetailScreen extends StatefulWidget {
  final Person item;
  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _descController = TextEditingController();
  final _editController = TextEditingController();
  late Person _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
  
  Future _showSuccessfulDialog(String value) async {
    switch(value){
      case "Save":
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          duration: Duration(milliseconds: 900),
          backgroundColor: Colors.deepPurple,
          content: Text("Saved successfully!"),),
      );
      case "Delete":
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          duration: Duration(milliseconds: 900),
          backgroundColor: Color.fromARGB(255, 255, 98, 87),
          content: Text("Deleted successfully!"),),
      );
    }
  
  
  }
  Future _showNoDescriptionfulDialog(String value) async {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1000),
        backgroundColor: Color.fromARGB(255, 255, 98, 87),
        content: Text('No description to $value', style: TextStyle(
        color: Colors.white
      ),)));
    }
  Future<void> _save(String value) async {
    final newText = _editController.text.trim();
    final oldText = (_item.description ?? ' ').trim();


    if(newText.isEmpty){
      if(oldText.isEmpty){
        _showNoDescriptionfulDialog(value);
      }else{
        _item.description = _editController.text;
        await _item.save();
        if(value == "Delete"){
          setState(() {
          });
          _showSuccessfulDialog(value);
        }
      }
    }else{
      if(newText != oldText){
        _item.description = _editController.text;
        await _item.save();
        setState(() {
        });
        _showSuccessfulDialog(value);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Color.fromARGB(255, 255, 98, 87),
            content: Text('Nothing edited', style: TextStyle(
            color: Colors.white
          ),)));
      }
        
    }

    // if(newText.isEmpty){
    //   if(value == "Save"){
    //     _showNoDescriptionfulDialog(value);
    //   }
    // }else{
    //   if(value == "Delete"){
    //     _item.description = _editController.text;
    //     await _item.save();
    //   }
    //   if(newText != oldText){
    //     _item.description = _editController.text;
    //     await _item.save();
    //     _showSuccessfulDialog(value);
    //     setState(() {
    //     });
    //   }
    // }


    // if(newText.isNotEmpty){
    //   // update the in-memory object
    //   _item.description = _editController.text;
    //   await _item.save();
    //   // _descController.clear();

    //   // show feedback and pop or keep editing
    //   switch(value)
    //   {
    //     case "Save":
    //     if(newText != oldText){
    //       _showSuccessfulDialog(value);
    //     }

    //     break;
    //     case "Delete":
    //       _showSuccessfulDialog(value);
    //     break;        
    //   }
    //   setState(() {
    //   }); // refresh UI if needed
    // }
    // else{
    //   if(value == "Save"){
    //     _showNoDescriptionfulDialog(value);
    //   }else{
    //     _showNoDescriptionfulDialog(value);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.deepPurple[700],
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                radius: 72,
                backgroundColor: Colors.deepPurple[700],
                backgroundImage: AssetImage('assets/images/1.jpg'),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_item.email, style: TextStyle(fontWeight: FontWeight.w600),),
                  Text(_item.phone.toString())
                ],
              ),
              SizedBox(height: 24),
              Container(
                // horizontal line below the details
                width: 200,
                height: 1,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Description: ", style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                height: 210,
                width: 400,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(16),
                  // boxShadow:[
                  //   BoxShadow(
                  //   color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                  //   spreadRadius: 5, // Extends the shadow
                  //   blurRadius: 7, // Blurs the shadow
                  //   offset: const Offset(0, 3),
                  //   ),
                  // ]
                ),
                child: Text(_item.description ?? "No description"),
              ),
                ],
              ),
              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.deepPurple[700],
        // onPressed: _save,
        onPressed: _showMyDialog,
        child: const Text('Edit'),
      ),
    );
  }

  
  Future<void> _showMyDialog() async {
    _editController.text = _item.description.toString();
  
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          
          title: const Text('Edit Description'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: 
              TextFormField(
                // initialValue: _item.description,
                controller: _editController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                ),
              )
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Delete description?", style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('Cancel'),),
                            TextButton(onPressed: (){
                              _editController.clear();
                              _save("Delete");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, child: Text('Delete', style: TextStyle(color: Colors.red),))
                          ]
                        );
                      }
                    );
                  },
                  style: TextButton.styleFrom(
                    fixedSize: Size(90, 40), // Sets width to 200 and height to 50
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white
                  ),
                  // style: ButtonStyle(
                  //   backgroundColor: WidgetStateProperty.all(Colors.red[400]),
                  //   foregroundColor: WidgetStateProperty.all(Colors.white),
                  // ),
                  child: const Text("Delete All"),
                ),
            
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    _save("Save");
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    fixedSize: Size(100, 40), // Sets width to 200 and height to 50
                    backgroundColor: Colors.deepPurple[700],
                    foregroundColor: Colors.white
                  ),
                  // style: ButtonStyle(
                  //   backgroundColor: WidgetStateProperty.all(Colors.deepPurple[700]),
                  //   foregroundColor: WidgetStateProperty.all(Colors.white),
                  // ),
                  child: const Text("Save"),
                ),
                SizedBox(width: 8),
                TextButton(
                  child: const Text('Cancel', style: TextStyle(color: Colors.deepPurple),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),       
          ],
        );
      },
    );

  }
}
