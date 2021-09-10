import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/download_zip.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/unzip_files.dart';

class SetUpCMS {
  final String themeURL;
  final String cmsURL;
  final String name;
  final String folderName;

  SetUpCMS({
    required this.themeURL,
    required this.cmsURL,
    required this.name,
    required this.folderName,
  });

  Future<void> init() async {
    final Downloader theme = Downloader(
        url: themeURL, dir: PathHelper.getThemeDir, name: '$name.zip');
    await theme.download((_) {
      print('done downloading theme');
    });
    final Downloader cms =
        Downloader(url: cmsURL, dir: PathHelper.getCMSDIR, name: '$name.zip');
    await cms.download((_) {
      print('done downloading cms');
    });

    final String themeZip = p.join(PathHelper.getThemeDir, '$name.zip');
    final String cmZip = p.join(PathHelper.getCMSDIR, '$name.zip');
    final String cmsPath = p.join(PathHelper.getSitesDIR, folderName, 'cms');
    final String themePath = p.join(PathHelper.getSitesDIR, folderName);

    final UnzipFile themeSetUp = UnzipFile(themeZip, themePath);
    final UnzipFile cmsSetUp = UnzipFile(cmZip, cmsPath);

    await themeSetUp.unzip((_) {
      print('Done Extracting Theme');
    });

    await cmsSetUp.unzip((_) {
      print('Done Extracting CMS');
    });
  }
}
