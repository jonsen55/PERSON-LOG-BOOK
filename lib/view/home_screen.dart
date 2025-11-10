// import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_third/boxes/boxes.dart';
import 'package:hive_third/models/person.dart';
import 'package:hive_third/view/detail_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();


  Future<void> clearTextField() async{
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    descriptionController.clear();
  }

  /// Pick an image from the gallery and store it in Hive

  // Future<void> pickAndStoreImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     final imageBytes = await pickedFile.readAsBytes();
  //     final imageUint8List = Uint8List.fromList(imageBytes);

  //     final box = Hive.box('person_box');
  //     await box.put('myImageKey', imageUint8List); // Store with a unique key
  //     print('Image stored in Hive!');
  //   } else {
  //     print('No image selected.');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: (){
          final boxData = Boxes.getData();
          boxData.deleteAll(boxData.keys);
          // print(boxData.getAt(0)?.address);
        }, icon: Icon(Icons.delete_forever)),
        title: Text('Person Log Book',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.deepPurple[700],
        
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ValueListenableBuilder<Box<Person>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, box, _){
                var data = box.values.toList().cast<Person>();
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          data[index].name;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(item: data[index])),
                          );

                        },
                        child: Card(
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsetsGeometry.all(10)),
                                    CircleAvatar(
                                      backgroundColor: Colors.deepPurple[700],
                                      backgroundImage: AssetImage('assets/images/1.jpg'),
                                    ),
                                    Padding(padding: EdgeInsetsGeometry.only(right: 12)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].name.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500
                                        ),),
                                        Text(data[index].email.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        )),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                                Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                                IconButton(onPressed: (){
                                  // _confirmDelete();
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Row(
                                          children: [
                                            Text("Delete ", style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                            ),),
                                            Text(data[index].name.toString()+"?", style: TextStyle(color: Colors.red,
                                            fontSize: 20),),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text('Cancel'),),
                                          TextButton(onPressed: (){
                                            // final data = Boxes.getData();
                                            final box = Boxes.getData();
                                            // data.delete(box.name);
                                            var data = box.values.toList().cast<Person>();
                                            box.delete(data[index].key);
                                            Navigator.pop(context);
                                            // data[index].delete();
                                          }, child: Text('Delete', style: TextStyle(color: Colors.red),))
                                        ]
                                      );
                                    });

                                }, icon: Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                );
              }
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          _showMyDialog();
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.deepPurple[700],
      ),
    );
  }

  // Future<void> _confirmDelete() async{
  //   return 
  //   );
  // }
  Future<void> _showMyDialog(){
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(        
          title: Text('Add person', style: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.bold,
          ),),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.deepPurple[700],
                    backgroundImage: AssetImage('assets/images/1.jpg'),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                    )
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                      )
                      ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter address',
                      )
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                      )
                    ),
                    SizedBox(height: 16,),
                    // Container(
                    //   child: pickAndStoreImage();),
                    // SizedBox(height: 16,),
                    // RadioMenuButton(value: 1, groupValue: curren, onChanged: (){
            
                    // }, child: child)
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              clearTextField();
              Navigator.pop(context);
            }, child: Text('Cancel')),
            TextButton(
              onPressed: (){
                if(nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(milliseconds: 1000),
                      backgroundColor: Color.fromARGB(255, 255, 98, 87),
                      content: Text('Please fill all the fields', style: TextStyle(
                        color: Colors.white
                      ),)
                    )
                  );
                }else{
                  final data = Person(name: nameController.text, email: emailController.text, phone: int.parse(phoneController.text), address: addressController.text, description: descriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  clearTextField();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
              style: TextButton.styleFrom(
                fixedSize: Size(180, 50),// Sets width to 200 and height to 50
                backgroundColor: Colors.deepPurple[700],
                foregroundColor: Colors.white
              ),
              // ButtonStyle(
              //   backgroundColor: WidgetStateProperty.all(Colors.deepPurple[700]),
              //   foregroundColor: WidgetStateProperty.all(Colors.white),
              //   iconSize: WidgetStateProperty.all(70),
                // maximumSize: WidgetStateProperty.all(Size(250, 70))
                // iconSize: WidgetStateProperty.all(70)
              // ),
            )
          ],
          
        );
      });
  }
}