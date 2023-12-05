import 'package:flutter/material.dart';

class Addinfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  const Addinfo({

    super.key, required this.icon,  required this.label, required this.value, required this.iconColor,
  }

  );

  @override
  Widget build(BuildContext context) {
    return  Column(children: [Icon(icon,size: 32,color:iconColor ,),
    SizedBox(height: 5,),
    Text(label,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),), SizedBox(height: 5,),
    Text(value,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)],);
  }}