part of models;

class YTColorAdapter extends TypeAdapter<YTColor> {
  @override
  int get typeId => _HiveTypeIds.ytcolor;

  @override
  YTColor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YTColor(
      backgroundColor: fields[0] as Color,
      foregroundColor: fields[1] as Color,
      lightColor: fields[2] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, YTColor obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.backgroundColor)
      ..writeByte(1)
      ..write(obj.foregroundColor)
      ..writeByte(2)
      ..write(obj.lightColor);
  }
}
