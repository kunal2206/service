import '../../data/controllers/bottom_navigation_controller.dart';
import '../../data/controllers/gps_controller.dart';
import '../../data/controllers/auth_controller.dart';
import '../../data/controllers/socket_controller.dart';

AuthController authController = AuthController.instance;
GpsController locationController = GpsController.instance;
BottomNavigationController bottomNavigationController =
    BottomNavigationController.instance;
SocketController socketController = SocketController.instance;
