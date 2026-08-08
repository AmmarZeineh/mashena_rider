final class AppPagination {
  const AppPagination._();

  /// Scroll distance threshold in pixels before reaching list end to trigger loading next page.
  static const double loadMoreThreshold = 200.0;

  /// Default number of items per page for paginated API requests.
  static const int defaultPageSize = 10;
}
