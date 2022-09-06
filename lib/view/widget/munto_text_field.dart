import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final validator;
  final onChanged;
  final style;
  final textInputAction;
  final onFieldSubmitted;
  final maxLength;
  final focusNode;
  final keyboardType;
  final hintText;
  final obscureText;
  final enabled;
  MTextField({@required this.controller, this.onClear, this.validator, this.onChanged, this.style, this.textInputAction, this.onFieldSubmitted, this.focusNode, this.maxLength, this.keyboardType, this.hintText, this.obscureText, this.enabled});


  @override
  Widget build(BuildContext context) {
    return                             Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 0),
      height: 46,
      decoration: BoxDecoration(

          borderRadius: BorderRadius.all(
              Radius.circular(8)
          ),
          border: Border.all(
              // color: controller.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
             color: MColors.pinkish_grey ,
              width: 1
          )
      ),
      child: TextFormField(
        controller: controller,
        validator:validator,
        onChanged:onChanged,
        textInputAction:textInputAction,
        onFieldSubmitted:onFieldSubmitted,
        maxLength:maxLength,
        focusNode:focusNode,
        keyboardType:keyboardType,
        obscureText:obscureText ?? false,
        enabled: enabled ?? true,
        maxLines: 1,
        style: MTextStyles.regular14Grey06,
        decoration: InputDecoration(
          // suffixIcon: Transform.translate(
          //   offset: Offset(16,2),
          //   child: IconButton(
          //     onPressed: (){
          //       controller.text ='';
          //       onClear();
          //     },
          //
          //     icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: controller.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
          //   ),
          // ),
          hintText: hintText ?? '',
          counterText: '',
          hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
          labelStyle: TextStyle(
              color: Colors.transparent
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(13),
        // ],

      ),
    );
  }
}
