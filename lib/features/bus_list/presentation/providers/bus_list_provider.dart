import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:bus_ticket_booking_system/features/bus_list/data/datasources/remote/bus_list_remote_datasource.dart";
import "package:bus_ticket_booking_system/features/bus_list/data/models/bus_model.dart";

class BusRouteArgs {
  final String from;
  final String to;
  const BusRouteArgs({required this.from, required this.to});

  @override
  bool operator ==(Object other) =>
      other is BusRouteArgs && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

final busListDataSourceProvider = Provider<BusListRemoteDataSource>(
  (ref) => BusListRemoteDataSource(),
);

final busListProvider =
    FutureProvider.family<List<BusModel>, BusRouteArgs>((ref, args) async {
  final ds = ref.watch(busListDataSourceProvider);
  return ds.getBuses(from: args.from, to: args.to);
});
