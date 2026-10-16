import 'package:flutter/material.dart';

void main() => runApp(const VellMessengerApp());

const brand = Color(0xFF087F6E);
const ink = Color(0xFF102A27);
const muted = Color(0xFF74817E);
const canvas = Color(0xFFF5F8F7);

class VellMessengerApp extends StatelessWidget {
  const VellMessengerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Vell Messenger',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.light),
      appBarTheme: const AppBarTheme(backgroundColor: canvas, foregroundColor: ink, elevation: 0)),
    home: const MessengerHome(),
  );
}

class ChatContact {
  final String name, message, time, initials;
  final Color color;
  final int unread;
  final bool online, read;
  const ChatContact(this.name, this.message, this.time, this.initials, this.color,
      {this.unread = 0, this.online = false, this.read = false});
}

const contacts = [
  ChatContact('Amara Okafor', 'Voice message · 0:18', '2 min', 'AO', Color(0xFFE9B6A0), unread: 2, online: true),
  ChatContact('Netville Digital Hub', 'You: The new design is ready ✓✓', '9:41 AM', 'N', Color(0xFFB6D8CA), read: true),
  ChatContact('David Williams', 'Are we still meeting today?', '9:22 AM', 'DW', Color(0xFFC5C8F2), unread: 1),
  ChatContact('Family Group', 'Mum: Take care everyone ❤️', 'Yesterday', 'FG', Color(0xFFF0D49C), unread: 4),
  ChatContact('Chisom', '😂😂 this is too funny', 'Yesterday', 'C', Color(0xFFE4B5D0), read: true),
  ChatContact('Michael James', 'Thanks bro, appreciate it', 'Monday', 'MJ', Color(0xFFB9D8E9)),
  ChatContact('Uniport Classmates', 'Ada: Has anyone got the notes?', 'Monday', 'UC', Color(0xFFD2C5AE), unread: 3),
  ChatContact('Blessing', 'Photo', 'Sunday', 'B', Color(0xFFC4D7A8)),
];

