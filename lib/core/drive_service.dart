
import 'app_config.dart';

class DriveService {
  const DriveService();

  Future<String?> fetchFileById(String fileId) async {
    if (AppConfig.safeMode) return null;
    // TODO: real fetch when online is enabled
    return null;
  }
}
