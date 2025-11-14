import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hintText,
  required String? Function(String?) validator,
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
  bool isPasswordVisible = false,
  VoidCallback? onVisibilityToggle,
  Color? fillColor,
  double? verticalPadding,
  double? borderRadius,
  Function(String)? onChange,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        onChanged: onChange,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 121, 133, 156)),
          prefixIcon: Icon(prefixIcon, color: Colors.deepPurple[400]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF8D9BB5),
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          // filled: true,
          // fillColor: fillColor ?? const Color.fromARGB(255, 210, 192, 252),
          // border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius ?? 12),
            // borderSide: const BorderSide(color: Color.fromARGB(255, 194, 160, 253), width: 1),
            // borderSide: BorderSide.none,
          // ),
          contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 16,
          ),
        ),
        validator: validator,
      ),
      const SizedBox(height: 10),
    ],
  );
}

