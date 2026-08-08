import 'package:flutter/material.dart';

/// ─── PERSON MODEL ─────────────────────────────────────────────────────────

class Person {
  final String id;
  final String name;

  const Person({required this.id, required this.name});
}

/// ─── CARD TYPE ────────────────────────────────────────────────────────────

enum CardType { glass, dark }

/// ─── PROJECT MODEL ────────────────────────────────────────────────────────

class Project {
  final String id;
  final String title;
  final String category;
  final String status;
  final String priority;
  final String date;
  final int completion; // 0–100
  final Color color;
  final List<Person> people;
  final CardType cardType;

  const Project({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.priority,
    required this.date,
    required this.completion,
    required this.color,
    required this.people,
    required this.cardType,
  });
}

/// ─── GOAL MODEL ───────────────────────────────────────────────────────────

class Goal {
  final String id;
  final String num;
  final String title;
  final String page;

  const Goal({
    required this.id,
    required this.num,
    required this.title,
    required this.page,
  });
}

/// ─── CHAT MESSAGE MODEL ───────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String author;
  final String message;
  final String time;

  const ChatMessage({
    required this.id,
    required this.author,
    required this.message,
    required this.time,
  });
}

/// ─── PROJECT DETAIL MODEL ─────────────────────────────────────────────────

class ProjectDetail {
  final String title;
  final String category;
  final Person createdBy;
  final String dateDay;
  final String dateMonth;
  final String meetLink;
  final List<Person> people;
  final List<Goal> goals;
  final List<ChatMessage> chat;

  const ProjectDetail({
    required this.title,
    required this.category,
    required this.createdBy,
    required this.dateDay,
    required this.dateMonth,
    required this.meetLink,
    required this.people,
    required this.goals,
    required this.chat,
  });
}
