import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:object_detection/modules/volunteer/data/firebase/user_firebase.dart';
import 'package:object_detection/modules/volunteer/ui/volunteer_request/cubit/cubit.dart';
import 'package:object_detection/shared/constants.dart';
import '../../../../models/UserLocation.dart';
import '../../../../models/Request.dart';
import '../../../../models/User.dart';

class LocationApi {
  static loc.Location _location = new loc.Location();

  static late VolunteerRequestCubit myCubit;

  static Future<void> sendRealTimeLocationUpdates(
      VolunteerRequestCubit cubit) async {
    if (await _checkServiceAvailability() && await _checkLocationPermission()) {
      myCubit = cubit;

      // listen on location change every 3 minutes

      _listenOnLocationChange();
      // showToast('Request is sent successfully');
    }
    myCubit = cubit;
  }



  static Future<bool> _checkServiceAvailability() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }
    return _serviceEnabled;
  }


   static Future<bool> _checkLocationPermission() async {
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }
    return _permissionGranted == PermissionStatus.granted;
  }

  static StreamSubscription<loc.LocationData>? _locationSubsrcibtion;

  static void _listenOnLocationChange() async {
    /* await _location.changeSettings(distanceFilter: 10);
    _locationSubsrcibtion = _location.onLocationChanged.handleError((onError) {
      _locationSubsrcibtion!.cancel();
      _locationSubsrcibtion = null;
    }).listen((locationData) async {
      await _updateUserLocation(locationData.latitude, locationData.longitude);
    });*/

  }

  static Request? request;

  static _updateRequestObj(double latitude, double longitude) async {
    UserModel userModel = await getCurrentUser();
    if (request == null)
      request = Request(
          blindData: userModel,
          blindLocation: UserLocation(latitude, longitude),
          date: Timestamp.now());
    else {
      request!.blindLocation.latitude = latitude;
      request!.blindLocation.longitude = longitude;
    }
  }

  static Future<void> _updateUserLocation(
      double? latitude, double? longitude) async {
    _updateRequestObj(latitude!, longitude!);
    try {
      await UserFirebase.setRequestForAllVolunteers(request!, myCubit);
      //requestState = RequestSucceeded();
    } catch (e) {
      print(e.toString());
    }
  }
}
