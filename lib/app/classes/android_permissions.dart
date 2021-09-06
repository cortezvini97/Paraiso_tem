import 'package:permission_handler/permission_handler.dart';

class AndroidPermissions
{
  void requestPermission() async
  {
    PermissionStatus phone = await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);
    PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (phone != PermissionStatus.granted)
    {
      await PermissionHandler().requestPermissions([PermissionGroup.phone]);
    }
    if (camera != PermissionStatus.granted)
    {
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    }
    if (storage != PermissionStatus.granted)
    {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
  }
}