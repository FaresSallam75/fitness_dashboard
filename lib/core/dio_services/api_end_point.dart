abstract class ApiEndPoints {
  // static const String vegetablesData =
  //     'https://redsoftware.notion.site/Vegetable-JSON-7db18acfc4414978a65773b2c41a379f';

  static const String basicUrl =
      "http://localhost/fitness"; //http://192.168.1.5/fitness
  // static const String uploadUrl = "http://10.0.2.2/fitness/upload";
  static const String login = "$basicUrl/admin/auth/login.php";

  // search  --   users
  static const String searchUsers = "$basicUrl/admin/users/search.php";
  static const String viewUsers = "$basicUrl/admin/users/view.php";
  static const String countUsers = "$basicUrl/admin/users/count.php";
  static const String addPayment = "$basicUrl/admin/payment/add.php";
  static const String viewPayment = "$basicUrl/admin/payment/view.php";
  static const String viewTotalPrice = "$basicUrl/admin/payment/total.php";

  // coaches
  static const String viewCoaches = "$basicUrl/admin/coaches/view.php";
  static const String addCoaches = "$basicUrl/admin/coaches/add.php";
  static const String countCoaches = "$basicUrl/admin/coaches/count.php";

  // exports
  static const String addExports = "$basicUrl/admin/export/add.php";
  static const String viewExports = "$basicUrl/admin/export/view.php";
  static const String viewExportsTotalPrice =
      "$basicUrl/admin/export/total.php";

  // offers
  static const String addOffer = "$basicUrl/admin/offers/add.php";
  static const String viewOffer = "$basicUrl/admin/offers/view.php";
}
