class PortfolioData {
  static const String name = 'Ahmed Allaw';
  static const String brandName = 'Ahmed';
  static const String role = 'Flutter Developer';
  static const String subrole = 'Mobile Application Developer';
  static const String email = 'ahmed.allaw@example.com';
  static const String github = 'https://github.com/GHOST3030';
  static const String avatarUrl = '';

  static const String bio =
      'IT student turned Flutter developer. I build production-grade mobile '
      'applications with a focus on clean architecture, performance, and scalability. '
      'Passionate about Riverpod state management, Supabase backends, and shipping '
      'real apps that solve real problems.';

  static const String aboutLong =
      'I\'m Ahmed Allaw, a mobile application developer specializing in Flutter. '
      'My approach to development is shaped by production thinking: every feature is '
      'built with scalability, maintainability, and performance in mind from day one. '
      'I work with a strict three-layer architecture (data / domain / presentation), '
      'use Riverpod 2.x for state management, and rely on Supabase for backend services. '
      'Currently studying IT while building real-world applications including e-commerce '
      'platforms, automation tools, and developer utilities.';

  static const List<Map<String, dynamic>> skills = [
    {'name': 'Flutter', 'level': 0.9, 'category': 'mobile'},
    {'name': 'Dart', 'level': 0.9, 'category': 'mobile'},
    {'name': 'Riverpod 2.x', 'level': 0.85, 'category': 'mobile'},
    {'name': 'Supabase', 'level': 0.8, 'category': 'backend'},
    {'name': 'GoRouter', 'level': 0.8, 'category': 'mobile'},
    {'name': 'Python', 'level': 0.75, 'category': 'backend'},
    {'name': 'PostgreSQL', 'level': 0.7, 'category': 'backend'},
    {'name': 'PHP / PDO', 'level': 0.65, 'category': 'web'},
    {'name': 'MySQL', 'level': 0.7, 'category': 'backend'},
    {'name': 'C# / WinForms', 'level': 0.65, 'category': 'desktop'},
    {'name': 'Bootstrap', 'level': 0.7, 'category': 'web'},
    {'name': 'Git / GitHub', 'level': 0.8, 'category': 'tools'},
  ];

  static const List<String> techStack = [
    'Flutter',
    'Dart',
    'Riverpod',
    'Supabase',
    'GoRouter',
    'Hive',
    'Python',
    'PostgreSQL',
    'PHP',
    'MySQL',
    'C#',
    'Git',
  ];

  static const List<Map<String, dynamic>> projects = [
    {
      'title': 'Stylish E-Commerce',
      'description':
          'Production-grade Flutter e-commerce application with cursor-based pagination, '
          'Hive caching with stale-while-revalidate, sealed failure classes, exponential '
          'backoff retry, and strict feature-first architecture across 53+ files.',
      'tech': ['Flutter', 'Riverpod', 'Supabase', 'Hive', 'GoRouter'],
      'github': 'https://github.com/GHOST3030',
      'image': '',
    },
    {
      'title': 'Moodle Attendance Bot',
      'description':
          'Async Python automation tool for Moodle attendance management. Features '
          'aiohttp concurrency, TokenBucket rate limiting, typed exception hierarchy, '
          'failure isolation, and clean per-account console output with debug logging.',
      'tech': ['Python', 'aiohttp', 'asyncio'],
      'github': 'https://github.com/GHOST3030',
      'image': '',
    },
    {
      'title': 'GhostCell Network Monitor',
      'description':
          'Termux-based cellular network analysis tool with real-time band detection, '
          'operator MCC/MNC lookup, signal strength monitoring, and band lock scripting '
          'for Android devices.',
      'tech': ['Python', 'Termux', 'Shell'],
      'github': 'https://github.com/GHOST3030',
      'image': '',
    },
    {
      'title': 'LoginHunter',
      'description':
          'Username brute-force and credential testing tool built for ethical security '
          'research in controlled environments. Features sequential account processing, '
          'a startup menu, and both CLI and web-based interfaces.',
      'tech': ['Python', 'JavaScript'],
      'github': 'https://github.com/GHOST3030',
      'image': '',
    },
  ];
}