class MessengerHome extends StatefulWidget {
  const MessengerHome({super.key});
  @override State<MessengerHome> createState() => _MessengerHomeState();
}
class _MessengerHomeState extends State<MessengerHome> {
  int tab = 0;
  String query = '';
  final searchController = TextEditingController();
  @override void dispose() { searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final titles = ['Chats', 'Updates', 'Communities', 'Calls'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vell', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -1, color: brand)),
        actions: [
          IconButton(onPressed: () => _snack('Camera is ready to connect'), icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(onPressed: () => _snack('New message'), icon: const Icon(Icons.add_comment_outlined)),
          PopupMenuButton<String>(onSelected: _snack, itemBuilder: (_) => const [
            PopupMenuItem(value: 'New group', child: Text('New group')),
            PopupMenuItem(value: 'Starred messages', child: Text('Starred messages')),
            PopupMenuItem(value: 'Settings', child: Text('Settings')),
          ]),
        ],
      ),
      body: IndexedStack(index: tab, children: [
        _chats(),
        _simplePage('Updates', Icons.donut_large_rounded, 'Share a moment with your friends.', 'My status'),
        _simplePage('Communities', Icons.groups_rounded, 'Bring your groups together in one place.', 'New community'),
        _calls(),
      ]),
      floatingActionButton: tab == 0 ? FloatingActionButton(
        backgroundColor: brand, foregroundColor: Colors.white, onPressed: _newChat,
        child: const Icon(Icons.chat_rounded)) : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: Colors.white, indicatorColor: const Color(0xFFD8F2E9),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.circle_outlined), selectedIcon: Icon(Icons.donut_large), label: 'Updates'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Communities'),
          NavigationDestination(icon: Icon(Icons.call_outlined), selectedIcon: Icon(Icons.call), label: 'Calls'),
        ]),
    );
  }

  Widget _chats() {
    final filtered = contacts.where((c) => c.name.toLowerCase().contains(query.toLowerCase()) || c.message.toLowerCase().contains(query.toLowerCase())).toList();
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 2, 16, 12), child: TextField(
        controller: searchController, onChanged: (v) => setState(() => query = v),
        decoration: InputDecoration(
          hintText: 'Ask or search', prefixIcon: const Icon(Icons.search, color: muted), suffixIcon: query.isEmpty ? const Icon(Icons.tune, color: muted) : IconButton(icon: const Icon(Icons.close), onPressed: () { searchController.clear(); setState(() => query = ''); }),
          filled: true, fillColor: const Color(0xFFEAF0EE), contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
      )),
      if (query.isEmpty) SizedBox(height: 43, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
        _filterChip('All', true), _filterChip('Unread', false), _filterChip('Favorites', false), _filterChip('Groups', false),
      ])),
      Expanded(child: filtered.isEmpty ? const Center(child: Text('No chats found', style: TextStyle(color: muted))) : ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 90),
        itemCount: filtered.length, separatorBuilder: (_, __) => const SizedBox(height: 2),
        itemBuilder: (context, i) {
          final c = filtered[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
            leading: _avatar(c.initials, c.color, online: c.online),
            title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: ink, fontSize: 15)),
            subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Row(children: [
              if (c.read) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.done_all, size: 16, color: Color(0xFF42A5D5))),
              Expanded(child: Text(c.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 13))),
            ])),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(c.time, style: TextStyle(color: c.unread > 0 ? brand : muted, fontSize: 11, fontWeight: c.unread > 0 ? FontWeight.w700 : FontWeight.normal)),
              const SizedBox(height: 6),
              if (c.unread > 0) Container(width: 21, height: 21, alignment: Alignment.center, decoration: const BoxDecoration(color: brand, shape: BoxShape.circle), child: Text('${c.unread}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
            ]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(contact: c))),
          );
        },
      )),
    ]);
  }

  Widget _filterChip(String label, bool selected) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(
    label: Text(label), selected: selected, onSelected: (_) => _snack('$label chats'),
    showCheckmark: false, backgroundColor: Colors.white, selectedColor: const Color(0xFFD8F2E9),
    side: BorderSide(color: selected ? brand : const Color(0xFFDDE5E2)),
    labelStyle: TextStyle(color: selected ? brand : muted, fontWeight: FontWeight.w600),
  ));

  Widget _simplePage(String title, IconData icon, String description, String action) => ListView(padding: const EdgeInsets.all(20), children: [
    Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(children: [Icon(icon, size: 56, color: brand), const SizedBox(height: 16), Text(description, textAlign: TextAlign.center, style: const TextStyle(color: muted)), const SizedBox(height: 20), FilledButton.icon(onPressed: () => _snack('$action selected'), icon: const Icon(Icons.add), label: Text(action))])),
  ]);

  Widget _calls() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Calls', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 14),
    FilledButton.tonalIcon(onPressed: _newChat, icon: const Icon(Icons.add_call), label: const Text('Start a new call')),
    const SizedBox(height: 12),
    for (final c in contacts.take(5)) ListTile(leading: _avatar(c.initials, c.color), title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text('Recent call · ${c.time}', style: const TextStyle(color: muted)), trailing: IconButton(onPressed: () => _snack('Calling ${c.name}…'), icon: const Icon(Icons.call, color: brand))),
  ]);

  Widget _avatar(String initials, Color color, {bool online = false}) => Stack(children: [
    CircleAvatar(radius: 26, backgroundColor: color, child: Text(initials, style: const TextStyle(color: ink, fontWeight: FontWeight.w800))),
    if (online) Positioned(right: 0, bottom: 0, child: Container(width: 13, height: 13, decoration: BoxDecoration(color: const Color(0xFF20B875), shape: BoxShape.circle, border: Border.all(color: canvas, width: 2)))),
  ]);

  void _newChat() => showModalBottomSheet(context: context, showDragHandle: true, builder: (ctx) => SafeArea(child: ListView(shrinkWrap: true, children: [
    const Padding(padding: EdgeInsets.fromLTRB(20, 8, 20, 12), child: Text('Start a conversation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    for (final c in contacts) ListTile(leading: _avatar(c.initials, c.color), title: Text(c.name), onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(contact: c))); }),
  ])));

  void _snack(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

class ChatScreen extends StatefulWidget {
  final ChatContact contact;
  const ChatScreen({super.key, required this.contact});
  @override State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scroll = ScrollController();
  final messages = <Map<String, dynamic>>[
    {'text': 'Hey! How are you doing?', 'mine': false, 'time': '9:30 AM'},
    {'text': 'I’m good, thanks! How about you?', 'mine': true, 'time': '9:32 AM'},
    {'text': 'Doing great 😊 What’s up?', 'mine': false, 'time': '9:33 AM'},
  ];
  @override void dispose() { controller.dispose(); scroll.dispose(); super.dispose(); }
  void send() {
    final text = controller.text.trim(); if (text.isEmpty) return;
    setState(() { messages.add({'text': text, 'mine': true, 'time': TimeOfDay.now().format(context)}); controller.clear(); });
    Future.delayed(const Duration(milliseconds: 100), () { if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut); });
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leadingWidth: 40, titleSpacing: 4,
      title: Row(children: [
        CircleAvatar(backgroundColor: widget.contact.color, child: Text(widget.contact.initials, style: const TextStyle(color: ink, fontWeight: FontWeight.bold))),
        const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.contact.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Text(widget.contact.online ? 'online' : 'tap here for contact info', style: const TextStyle(fontSize: 11, color: muted)),
        ])),
      ]),
      actions: [IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video call selected'))), icon: const Icon(Icons.videocam_outlined)), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice call selected'))), icon: const Icon(Icons.call_outlined)), PopupMenuButton(itemBuilder: (_) => const [PopupMenuItem(value: 'Contact info', child: Text('Contact info')), PopupMenuItem(value: 'Search', child: Text('Search')), PopupMenuItem(value: 'Clear chat', child: Text('Clear chat'))])],
    ),
    body: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF5F8F6), Color(0xFFEDF5F0)])), child: Column(children: [
      Container(margin: const EdgeInsets.fromLTRB(25, 10, 25, 14), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE3F0E9), borderRadius: BorderRadius.circular(12)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline, size: 14, color: Color(0xFF60766C)), SizedBox(width: 7), Flexible(child: Text('Messages are private. Keep your conversations safe.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF60766C))))])),
      Expanded(child: ListView.builder(controller: scroll, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), itemCount: messages.length, itemBuilder: (_, i) {
        final m = messages[i]; final mine = m['mine'] as bool;
        return Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78), margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.fromLTRB(12, 9, 9, 6), decoration: BoxDecoration(color: mine ? const Color(0xFFD7F5E5) : Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(15), topRight: const Radius.circular(15), bottomLeft: Radius.circular(mine ? 15 : 4), bottomRight: Radius.circular(mine ? 4 : 15)), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 3)]), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Align(alignment: Alignment.centerLeft, child: Text(m['text'] as String, style: const TextStyle(fontSize: 15, color: ink))),
          const SizedBox(height: 4), Row(mainAxisSize: MainAxisSize.min, children: [Text(m['time'] as String, style: const TextStyle(fontSize: 10, color: muted)), if (mine) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.done_all, size: 14, color: Color(0xFF42A5D5)))]),
        ])));
      })),
      SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(8, 7, 8, 7), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)), child: Row(children: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emoji picker coming soon'))), icon: const Icon(Icons.emoji_emotions_outlined, color: muted)),
          Expanded(child: TextField(controller: controller, minLines: 1, maxLines: 5, textCapitalization: TextCapitalization.sentences, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'Message', border: InputBorder.none))),
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attachments selected'))), icon: const Icon(Icons.attach_file, color: muted)),
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera selected'))), icon: const Icon(Icons.camera_alt_outlined, color: muted)),
        ]))),
        const SizedBox(width: 7),
        CircleAvatar(radius: 25, backgroundColor: brand, child: IconButton(onPressed: send, icon: const Icon(Icons.send_rounded, color: Colors.white, size: 21))),
      ]))),
    ])),
  );
}
