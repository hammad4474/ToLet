import 'package:flutter/material.dart';

class ComplaintsSection extends StatefulWidget {
  @override
  _ComplaintsSectionState createState() => _ComplaintsSectionState();
}

class _ComplaintsSectionState extends State<ComplaintsSection> {
  int _currentPage = 1;
  int _itemsPerPage = 4;

  // Dummy data for complaints
  List<Map<String, dynamic>> _complaints = [
    {"tenant": "Ramesh D.", "complaint": "Water tank leakage", "severity": Colors.green},
    {"tenant": "Cabin K.", "complaint": "Elevator shaking", "severity": Colors.yellow},
    {"tenant": "Tylor S.", "complaint": "Parking area is crowded", "severity": Colors.orange},
    {"tenant": "Micheal J.", "complaint": "No water since Monday", "severity": Colors.red},
    {"tenant": "John D.", "complaint": "Electricity issue", "severity": Colors.pink},
    {"tenant": "Nina K.", "complaint": "Air conditioning not working", "severity": Colors.blue},
    {"tenant": "Ramesh D.", "complaint": "Water tank leakage", "severity": Colors.green},
    {"tenant": "Cabin K.", "complaint": "Elevator shaking", "severity": Colors.yellow},
    {"tenant": "Tylor S.", "complaint": "Parking area is crowded", "severity": Colors.pink},
    {"tenant": "Micheal J.", "complaint": "No water since Monday", "severity": Colors.red},
    {"tenant": "John D.", "complaint": "Electricity issue", "severity": Colors.green},
    {"tenant": "Nina K.", "complaint": "Air conditioning not working", "severity": Colors.blue},
    {"tenant": "Cabin K.", "complaint": "Elevator shaking", "severity": Colors.yellow},
    {"tenant": "Tylor S.", "complaint": "Parking area is crowded", "severity": Colors.pink},
    {"tenant": "Micheal J.", "complaint": "No water since Monday", "severity": Colors.red},
    {"tenant": "John D.", "complaint": "Electricity issue", "severity": Colors.green},
    {"tenant": "Nina K.", "complaint": "Air conditioning not working", "severity": Colors.blue},
  ];

  // Method to get paginated data
  List<Map<String, dynamic>> _getPaginatedComplaints() {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    return _complaints.sublist(start, end > _complaints.length ? _complaints.length : end);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust item count per page based on screen width
        if (constraints.maxWidth > 800) {
          _itemsPerPage = 6;
        } else if (constraints.maxWidth > 600) {
          _itemsPerPage = 5;
        } else {
          _itemsPerPage = 4;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaints',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  dividerThickness: 2.0,  // Adjust this value for thicker lines
                  dataRowHeight: 60,  // Adjust row height if needed
                  headingRowHeight: 56,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Tenant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Complaints',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sevierity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                  rows: _getPaginatedComplaints().map((complaint) {
                    return DataRow(cells: [
                      DataCell(Text(complaint['tenant'])),
                      DataCell(Text(complaint['complaint'])),
                      DataCell(
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: complaint['severity'],
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildPagination(),
          ],
        );
      },
    );
  }

  // Pagination widget
  Widget _buildPagination() {
    int totalPages = (_complaints.length / _itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _currentPage = index + 1;
              });
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,  // Rectangle for square shape
                color: _currentPage == index + 1 ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(4), // Small border radius for square corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color with some opacity
                    spreadRadius: 2,                     // Spread of the shadow
                    blurRadius: 5,                       // Blurring effect of the shadow
                    offset: Offset(0, 3),                // Position of shadow (x, y)
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: _currentPage == index + 1 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
