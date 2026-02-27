import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['package:core', 'package:shared'])
void initAuthFlowPackageModule(GetIt getIt) {}
