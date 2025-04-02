// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:myflutter_app/services/auth_service.dart';
import 'package:myflutter_app/service_locator.dart';
import 'package:myflutter_app/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiService = locator<ApiService>();
  List<dynamic> _images = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final images = await _apiService.fetchImages();
      setState(() {
        _images = images;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshImages() async {
    setState(() => _isRefreshing = true);
    await _loadImages();
  }

  void _showFullScreenImage(Map<String, dynamic> image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text(image['description']?.toString() ?? 'Wallpaper'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // Implement download functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading ${image['id']}')),
                      );
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: image['urls']['full'],
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (image['description'] != null)
                            Text(
                              image['description'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            "By ${image['user']['name'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                Icons.visibility,
                                '${image['views']}',
                              ),
                              _buildStatItem(
                                Icons.favorite,
                                '${image['likes']}',
                              ),
                              _buildStatItem(
                                Icons.download,
                                '${image['downloads']}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Additional Details
                          if (image['alt_description'] != null) ...[
                            Text(
                              image['alt_description'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (image['exif'] != null) ...[
                            const Divider(),
                            const Text(
                              'Camera Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Model: ${image['exif']['model'] ?? 'Unknown'}',
                            ),
                            Text(
                              'Aperture: f/${image['exif']['aperture'] ?? ''}',
                            ),
                            Text('ISO: ${image['exif']['iso'] ?? ''}'),
                            Text(
                              'Focal Length: ${image['exif']['focal_length'] ?? ''}mm',
                            ),
                          ],
                          const SizedBox(height: 16),
                          // Tags
                          if (image['tags'] != null &&
                              image['tags'].isNotEmpty) ...[
                            const Divider(),
                            const Text(
                              'Tags',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children:
                                  image['tags']
                                      .map<Widget>(
                                        (tag) => Chip(
                                          label: Text(tag['title']),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creative Wallpapers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              locator<AuthService>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshImages,
        child:
            _isRefreshing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loadImages, child: const Text('Retry')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshImages,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          return GestureDetector(
            onTap: () => _showFullScreenImage(image),
            child: _buildImageCard(image),
          );
        },
      ),
    );
  }

  Widget _buildImageCard(Map<String, dynamic> image) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: image['urls']['regular'],
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${image['likes']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image['description']?.toString() ?? 'Wallpaper',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "By ${image['user']['name'] ?? 'Unknown'}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.visibility, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${image['views']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(Icons.download, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${image['downloads']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
