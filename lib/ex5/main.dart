import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomBarPage(),
    );
  }
}

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 3; 
  bool _fabOpen = false;
  late AnimationController _animCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _fabOpen = !_fabOpen;
      _fabOpen ? _animCtrl.forward() : _animCtrl.reverse();
    });
  }

  static const List<_SpeedDialItem> _speedDials = [
    _SpeedDialItem(icon: Icons.chat_bubble_outline, label: 'Mensagem'),
    _SpeedDialItem(icon: Icons.mail_outline, label: 'E-mail'),
    _SpeedDialItem(icon: Icons.phone_outlined, label: 'Ligação'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomAppBar with FAB'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'TAB: $_selectedTab',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._speedDials.reversed.map((item) {
            return ScaleTransition(
              scale: _expandAnim,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: _fabOpen ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton.small(
                      heroTag: item.label,
                      onPressed: () {},
                      backgroundColor: Colors.blue[700],
                      child: Icon(item.icon, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }),

          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: Colors.blue,
            child: AnimatedRotation(
              turns: _fabOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TabButton(
                index: 0,
                icon: Icons.list,
                label: 'Menu1',
                selected: _selectedTab,
                onTap: (i) => setState(() => _selectedTab = i),
              ),
              _TabButton(
                index: 1,
                icon: Icons.diamond_outlined,
                label: 'Menu2',
                selected: _selectedTab,
                onTap: (i) => setState(() => _selectedTab = i),
              ),
              const SizedBox(width: 56),
              _TabButton(
                index: 2,
                icon: Icons.grid_view,
                label: 'Menu3',
                selected: _selectedTab,
                onTap: (i) => setState(() => _selectedTab = i),
              ),
              _TabButton(
                index: 3,
                icon: Icons.table_bar,
                label: 'Menu4',
                selected: _selectedTab,
                onTap: (i) => setState(() => _selectedTab = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedDialItem {
  final IconData icon;
  final String label;
  const _SpeedDialItem({required this.icon, required this.label});
}

class _TabButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int selected;
  final ValueChanged<int> onTap;

  const _TabButton({
    required this.index,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    final color = isSelected ? Colors.blue : Colors.grey;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
