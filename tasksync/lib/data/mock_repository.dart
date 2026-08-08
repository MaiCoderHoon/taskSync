import 'package:flutter/material.dart';
import 'models/project_model.dart';

/// ─── MOCK REPOSITORY ──────────────────────────────────────────────────────
/// Mirrors what the Notion API would return.
/// Replace method bodies with real API calls when integrating.

class MockRepository {
  MockRepository._();

  // ── Current user ──────────────────────────────────────────────────────────
  static const Person currentUser = Person(id: 'u1', name: 'Piyush Bisoi');

  // ── People ────────────────────────────────────────────────────────────────
  static const Person deksha = Person(id: 'u2', name: 'Deeksha Singh');
  static const Person ana = Person(id: 'u3', name: 'Anamika Singh');
  static const Person guna = Person(id: 'u4', name: 'Guna Rao');
  static const Person kush = Person(id: 'u5', name: 'Kushagra');

  // ── Projects list ─────────────────────────────────────────────────────────
  static List<Project> get projects => const [
    Project(
      id: 'p1',
      title: 'Website Builder',
      category: 'Website',
      status: 'Ongoing',
      priority: 'High',
      date: 'January 12th',
      completion: 68,
      color: Color(0xFFB8845A),
      cardType: CardType.glass,
      people: [deksha, ana, guna],
    ),
    Project(
      id: 'p2',
      title: 'Finance landing page',
      category: 'Website',
      status: 'Ongoing',
      priority: 'Medium',
      date: 'August 6th',
      completion: 34,
      color: Color(0xFF5A5A5A),
      cardType: CardType.dark,
      people: [deksha, ana, guna],
    ),
    Project(
      id: 'p3',
      title: 'Logo guideline',
      category: 'Branding',
      status: 'Review',
      priority: 'Low',
      date: 'August 9th',
      completion: 91,
      color: Color(0xFF6B7A5A),
      cardType: CardType.dark,
      people: [ana, guna],
    ),
    Project(
      id: 'p4',
      title: 'Mobile App',
      category: 'Product',
      status: 'Ongoing',
      priority: 'High',
      date: 'September 1st',
      completion: 22,
      color: Color(0xFF7A5A8A),
      cardType: CardType.glass,
      people: [
        Person(id: 'u1', name: 'Jonas Khanwald'),
        deksha,
        kush,
      ],
    ),
  ];

  // ── Project detail ────────────────────────────────────────────────────────
  static ProjectDetail get websiteBuilderDetail => const ProjectDetail(
    title: 'Website Builder',
    category: 'Website',
    createdBy: ana,
    dateDay: '6',
    dateMonth: 'August',
    meetLink: 'meet.google.com/tnk-zcth-xin',
    people: [
      deksha,
      ana,
      guna,
      kush,
      Person(id: 'u1', name: 'Piyush Bisoi'),
    ],
    goals: [
      Goal(
        id: 'g1',
        num: '01',
        title: 'Create design system',
        page: 'All page',
      ),
      Goal(
        id: 'g2',
        num: '02',
        title: 'Brainstorm style ideas',
        page: 'Landing',
      ),
      Goal(
        id: 'g3',
        num: '03',
        title: 'Wireframe checkout flow',
        page: 'Checkout',
      ),
      Goal(id: 'g4', num: '04', title: 'Typography audit', page: 'Brand'),
    ],
    chat: [
      ChatMessage(
        id: 'c1',
        author: 'Piyush Bisoi',
        message: 'Design system draft is ready for review',
        time: '10:24 AM',
      ),
      ChatMessage(
        id: 'c2',
        author: 'Kushagra',
        message: "Looks great! I'll check the typography section",
        time: '10:31 AM',
      ),
      ChatMessage(
        id: 'c3',
        author: 'Piyush Bisoi',
        message: "Let's sync tomorrow at 9am",
        time: '11:02 AM',
      ),
    ],
  );
}
