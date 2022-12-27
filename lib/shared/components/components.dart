import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 40.0,
  Color color = Colors.blue,
  required Function function,
  required String text,
  double radius = 5.0,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController textController,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required Function validate,
  required String hintText,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function? suffixPressed,
  TextInputAction? inputAction,
}) =>
    TextFormField(
      controller: textController,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      //  onChanged: (value)
      //  {
      //    onChanged!(value);
      //  },
      // onTap: ()
      // {
      //   onTap!();
      // },
      textInputAction: inputAction,

      validator: (value) {
        return validate(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
        border:  OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[75],
        prefixIconColor: Colors.grey
      ),

    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
