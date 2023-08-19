import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/neighbour_interactive_provider.dart';
import 'image_grid.dart';

class AddHelpOrGiftRequestForm extends StatefulWidget {
  const AddHelpOrGiftRequestForm({Key? key, required this.formType})
      : super(key: key);

  final String formType;

  @override
  State<AddHelpOrGiftRequestForm> createState() =>
      _AddHelpOrGiftRequestFormState();
}

class _AddHelpOrGiftRequestFormState extends State<AddHelpOrGiftRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  final picker = ImagePicker();
  List<XFile> imageList = [];
  bool _isChecked = false;
  int? money;

  void _popDialog() {
    showDialog(
        context: context,
        builder: (content) => AlertDialog(
              title: const Text("Form Submit"),
              content:
                  Text("Your ${widget.formType} application has completed"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<NeighbourInteractiveProvider>(context, listen: false)
          .submitRequest(_title, _content, widget.formType, money);
      _popDialog();
    }
  }

  void pickImage() async {
    imageList = await picker.pickMultiImage();
    if (imageList.isEmpty) {
      return;
    }
    addGallery();
  }

  void addGallery() {
    Provider.of<NeighbourInteractiveProvider>(context, listen: false)
        .addGalleryImages(imageList);
  }

  @override
  Widget build(BuildContext context) {
    List optionalImages =
        Provider.of<NeighbourInteractiveProvider>(context).optionalImages;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.formType[0].toUpperCase() + widget.formType.substring(1, widget.formType.length)} Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _title = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Content"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some content";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _content = value;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Text(widget.formType == "help" ? "Gratuity" : "Price"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        enabled: _isChecked,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '\$HKD',
                        ),
                        onChanged: (value) {
                          money = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => pickImage(),
                  child: const SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (optionalImages.isNotEmpty) const HelpGiftImageGrid(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
