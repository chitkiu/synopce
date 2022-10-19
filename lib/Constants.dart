import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:dsm_sdk/dsm_sdk.dart';

DsmSdk sdk = DsmSdk(ConnectionInfo(
    Uri(scheme: 'http', host: '192.168.1.121', port: 5000),
    "demon",
    "ks16agagOtotot55!"));
