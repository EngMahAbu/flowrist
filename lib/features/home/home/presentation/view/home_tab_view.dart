import 'package:flowrist/features/home/home/presentation/cubit/home_cubit.dart';
import 'package:flowrist/features/home/home/presentation/cubit/home_state.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/home_header.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/home_section.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/home_shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final homeState = state.homeLayout;

          if (homeState.isLoading) {
            return const HomeShimmer();
          }

          if (homeState.errorMessage != null) {
            return Center(child: Text(homeState.errorMessage!));
          }

          if (homeState.data == null || homeState.data!.isEmpty) {
            return const Center(child: Text('No content available'));
          }

          final sections = homeState.data!;

          return ListView.builder(
            itemCount: sections.length + 1,
            itemBuilder: (context, index) {
              // Header
              if (index == 0) {
                return HomeHeader();
              }

              // Home sections
              final section = sections[index - 1];

              return HomeSection(section: section);
            },
          );
        },
      ),
    );
  }
}
