import 'package:flutter/material.dart';

class Customer {
  final String username;
  final String email;
  final String urlAvatar;
  final double cost;
  final String sellingDate;

  const Customer({
    required this.username,
    required this.email,
    required this.urlAvatar,
    required this.cost,
    required this.sellingDate,
  });
}