import 'package:flutter/material.dart';
import 'package:safify/User%20Module/pages/user_form.dart';

class UserActionsModalSheet extends StatelessWidget {
  const UserActionsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
      height: screenHeight * .25,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Centered divider line with fractionally sized box
          FractionallySizedBox(
            widthFactor: 0.15, // Adjusts width to 15% of the modal width
            child: Container(
              height: 4,
              margin: EdgeInsets.symmetric(vertical: screenHeight * .015),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Close button aligned to the top right
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),

          // Register Ticket option
          _OptionItem(
            icon:
                Icon(Icons.copy_all_rounded, color: Colors.blue[600], size: 26),
            name: 'Register Ticket',
            description: 'Get your issue resolved',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserForm()),
              );
            },
          ),

          // Divider with consistent indentation
          Divider(
            color: Colors.black54,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final String description;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.blue[100],
          radius: 12,
          child: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 11,
          ),
        ),
      ),
    );
  }
}
