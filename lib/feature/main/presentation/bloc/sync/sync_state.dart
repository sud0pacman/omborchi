part of 'sync_bloc.dart';

class SyncState {
  final bool isLoading; // for shimmer effect
  final bool isSuccess; // for empty state
  final double? syncProgress; // Sync progress percentage
  final String? currentRepository; // Name of the repository being synced
  final String? error; // Name of the repository being synced
  final int? currentRepositoryIndex; // Order of the repository being synced

  SyncState({
    required this.isLoading,
    required this.isSuccess,
    required this.syncProgress,
    required this.currentRepository,
    required this.error,
    required this.currentRepositoryIndex,
  });

  SyncState copyWith({
    bool? isLoading,
    bool? isSuccess,
    double? syncProgress,
    String? currentRepository,
    String? error,
    int? currentRepositoryIndex,
  }) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      syncProgress: syncProgress ?? this.syncProgress,
      currentRepository: currentRepository ?? this.currentRepository,
      error: error ?? this.error,
      currentRepositoryIndex:
          currentRepositoryIndex ?? this.currentRepositoryIndex,
    );
  }
}
