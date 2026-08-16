import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/editor/note_editor_screen.dart';
import '../screens/detail/note_detail_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/topics/topics_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/topics/cluster_detail_screen.dart';
import '../screens/explorer/memory_explorer_screen.dart';
import '../screens/shell/main_shell_scaffold.dart';
import '../screens/home/pending_review_screen.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String editor = '/editor';
  static const String detail = '/detail/:id';
  static const String search = '/search';
  static const String topics = '/topics';
  static const String clusterDetail = '/topics/:id';
  static const String explorer = '/explorer';
  static const String chat = '/chat';
  static const String calendar = '/calendar';
  static const String pendingReview = '/pending-review';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 1: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // Tab 2: Topics
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.topics,
              builder: (context, state) => const TopicsScreen(),
            ),
          ],
        ),
        // Tab 3: Chat Assistant
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.chat,
              builder: (context, state) => const ChatScreen(),
            ),
          ],
        ),
        // Tab 4: Calendar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.calendar,
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
      ],
    ),
    // Fullscreen Push Routes
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.editor,
      builder: (context, state) {
        final noteId = state.extra as String?;
        return NoteEditorScreen(noteId: noteId);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.detail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoteDetailScreen(noteId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.clusterDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = (state.extra as String?) ?? 'Topic Notes';
        return ClusterDetailScreen(clusterId: id, clusterName: name);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.explorer,
      builder: (context, state) => const MemoryExplorerScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.pendingReview,
      builder: (context, state) => const PendingReviewScreen(),
    ),
  ],
);
