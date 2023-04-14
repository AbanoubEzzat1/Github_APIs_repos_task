import 'package:abanoub_ezzat_geithub_api_task/core/resources/color_manager.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/presentation/pages/filter_scrren.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/github_api_cubit.dart';
import '../cubit/github_api_states.dart';

class GitHubApiPage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GitHubApiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.primaryColor,
        key: _scaffoldKey,
        appBar: appBar(context),
        body: BlocBuilder<GithubReposCubit, GithubReposState>(
          builder: (context, state) {
            if (state is GithubReposLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GithubReposLoadedState) {
              return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: state.repos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: InkWell(
                        onLongPress: () {
                          dialog(
                              context: context,
                              repoUrl: state.repos[index].repoHtmlUrl,
                              ownerUrl: state.repos[index].ownerHtmlUrl);
                        },
                        child: repoDataWidget(
                          name: state.repos[index].name,
                          description: state.repos[index].description,
                          ownerUsername: state.repos[index].ownerUsername,
                          fork: state.repos[index].fork,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is GithubReposErrorState) {
              return Container(
                  height: 200.h, width: 200.w, color: ColorsManager.red);
            }
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: ColorsManager.orange,
                    color: ColorsManager.lightGrey));
          },
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.appbarColor,
      title: const Text("GitHub APIs"),
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0.w),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.search,
                size: 30.h,
              )),
        )
      ],
    );
  }

  Widget repoDataWidget({
    required String name,
    required String description,
    required String ownerUsername,
    required bool fork,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: fork ? ColorsManager.lightGreen : ColorsManager.secondryColor,
        ),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              ownerUsername,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<GithubReposCubit>(context).clearCache();
    BlocProvider.of<GithubReposCubit>(context).getGithubRepos(0);
  }

  void dialog({
    required BuildContext context,
    required String repoUrl,
    required String ownerUrl,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.primaryColor,
          title: const Text('Go to:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: const Text('Repository URL'),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final url = repoUrl;
                    if (!await launchUrl(Uri.parse(url))) {
                      throw "can not launch url";
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0.h)),
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: const Text('Owner URL'),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final url = ownerUrl;
                    if (!await launchUrl(Uri.parse(url))) {
                      throw "can not launch url";
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
