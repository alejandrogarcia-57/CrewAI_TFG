import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final int index;
  final String tipo;
  final Color colorBase;
  final Widget pagina;

  const ExerciseCard({
    super.key,
    required this.index, 
    required this.tipo, 
    required this.colorBase, 
    required this.pagina
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click, 
      child: AnimatedContainer(
        height: 70,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        
        margin: EdgeInsets.only(
          bottom: isHovered ? 20.0 : 12.0, 
          top: isHovered ? 0.0 : 8.0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isHovered ? 0.3 : 0.15),
              blurRadius: isHovered ? 15 : 8,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withValues(alpha: 0.85),
              widget.colorBase,
            ],
            stops: const [0.0, 0.6],
          ),
          border: Border.all(
            color: isHovered ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.1),
            width: isHovered ? 2 : 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: Text(
            "Ejercicio ${widget.index}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.tipo.toUpperCase(),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
          ),
          trailing: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(right: isHovered ? 10 : 0),
            child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.pagina),
            );
          },
        ),
      ),
    );
  }
}