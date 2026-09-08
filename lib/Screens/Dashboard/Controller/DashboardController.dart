import 'package:get/get.dart';

class DashboardController extends GetxController {
  int selectedMenu = 0;

  // ── Pending Marketplace filter ────────────────────────────────────────
  // Set by other screens (e.g. the Home dashboard's marketplace search /
  // category chips) right before switching to the Market tab, so
  // MainDashboard can hand MarketScreen an initial search/category and it
  // fires the real API call with that filter already applied — instead of
  // navigating to a blank marketplace and making the user re-enter it.
  // MainDashboard consumes (and clears) these the moment it builds the tab.
  String? pendingMarketSearch;
  String? pendingMarketCategory;
  // Set when the tap that triggered navigation is the "filters" (tune) icon
  // — MarketScreen opens its own Filters bottom sheet as soon as it lands,
  // instead of just showing the marketplace behind it.
  bool pendingOpenMarketFilter = false;

  /// Switches to the Market tab (index 1), optionally pre-loading it with a
  /// search term and/or category filter, and optionally opening the
  /// Filters bottom sheet immediately.
  void goToMarket({
    String? search,
    String? category,
    bool openFilter = false,
  }) {
    pendingMarketSearch = search;
    pendingMarketCategory = category;
    pendingOpenMarketFilter = openFilter;
    selectedMenu = 1;
    update();
  }
}
