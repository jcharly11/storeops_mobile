import 'package:flutter/material.dart';

class MenuItems {
  final String title;
  final String subTitle;
  final String link;
  final IconData  icon;

  const MenuItems({required this.title, required this.subTitle, required this.link, required this.icon});
}

const appMenuItems= <MenuItems>[
  MenuItems(
    title: 'Real Time Events',
    subTitle: 'Events for readers', 
    link: '/events', 
    icon: Icons.cloud_sync_outlined
  ),
   MenuItems(
    title: 'Daily Report',
    subTitle: 'Report today', 
    link: '/reports', 
    icon: Icons.content_paste_search_sharp
  ),
   MenuItems(
    title: 'Settings',
    subTitle: 'Config App', 
    link: '/settings', 
    icon: Icons.settings_outlined
  )
];