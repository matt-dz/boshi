import 'package:flutter/material.dart';
import 'package:frontend/src/model/oauth/oauth_repository.dart';
import 'package:provider/provider.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final formKey = GlobalKey<ShadFormState>();
  bool _titleExists = false;
  bool _contentExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boshi')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: ShadCard(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadButton.ghost(
                        height: 30, width: 120, child: const Text("Cancel")),
                    Consumer<OAuthRepository>(builder: (context, oauth, child) {
                      return ShadButton.ghost(
                          height: 30,
                          width: 120,
                          enabled: _titleExists && _contentExists,
                          onPressed: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              print(
                                  "Form Values: ${formKey.currentState!.value["title"]}, ${formKey.currentState!.value["content"]}");
                            }
                            if (oauth.atProtoSession != null) {
                              print("Implementing posting soon!");
                            } else {
                              print("Please log in!");
                            }
                          },
                          child: const Text("Post"));
                    }),
                  ],
                ),
                SizedBox(height: 30),
                const Center(
                  child: Column(
                    children: [
                      Text("Posting as"),
                      Text("University of Florida | eifmsa")
                    ],
                  ),
                ),
                ShadForm(
                    key: formKey,
                    child: Column(
                      children: [
                        ShadInputFormField(
                          id: "title",
                          placeholder: Text(
                            "Title",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor),
                          ),
                          decoration: ShadDecoration(
                            border: ShadBorder.none,
                            disableSecondaryBorder: true,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "What's the title to your truth?";
                            }
                            return null;
                          },
                          onChanged: (String title) => setState(() {
                            _titleExists = title.isNotEmpty;
                          }),
                        ),
                        ShadInputFormField(
                          id: "content",
                          placeholder: Text("Speak your truth...",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).disabledColor)),
                          decoration: ShadDecoration(
                            border: ShadBorder.none,
                            disableSecondaryBorder: true,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Don't you want to speak your truth?";
                            }
                            return null;
                          },
                          onChanged: (String content) => setState(() {
                            _contentExists = content.isNotEmpty;
                          }),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
