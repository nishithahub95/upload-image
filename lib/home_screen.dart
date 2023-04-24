import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;//Store image path
  final _picker=ImagePicker();
  bool showSpinner = false ;
  Future getImage()async{
    final pickImage=await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
   if(pickImage!=null){
     image=File(pickImage.path);
     setState(() {

     });

   }else{
  print("Can't upload image");
   }
  }

  Future<void>uploadImage()async{
setState(() {
  showSpinner=true;
});
var stream=new http.ByteStream(image!.openRead());
stream.cast();
var length=await image!.length();
var url=Uri.parse('https://fakestoreapi.com/products');
var requist= new http.MultipartRequest('POST', url);
requist.fields['title']='New image';
var multipart= new http.MultipartFile(
    'image',//Key name of the image url in the api
    stream,
    length);
requist.files.add(multipart);
var response=await requist.send();

if(response.statusCode==200){
  setState(() {
    showSpinner=false;
  });
  print('Image uploaded successfully');
}else{
  setState(() {
    showSpinner=false;
  });
  print('failed');
}
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:showSpinner ,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Container(
                  child: image==null?Center(child: Text('pick image'),):
                      Container(

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                           // borderRadius: BorderRadius.circular(20),
                          ),
                        child: Center(
                          child: Image.file(File(image!.path).absolute,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                          ),

                        ),
                      )

                ),
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                   uploadImage();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.orange
                  ),
                  child: Center(
                    child: Text('Upload'),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
