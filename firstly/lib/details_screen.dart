import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference announcementsCollection = FirebaseFirestore.instance.collection('announcements');
class Announcement {
  final String id; 
  final String title;
  final String location;
  final DateTime? date;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;  
  String userId;

  Announcement({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.userId,
  });
}

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message(this.sender, this.content, this.timestamp);
}
class MyApp extends StatelessWidget {
  final List<Announcement> announcements = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anzeigen'),
          backgroundColor: Colors.blue,
        ),
        body: CustomListingsScreen(announcements: announcements),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: announcements),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}   
class CustomAnnouncementDetailsScreen extends StatelessWidget {
  final Announcement announcement;
  final List<Message> messages = [];
  CustomAnnouncementDetailsScreen({required this.announcement});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titel: ${announcement.title.toString()}"),
              Text("Ort: ${announcement.location.toString()}"),
              Text("Beschreibung: ${announcement.description.toString()}"),
              Text("Datum: ${announcement.date != null ? announcement.date!.toString() : 'Non spécifié'}"),
              Text("Anfangszeit: ${announcement.startTime.format(context)}"),
              Text("Endzeit: ${announcement.endTime.format(context)}"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomMessagingScreen(announcement: announcement, messages: []),
                  ),
                );
              },
              child: Text("Chatten"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          }
          
        },
      ),
    );
  }
}
class CustomCreateListingScreen extends StatefulWidget {
  final List<Announcement> announcements;
  CustomCreateListingScreen({required this.announcements});
  @override
  _CustomCreateListingScreenState createState() => _CustomCreateListingScreenState();
}
class _CustomCreateListingScreenState extends State<CustomCreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String location = '';
  DateTime? selectedDate; 
  TimeOfDay? startTime; 
  TimeOfDay? endTime;  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
FirebaseAuth _auth = FirebaseAuth.instance;
 void _submitForm () {
  if (_formKey.currentState != null) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newAnnouncement = Announcement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        location: location,
        date: selectedDate,
        startTime: startTime ?? TimeOfDay(hour: 0, minute: 0),
        endTime: endTime ?? TimeOfDay(hour: 0, minute: 0),
        description: description,
        userId: _auth.currentUser?.uid ?? '',
      );
      
      DateTime startDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, newAnnouncement.startTime.hour, newAnnouncement.startTime.minute);
      DateTime endDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, newAnnouncement.endTime.hour, newAnnouncement.endTime.minute);

      FirebaseFirestore.instance.collection('announcements').add({
        'title': newAnnouncement.title,
        'location': newAnnouncement.location,
        'startDateTime': startDateTime,  
        'endDateTime': endDateTime,
        'description': newAnnouncement.description,
        'userId': _auth.currentUser?.uid,
      }).then((_) {
        setState(() {
          widget.announcements.add(newAnnouncement);
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Anzeige erstellt!'),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomListingsScreen(announcements: widget.announcements),
          ),
        );
      }).catchError((error) {
        print('Error adding announcement to Firestore: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Erstellen der Anzeige: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anzeige erstellen'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titel der Anzeige',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Titel eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Beschreibung der Aufgabe',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Beschreibung eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ort',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ort eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(
                    "Datum der Aufgabe: ${selectedDate?.toLocal().toString().split(' ')[0] ?? 'Nicht ausgewählt'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today), 
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    "Anfangszeit: ${startTime?.format(context) ?? 'Nicht eingegeben'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectStartTime(context), 
                    icon: Icon(Icons.access_time),
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ], 
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    "Endezeit: ${endTime?.format(context) ?? 'Nicht eingegeben'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectEndTime(context), 
                    icon: Icon(Icons.access_time),
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ], 
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomListingsScreen(announcements: widget.announcements),
                    ),
                  );
                },
                child: Text(
                  'Anzeige erstellen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomListingsScreen(announcements: widget.announcements),
                      ),
                    );
                  },
                  child: Text(
                    'Anzeige sehen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, 
        onTap: (index) {
          if (index == 0) {
            print("Home");
          } else if (index == 1) {
            print("Nachrichten");
          } else if (index == 2) {
            print("Kalender");
          } else if (index == 3) {
            print("Konto");
          }
        },
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: startTime ?? TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      startTime = picked;
    });
  }
}

Future<void> _selectEndTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: endTime ?? TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      endTime = picked;
    });
  }
}
}
class CustomListingsScreen extends StatefulWidget {
  final List<Announcement> announcements;
  CustomListingsScreen({required this.announcements});
  @override
  _CustomListingsScreenState createState() => _CustomListingsScreenState();
}
class _CustomListingsScreenState extends State<CustomListingsScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              title: Text("Anzeige Hilfe",
              style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
              ),
          backgroundColor: Colors.blue,
          ),    
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final announcement = widget.announcements[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(10.0), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), 
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2), 
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(announcement.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Titre: ${announcement.title}"),
                          Text("Lieu: ${announcement.location}"),
                          Text("Description: ${announcement.description}"),
                          Text("Date: ${announcement.date != null ? DateFormat('yyyy-MM-dd').format(announcement.date!) : 'Non spécifié'}"),                          Text("Heure de début: ${announcement.startTime.format(context)}"),
                          Text("Heure de fin: ${announcement.endTime.format(context)}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomAnnouncementDetailsScreen(announcement: widget.announcements[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: widget.announcements.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            print("Home");
          } else if (index == 1) {
            print("Nachrichten");
          } else if (index == 2) {
            print("Kalender");
          } else if (index == 3) {
            print("Konto");
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
class CustomMessagingScreen extends StatefulWidget {
  final Announcement announcement;
  final List<Message> messages;
  CustomMessagingScreen({required this.announcement, required this.messages});
  @override
  _CustomMessagingScreenState createState() => _CustomMessagingScreenState();
}
class _CustomMessagingScreenState extends State<CustomMessagingScreen> {
  final _textController = TextEditingController();
  void _sendMessage() {
    final message = _textController.text;
    if (message.isNotEmpty) {
      final newMessage = Message("Me", message, DateTime.now());
      setState(() {
        widget.messages.add(newMessage);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.announcement.title),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[index];
                final isMe = message.sender == "Me";

                return ListTile(
                  title: Text(
                    isMe ? "Ich" : message.sender,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(message.content),
                  tileColor: isMe ? Colors.blue[200] : Colors.blue[100],
                  contentPadding: EdgeInsets.all(10),
                  visualDensity: VisualDensity.standard,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Nachricht eingeben...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}