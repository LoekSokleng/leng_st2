import 'package:flutter/material.dart';
import 'package:project_ma/model/course_model.dart';
import 'package:project_ma/model/course_data.dart';
import 'package:project_ma/page/course_details.dart';

class HomePage extends StatelessWidget {
  final CourseService courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Hi, Programmer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search here...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),

              // Categories
              const Text("Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  categoryItem(Icons.category, "Category", Colors.yellow),
                  categoryItem(Icons.class_, "Classes", Colors.purple),
                  categoryItem(
                      Icons.free_breakfast, "Free Course", Colors.blueAccent),
                  categoryItem(Icons.book, "BookStore", Colors.red),
                  categoryItem(Icons.live_tv, "Live Course", Colors.green),
                  categoryItem(
                      Icons.leaderboard, "Leaderboard", Colors.blueGrey),
                ],
              ),
              const SizedBox(height: 20),

              // Courses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Courses",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All",
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ],
              ),

              // FutureBuilder to load courses
              FutureBuilder<List<Course>>(
                future: courseService.fetchCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Failed to load courses"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No courses available"));
                  } else {
                    final courses = snapshot.data!;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: courses
                          .map((course) => courseItem(context, course))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Helper Widget for Category Item
  Widget categoryItem(IconData icon, String label, Color backgroundColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // Helper Widget for Course Item
  Widget courseItem(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: course),
          ),
        );
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                course.imageUrl,
                fit: BoxFit.cover,
                height: 90,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    height: 90,
                    width: double.infinity,
                    child: const Center(child: Text("Image not available")),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              course.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              "${course.videoCount} Videos",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(
              "by ${course.author}",
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
