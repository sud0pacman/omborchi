part of 'sync_bloc.dart';

class SyncState {
  final bool isLoading; // for shimmer effect
  final bool isSuccess; // for empty state

  SyncState({
    required this.isLoading,
    required this.isSuccess,
  });

  SyncState copyWith({
    bool? isLoading,
    bool? isSuccess,
  }) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
