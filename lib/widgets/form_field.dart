import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormFields extends StatelessWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction inputAction;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onSumbit;
  final bool floatLabel;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? textInputFormatter_;
  final int? maxLength;

  const FormFields(
      {Key? key,
      required this.textEditingController,
      required this.labelText,
      this.validator,
      this.inputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.readOnly = false,
      this.floatLabel = true,
      this.onTap,
      this.onSumbit,
      this.suffixIcon,
      this.maxLength,
      this.textInputFormatter_})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          counterText: '',
          labelText: labelText,
          // hintText: hintText,
          labelStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
          hintStyle: TextStyle(color: Colors.black, fontSize: 12.sp),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.black, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.w),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.w),
          ),
          contentPadding: const EdgeInsets.all(14.0),
        ),
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        keyboardType: keyboardType,
        controller: textEditingController,
        validator: validator,
        readOnly: readOnly,
        textInputAction: inputAction,
        onTap: onTap,
        onFieldSubmitted: onSumbit,
        inputFormatters: textInputFormatter_,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
