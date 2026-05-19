import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/recent_address_tile_widget.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/saved_place_widget.dart';

class SavedPlacesSection extends StatelessWidget {
  const SavedPlacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: const [
          SavedPlaceTile(
            title: "Home",
            subtitle: "Neemuch RD. Gopalbari, Bari Sadri Rajasthan",
          ),
          SizedBox(height: 16),
          SavedPlaceTile(
            title: "Work",
            subtitle: "Jawahar Lal Nehru Marg, D-Block",
          ),
          SizedBox(height: 24),
          RecentTile("250 west, industrial area"),
          RecentTile("4 number gali pratap nagar"),
          RecentTile("Neemuch RD. Gopalbari, Bari Sad"),
          RecentTile("Jawahar Lal Nehru Marg, D-Block"),
        ],
      ),
    );
  }
}
