import 'package:logger/logger.dart';

class AppRes {
  static final logger = Logger();
}

class ExpenseFields {
  static const String employeeTable = 'employee';
  static const String categoryTable = 'category';
  static const String productTable = 'product';
  static const String productPriceTable = 'tannarx';
  static const String rawMaterialTypeTable = 'types';
  static const String rawMaterialTable = 'xomashyo';
  static const String adminKeyTable = 'admin';
  static const String productImageBucket = 'product_images';
}

class AppSecrets {
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1ZnJmeHJjcHZhd3J2aHhvYmNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU2ODk2MDcsImV4cCI6MjA0MTI2NTYwN30.fet0Fb3QekY4Q-zcDvM3yo7cIMjFygECy7fgfAO39ac";

  static const String supabaseUrl = "https://vufrfxrcpvawrvhxobcp.supabase.co";
}

class AssetRes {
  static const _base = 'assets/icons/';
  static const icBack = '${_base}left.png';
  static const icSearch = '${_base}ic_search.svg';
  static const icLogout = '${_base}ic_logout.svg';
  static const icFolder = '${_base}folder.png';
  static const icAppLogo = '${_base}logo.png';
  static const icInactive = '${_base}ic_inactive.svg';
}
