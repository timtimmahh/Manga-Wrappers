import 'dart:convert';
import 'dart:math';

abstract class JsonValue<T, V> {
  final T _value;

  const JsonValue(this._value);

  static JsonValue fromJson(String json) => asJsonValue(jsonDecode(json));

  static JsonValue asJsonValue(dynamic value) {
    if (value == null) {
      return JsonNull(value);
    } else if (value is num) {
      return JsonNum(value);
    } else if (value is bool) {
      return JsonBool(value);
    } else if (value is List) {
      return JsonArray.create(value);
    } else if (value is Map) {
      return JsonObject.create(value);
    }
    return JsonString(value is String ? value : value.toString());
  }

  V get value;

  @override
  Type get runtimeType => value.runtimeType;

  @override
  dynamic noSuchMethod(Invocation invocation) => value.noSuchMethod(invocation);

  @override
  String toString() => value.toString();

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => value == other;
}

class JsonPrimitive<T> extends JsonValue<T, T> {
  const JsonPrimitive(T value) : super(value);

  @override
  T get value => _value;
}

class JsonNull<T> extends JsonPrimitive<T?> {
  const JsonNull(T? value) : super(value);
}

class JsonString extends JsonPrimitive<String> {
  const JsonString(String value) : super(value);
}

class JsonNum extends JsonPrimitive<num> {
  const JsonNum(num value) : super(value);
}

class JsonBool extends JsonPrimitive<bool> {
  JsonBool(bool value) : super(value);
}

class JsonArray extends JsonValue<List<JsonValue>, List<dynamic>>
    implements List {
  const JsonArray(List<JsonValue> value) : super(value);

  JsonArray.create(Iterable<dynamic> value)
      : super(value.map((e) => JsonValue.asJsonValue(e)).toList());

  @override
  List<dynamic> get value => _value.map((e) => e.value).toList();

  dynamic operator [](int index) => _value[index].value;

  @override
  Map<int, dynamic> asMap() => value.asMap();

  @override
  void replaceRange(int start, int end, Iterable<dynamic> replacements) =>
      value.replaceRange(start, end, replacements);

  @override
  void fillRange(int start, int end, [dynamic fillValue]) {
    value.fillRange(start, end, fillValue);
  }

  @override
  void removeRange(int start, int end) {
    value.removeRange(start, end);
  }

  @override
  void setRange(int start, int end, Iterable<dynamic> iterable,
      [int skipCount = 0]) {
    value.setRange(start, end, iterable, skipCount);
  }

  @override
  Iterable<dynamic> getRange(int start, int end) => value.getRange(start, end);

  @override
  List<dynamic> sublist(int start, [int? end]) => value.sublist(start, end);

  @override
  List<dynamic> operator +(List<dynamic> other) => value + other;

  @override
  void retainWhere(bool test(dynamic element)) {
    value.retainWhere(test);
  }

  @override
  void removeWhere(bool test(dynamic element)) {
    value.removeWhere(test);
  }

  @override
  dynamic removeLast() => value.removeLast();

  @override
  dynamic removeAt(int index) => value.removeAt(index);

  @override
  bool remove(Object? value) => this.value.remove(value);

  @override
  void setAll(int index, Iterable<dynamic> iterable) {
    value.setAll(index, iterable);
  }

  @override
  void insertAll(int index, Iterable<dynamic> iterable) {
    value.insertAll(index, iterable);
  }

  @override
  void insert(int index, dynamic element) {
    value.insert(index, element);
  }

  @override
  void clear() => value.clear();

  @override
  int lastIndexOf(dynamic element, [int? start]) =>
      value.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool test(dynamic element), [int? start]) =>
      value.lastIndexWhere(test, start);

  @override
  int indexWhere(bool test(dynamic element), [int start = 0]) =>
      value.indexWhere(test, start);

  @override
  int indexOf(dynamic element, [int start = 0]) =>
      value.indexOf(element, start);

  @override
  void shuffle([Random? random]) => value.shuffle(random);

  @override
  void sort([int compare(dynamic a, dynamic b)?]) {
    value.sort(compare);
  }

  @override
  Iterable<dynamic> get reversed => value.reversed;

  @override
  void addAll(Iterable<dynamic> iterable) {
    value.addAll(iterable);
  }

  @override
  void add(dynamic value) {
    value.add(value);
  }

  @override
  set length(int newLength) {
    value.length = newLength;
  }

  @override
  int get length => value.length;

  @override
  set last(dynamic value) {
    this.value.last(value);
  }

  @override
  set first(dynamic value) {
    this.value.first(value);
  }

  @override
  void operator []=(int index, dynamic value) {
    this.value[index] = value;
  }

  @override
  List<R> cast<R>() => value.cast();
}

class JsonObject
    extends JsonValue<Map<JsonString, JsonValue>, Map<dynamic, dynamic>>
    implements Map {
  const JsonObject(Map<JsonString, JsonValue> value) : super(value);

  JsonObject.create(Map<dynamic, dynamic> value)
      : super(value.map((key, value) => MapEntry(
            JsonString(key is String ? key : key.toString()),
            JsonValue.asJsonValue(value))));

  @override
  Map<dynamic, dynamic> get value =>
      _value.map((key, value) => MapEntry(key.value, value.value));

  dynamic operator [](Object? key) => _value[key]?.value;

  R? call<R>(Iterable<String> keys) =>
      _convert(this[keys.first]?.let((it) => keys.length <= 1
          ? it
          : (it is JsonObject ? it.call(keys.skip(1)) : null)));

  R? _convert<R, V>(V? value) => value is JsonPrimitive ? value.value : value;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  int get length => value.length;

  @override
  Iterable<dynamic> get values => value.values;

  @override
  Iterable<dynamic> get keys => value.keys;

  @override
  void forEach(void action(dynamic key, dynamic value)) {
    value.forEach(action);
  }

  @override
  void clear() {
    value.clear();
  }

  @override
  dynamic remove(Object? key) => value.remove(key);

  @override
  void addAll(Map<dynamic, dynamic> other) {
    value.addAll(other);
  }

  @override
  dynamic putIfAbsent(dynamic key, dynamic ifAbsent()) =>
      value.putIfAbsent(key, () => null);

  @override
  void removeWhere(bool test(dynamic key, dynamic value)) {
    value.removeWhere(test);
  }

  @override
  void updateAll(dynamic update(dynamic key, dynamic value)) {
    value.updateAll(update);
  }

  @override
  dynamic update(dynamic key, dynamic update(dynamic value),
          {dynamic ifAbsent()?}) =>
      value.update(key, update, ifAbsent: ifAbsent);

  @override
  void addEntries(Iterable<MapEntry<dynamic, dynamic>> newEntries) {
    value.addEntries(newEntries);
  }

  @override
  Map<K2, V2> map<K2, V2>(
          MapEntry<K2, V2> convert(dynamic key, dynamic value)) =>
      value.map<K2, V2>(convert);

  @override
  Iterable<MapEntry<dynamic, dynamic>> get entries => value.entries;

  @override
  void operator []=(dynamic key, dynamic value) {
    this.value[key] = value;
  }

  @override
  bool containsKey(Object? key) => value.containsKey(key);

  @override
  bool containsValue(Object? value) => this.value.containsValue(value);

  @override
  Map<RK, RV> cast<RK, RV>() => value.cast<RK, RV>();
}
