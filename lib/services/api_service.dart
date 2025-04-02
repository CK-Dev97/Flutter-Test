import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'GXOhu8ekhipk5wMBXaYQZK44MdX5FBSECjJzaK8aArU';
  static const String _baseUrl = 'https://api.unsplash.com';

  Future<List<dynamic>> fetchImages() async {
    try {
      // First fetch the list of images
      final response = await http.get(
        Uri.parse('$_baseUrl/photos?per_page=20&client_id=$_apiKey'),
        headers: {'Accept-Version': 'v1'},
      );

      if (response.statusCode == 200) {
        List<dynamic> images = json.decode(response.body);

        // For each image, fetch its statistics
        for (var image in images) {
          try {
            final statsResponse = await http.get(
              Uri.parse(
                '$_baseUrl/photos/${image['id']}/statistics?client_id=$_apiKey',
              ),
              headers: {'Accept-Version': 'v1'},
            );

            if (statsResponse.statusCode == 200) {
              var stats = json.decode(statsResponse.body);
              image['views'] = stats['views']['total'];
              image['downloads'] = stats['downloads']['total'];
            }
          } catch (e) {
            // If stats fetch fails, set defaults
            image['views'] = 0;
            image['downloads'] = 0;
          }
        }

        return images;
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching images: $error');
    }
  }
}
