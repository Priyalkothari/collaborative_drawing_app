import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/drawing_point.dart';

class DrawingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DrawingPoint>> getDrawingStream() {
    return _firestore.collection('drawing').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return DrawingPoint(
          id: doc.id, // Use Firestore document ID as the unique ID
          offsets: (data['offsets'] as List).map((offset) {
            return Offset(double.parse(offset['dx'].toString()), double.parse(offset['dy'].toString()));
          }).toList(),
          color: Color(data['color']),
          thickness: double.parse(data['thickness'].toString()),
        );
      }).toList();
    });
  }

  Future<void> addDrawingPoint(DrawingPoint point) async {
    await _firestore.collection('drawing').add({
      'offsets': point.offsets.map((offset) => {'dx': offset.dx, 'dy': offset.dy}).toList(),
      'color': point.color.value,
      'thickness': point.thickness,
    });
  }

  Future<void> removeDrawingPoint(String id) async {
    await _firestore.collection('drawing').doc(id).delete();
  }

  Future<void> deleteAllDrawingPoints() async {
    final querySnapshot = await _firestore.collection('drawing').get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}