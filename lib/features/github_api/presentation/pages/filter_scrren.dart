// ignore_for_file: library_private_types_in_public_api

import 'package:abanoub_ezzat_geithub_api_task/core/resources/color_manager.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/entites/github_api_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/github_api_cubit.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<GithubRepoEntity> _filteredRepos;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredRepos = BlocProvider.of<GithubReposCubit>(context).repos!;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRepos(String query) {
    setState(() {
      _filteredRepos = BlocProvider.of<GithubReposCubit>(context)
          .repos!
          .where(
              (repo) => repo.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.primaryColor,
        key: _scaffoldKey,
        appBar: appBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: TextField(
                controller: _searchController,
                onChanged: _filterRepos,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsManager.appbarColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsManager.appbarColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0.r),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _filteredRepos.isEmpty
                  ? noReposFound()
                  : RefreshIndicator(
                      onRefresh: () => _onRefresh(context),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredRepos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            child: InkWell(
                              onLongPress: () {
                                dialog(
                                    context: context,
                                    repoUrl: _filteredRepos[index].repoHtmlUrl,
                                    ownerUrl:
                                        _filteredRepos[index].ownerHtmlUrl);
                              },
                              child: repoDataWidget(
                                name: _filteredRepos[index].name,
                                description: _filteredRepos[index].description,
                                ownerUsername:
                                    _filteredRepos[index].ownerUsername,
                                fork: _filteredRepos[index].fork,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Search"),
      backgroundColor: ColorsManager.appbarColor,
      elevation: 0,
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

  Widget noReposFound() {
    return Center(
      child: Text(
        "No repos found",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21.sp),
      ),
    );
  }
}
