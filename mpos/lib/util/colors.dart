import 'package:flutter/material.dart';
const LinearGradient appGradient = LinearGradient(
  colors: [Colors.blueAccent, Colors.purpleAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
); 



final LinearGradient backgroundGradient = LinearGradient(
  colors: [
    Colors.white,
    Colors.blue.shade50.withOpacity(0.6),
    Colors.purple.shade50.withOpacity(0.6),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);



const welcomeGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(255, 240, 241, 242), // Deep navy blue (trust & professionalism)
    Color.fromARGB(0, 227, 227, 227), // Calming blue (clarity & calm)
    Color.fromARGB(255, 106, 119, 122), // Aqua blue (energy & tech-savvy)
  ],
);
