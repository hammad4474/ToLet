import 'package:flutter/material.dart';

class PriceRangeWidget extends StatefulWidget {
  @override
  _PriceRangeWidgetState createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  double _minPrice = 10000;
  double _maxPrice = 30000;
  String _selectedTimePeriod = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('₹${_minPrice.toInt()} - ₹${_maxPrice.toInt()} / month', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 16),
        _buildPriceGraph(),
        _buildPriceSlider(),
        _buildTimePeriodSelector(),
      ],
    );
  }

  // Custom graph for price range
  Widget _buildPriceGraph() {
    return Container(
      height: 100, // Set appropriate height for the graph
      width: double.infinity, // Graph spans full width
      child: CustomPaint(
        painter: PriceGraphPainter(),
      ),
    );
  }

  // Slider for selecting price range
  Widget _buildPriceSlider() {
    return RangeSlider(
      values: RangeValues(_minPrice, _maxPrice),
      min: 5000,
      max: 50000,
      divisions: 10,
      onChanged: (RangeValues values) {
        setState(() {
          _minPrice = values.start;
          _maxPrice = values.end;
        });
      },
    );
  }

  // Time period buttons
  Widget _buildTimePeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTimePeriodButton('Daily'),
        _buildTimePeriodButton('Weekly'),
        _buildTimePeriodButton('Monthly'),
        _buildTimePeriodButton('Annually'),
      ],
    );
  }

  Widget _buildTimePeriodButton(String label) {
    bool isSelected = _selectedTimePeriod == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimePeriod = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.lightBlue, Colors.blue],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )
              : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 5)]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw the price graph curve
class PriceGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height); // Starting point (bottom-left)

    // Draw the curve smoothly
    path.lineTo(0, size.height * 0.8); // Start by moving up

    // Adjust the control points to form a more natural curve
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.4, size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.8, size.width * 0.6, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.4);

    path.lineTo(size.width, size.height); // Complete the path at bottom-right
    path.close();

    canvas.drawPath(path, paint); // Draw the filled path with the paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
