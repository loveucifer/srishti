import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalPane extends StatelessWidget {
  const TerminalPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SRISHTI TERMINAL',
              style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              '[${DateTime.now().toIso8601String()}] Live preview session started.',
              style: GoogleFonts.robotoMono(color: Colors.greenAccent, fontSize: 13),
            ),
             Text(
              '> Ready.',
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
