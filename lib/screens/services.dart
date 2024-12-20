import 'package:flutter/material.dart';
import 'package:yanguwa_app/screens/bookings.dart';
import 'package:yanguwa_app/screens/profile.dart';
import 'package:yanguwa_app/screens/home_screen.dart';
import 'package:yanguwa_app/services/api_service.dart';
import '../models/service.dart';
import 'package:yanguwa_app/screens/service_detail.dart';
import 'package:get/get.dart';
import 'package:yanguwa_app/authentication/controller/auth_controller.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authenticationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Service>>(
              future: fetchServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No services available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0.5,
                                blurRadius: 1.5,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              service.title,
                              style: const TextStyle(
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            leading: const Icon(
                              Icons.work,
                              color: Colors.amber,
                            ), // Replace with actual icon
                            subtitle: Text(service.description),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey,
                            ), // Add trailing icon
                            onTap: () {
                              // Navigate to service provider profile screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailScreen(
                                      serviceId: service.id),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(color: Color(0xFF1A237E)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              Icons.home,
              'Home',
              false,
              HomeScreen(userName: authenticationController.userName.value),
            ),
            _buildNavItem(context, Icons.work, 'Services', true, Services()),
            _buildNavItem(
              context,
              Icons.book,
              'Bookings',
              false,
              BookingsScreen(),
            ),
            _buildNavItem(
              context,
              Icons.person,
              'Profile',
              false,
              ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      bool isActive, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.amber : Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.amber : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
