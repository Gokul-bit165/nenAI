import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/editor/note_editor_screen.dart';
import '../screens/detail/note_detail_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/topics/topics_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/topics/cluster_detail_screen.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String editor = '/editor';
  static const String detail = '/detail/:id';
  static const String search = '/search';
  static const String topics = '/topics';
  static const String clusterDetail = '/topics/:id';
  static const String chat = '/chat';
  static const String calendar = '/calendar';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.editor,
      builder: (context, state) {
        final noteId = state.extra as String?;
        return NoteEditorScreen(noteId: noteId);
      },
    ),
    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoteDetailScreen(noteId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.topics,
      builder: (context, state) => const TopicsScreen(),
    ),
    GoRoute(
      path: AppRoutes.clusterDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = (state.extra as String?) ?? 'Topic Notes';
        return ClusterDetailScreen(clusterId: id, clusterName: name);
      },
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.calendar,
      builder: (context, state) => const CalendarScreen(),
    ),
  ],
);
