/* go_router のルートを管理するファイル */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_timetable/class_main_page.dart';
import 'package:todo_timetable/main.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const AppHomePage(),
      // 全ての時間割に対応するルート
      // 書くClassMainPageの引数には時間割の名前を渡す
      routes: [
        GoRoute(
            name: 'class_1_1',
            path: 'class_1_1/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_1_2',
            path: 'class_1_2/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_1_3',
            path: 'class_1_3/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_1_4',
            path: 'class_1_4/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_1_5',
            path: 'class_1_5/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_1_6',
            path: 'class_1_6/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_1',
            path: 'class_2_1/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_2',
            path: 'class_2_2/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_3',
            path: 'class_2_3/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_4',
            path: 'class_2_4/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_5',
            path: 'class_2_5/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_2_6',
            path: 'class_2_6/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_1',
            path: 'class_3_1/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_2',
            path: 'class_3_2/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_3',
            path: 'class_3_3/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_4',
            path: 'class_3_4/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_5',
            path: 'class_3_5/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_3_6',
            path: 'class_3_6/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_1',
            path: 'class_4_1/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_2',
            path: 'class_4_2/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_3',
            path: 'class_4_3/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_4',
            path: 'class_4_4/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_5',
            path: 'class_4_5/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_4_6',
            path: 'class_4_6/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_1',
            path: 'class_5_1/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_2',
            path: 'class_5_2/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_3',
            path: 'class_5_3/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_4',
            path: 'class_5_4/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_5',
            path: 'class_5_5/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
        GoRoute(
            name: 'class_5_6',
            path: 'class_5_6/:className/:color',
            builder: (context, state) {
              final String className = state.pathParameters['className']!;
              final int colorCode = int.parse(state.pathParameters['color']!);
              return ClassMainPage(
                  className: className,
                  color: Color(colorCode));
            }),
      ],
    )
  ],
);
