import 'package:flutter/material.dart';

class StatefulButton extends StatefulWidget {
  final Function onTap;
  final bool? isLoading;
  final String? label;

  const StatefulButton({
    Key? key,
    required this.onTap,
    this.isLoading = false,
    this.label = 'Save',
  }) : super(key: key);

  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading! == true
          ? null
          : () {
              widget.onTap();
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isLoading! == true
              ? Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.grey.shade500,
                  ),
                )
              : const SizedBox(width: 0, height: 0),
          Text(widget.isLoading! == true ? 'Please wait...' : widget.label!)
        ],
      ),
    );
  }
}
