import 'package:flutter/material.dart';


class ScaffoldTabs extends StatefulWidget
{

  Color backgroundColor;
  String title = "Titulo";
  Color indicatorTabsColor;
  List<Tab> tabs;
  List<Widget> views;
  Widget drawer;
  Widget floattingActionButton;
  Widget bottomNavigationBar;

  ScaffoldTabs({this.title, this.backgroundColor, this.tabs, this.views, this.indicatorTabsColor, this.drawer, this.floattingActionButton, this.bottomNavigationBar});

  @override
  _ScaffoldTabsState createState() => _ScaffoldTabsState();
}

class _ScaffoldTabsState extends State<ScaffoldTabs> with SingleTickerProviderStateMixin
{


  TabController _controller;

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        title: Text(widget.title),
        bottom: TabBar(
          indicatorColor: widget.indicatorTabsColor,
          controller: _controller,
          tabs: widget.tabs,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: widget.views,
      ),
      floatingActionButton: widget.floattingActionButton,
      drawer: widget.drawer,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
