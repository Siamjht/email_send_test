import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart'; // For PlatformException

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmailSenderScreen(),
    );
  }
}

class EmailSenderScreen extends StatelessWidget {
  Future<void> sendEmailWithAttachment(BuildContext context) async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        // Get the file path
        String? filePath = result.files.single.path;

        if (filePath != null) {
          // Create the email with the attachment
          final Email email = Email(
            body: 'Email body',
            subject: 'Email subject',
            recipients: ['siambci@gmail.com'],
            attachmentPaths: [filePath],
            isHTML: false,
          );

          // Send the email
          await FlutterEmailSender.send(email);
        } else {
          showErrorDialog(context, 'No file selected');
        }
      } else {
        showErrorDialog(context, 'File picking cancelled');
      }
    } catch (error) {
      print('Error: $error');
      if (error is PlatformException && error.code == 'not_available') {
        showErrorDialog(context, 'No email clients found! Please install and configure an email client.');
      } else {
        showErrorDialog(context, 'An unexpected error occurred: $error');
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Email with Attachment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => sendEmailWithAttachment(context),
          child: Text('Send Email'),
        ),
      ),
    );
  }
}
