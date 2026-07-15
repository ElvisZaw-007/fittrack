// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deepLinkService)
final deepLinkServiceProvider = DeepLinkServiceProvider._();

final class DeepLinkServiceProvider
    extends
        $FunctionalProvider<DeepLinkService, DeepLinkService, DeepLinkService>
    with $Provider<DeepLinkService> {
  DeepLinkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepLinkServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepLinkServiceHash();

  @$internal
  @override
  $ProviderElement<DeepLinkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeepLinkService create(Ref ref) {
    return deepLinkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkService>(value),
    );
  }
}

String _$deepLinkServiceHash() => r'763cf87ddee73db11d4d36a52de098bdb5c39049';
