// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myflutter_app/services/auth_service.dart';
import 'package:myflutter_app/service_locator.dart';
import 'package:myflutter_app/providers/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showFullScreenImage(BuildContext context, Map<String, dynamic> image) {
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
    final provider = Provider.of<HomeProvider>(context);

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
      body: _buildBody(context, provider),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.refreshImages,
        child:
            provider.isRefreshing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.loadImages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshImages,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: provider.images.length,
        itemBuilder: (context, index) {
          final image = provider.images[index];
          return GestureDetector(
            onTap: () => _showFullScreenImage(context, image),
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
