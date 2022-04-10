import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'location_record.g.dart';

abstract class LocationRecord
    implements Built<LocationRecord, LocationRecordBuilder> {
  static Serializer<LocationRecord> get serializer =>
      _$locationRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'Home')
  LatLng get home;

  @nullable
  @BuiltValueField(wireName: 'Name')
  String get name;

  @nullable
  DocumentReference get user;

  @nullable
  @BuiltValueField(wireName: 'Description')
  String get description;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(LocationRecordBuilder builder) => builder
    ..name = ''
    ..description = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Location');

  static Stream<LocationRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<LocationRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  LocationRecord._();
  factory LocationRecord([void Function(LocationRecordBuilder) updates]) =
      _$LocationRecord;

  static LocationRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createLocationRecordData({
  LatLng home,
  String name,
  DocumentReference user,
  String description,
}) =>
    serializers.toFirestore(
        LocationRecord.serializer,
        LocationRecord((l) => l
          ..home = home
          ..name = name
          ..user = user
          ..description = description));
