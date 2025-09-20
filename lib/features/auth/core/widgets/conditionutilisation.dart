import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TermsAndConditions({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, -2),
          child: Checkbox(
            value: value,
            onChanged: (newValue) => onChanged(newValue ?? false),
            activeColor: const Color(0xFF0054A4),
            side: BorderSide(
              color: value ? const Color(0xFF0054A4) : Colors.grey,
              width: 1.5,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: "J'accepte les ",
                  style: TextStyle(
                    color: Color(0xFF0B1340),
                    height: 1.4,
                  )
                ),
                TextSpan(
                  text: "conditions d'utilisation",
                  style: const TextStyle(
                    color: Color(0xFF0054A4),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    // Action pour ouvrir les conditions d'utilisation
                  },
                ),
                const TextSpan(
                  text: " de l'application et je consens à ce que mes renseignements soient traités de la manière décrite dans la ",
                ),
                TextSpan(
                  text: "politique de confidentialité de Centris",
                  style: const TextStyle(
                    color: Color(0xFF0054A4),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    // Action pour ouvrir la politique de confidentialité
                  },
                ),
                const TextSpan(text: "."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}