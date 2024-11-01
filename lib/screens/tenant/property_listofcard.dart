class Property {
  final String bhk;
  final String price;
  final String imageURL;
  final List<String> facilities;
  final String propertyTitle;
  bool isVerified;

  Property({
    required this.bhk,
    required this.price,
    required this.imageURL,
    required this.facilities,
    required this.propertyTitle,
    this.isVerified = true, // Default value of isVerified is true
  });

  // Factory constructor to create a Property object from a Firestore document
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      bhk: map['bhk'] ?? 'BHK', // Default to 'Unknown BHK' if missing
      price: map['price'] ?? '0', // Default to '0' if price is missing
      imageURL: map['imageURL'] ?? '', // Default to an empty string if missing
      facilities: List<String>.from(map['facilities'] ?? []), // Handle null facilities
      propertyTitle: map['propertyTitle'] ?? 'Property', // Default to 'Unknown Property'
      isVerified: map['isVerified'] ?? true, // Default to true if not present
    );
  }

  // Convert Property object to Firestore map (if needed for saving properties)
  Map<String, dynamic> toMap() {
    return {
      'bhk': bhk,
      'price': price,
      'imageURL': imageURL,
      'facilities': facilities,
      'propertyTitle': propertyTitle,
      'isVerified': isVerified, // Include isVerified in Firestore map
    };
  }
}
