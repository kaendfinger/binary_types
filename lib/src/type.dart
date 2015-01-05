part of binary_types;

class BinaryKinds {
  static const BinaryKinds ARRAY = const BinaryKinds("ARRAY");

  static const BinaryKinds DOUBLE = const BinaryKinds("DOUBLE");

  static const BinaryKinds FLOAT = const BinaryKinds(" FLOAT");

  static const BinaryKinds FUNCTION = const BinaryKinds(" FUNCTION");

  static const BinaryKinds POINTER = const BinaryKinds(" POINTER");

  static const BinaryKinds SINT16 = const BinaryKinds(" SINT16");

  static const BinaryKinds SINT32 = const BinaryKinds(" SINT32");

  static const BinaryKinds SINT64 = const BinaryKinds(" SINT64");

  static const BinaryKinds SINT8 = const BinaryKinds(" SINT8");

  static const BinaryKinds STRUCT = const BinaryKinds(" STRUCT");

  static const BinaryKinds UINT16 = const BinaryKinds("UINT16");

  static const BinaryKinds UINT32 = const BinaryKinds(" UINT32");

  static const BinaryKinds UINT64 = const BinaryKinds("UINT64");

  static const BinaryKinds UINT8 = const BinaryKinds(" UINT8");

  static const BinaryKinds VA_LIST = const BinaryKinds(" VA_LIST");

  static const BinaryKinds VOID = const BinaryKinds("VOID");

  final String _name;

  const BinaryKinds(this._name);

  String toString() {
    return _name;
  }
}

abstract class BinaryType {
  static bool typeChecking = true;

  int _align;

  DataModel _dataModel;

  String _name;

  BinaryType(DataModel dataModel, {int align}) {
    if (dataModel == null) {
      throw new ArgumentError.notNull("dataModel");
    }

    if (align != null) {
      var powerOf2 = (align != 0) && ((align & (align - 1)) == 0);
      if (!powerOf2) {
        throw new ArgumentError("Align '$align' should be power of 2 value.");
      }
    }

    _align = align;
    _dataModel = dataModel;
  }

  /**
   * Returns the alignment in bytes, required for any instance of the type.
   */
  int get align => _align;

  /**
   * Returns the model of binary data.
   */
  DataModel get dataModel => _dataModel;

  /**
   * Returns the defualt value of binary data.
   */
  dynamic get defaultValue;

  /**
   * Returns the kind of binary type.
   */
  BinaryKinds get kind;

  /**
   * Returns the name of binary type.
   */
  String get name => _name;

  /**
   * Returns the amount of storage, in bytes, required to store any instance of
   * the type.
   */
  int get size;

  bool operator ==(other) => identical(this, other);

  /**
   * Allocates the memory for the instance of type and returns the data holder.
   *
   * Parameters:
   *   [dynamic] value
   *   Initial value for the filling.
   */
  BinaryObject alloc([value]) {
    return new BinaryObject._alloc(this, value);
  }

  /**
   * Returns the binary array type with specified size.
   *
   * Parameters:
   *   [int] size
   *   Size of array type.
   */
  BinaryType array(int size) {
    return new ArrayType(this, size, _dataModel);
  }

  /**
   * Convert the value in the value of this type.
   *
   * Parameters:
   *   [dynamic] value
   *   Value to convert.
   */
  dynamic cast(value) {
    return _cast(value);
  }

  /**
   * Clones the type.
   *
   * Parameters:
   *   [int] align
   *   Data alignment for this type.
   */
  BinaryType clone({int align}) {
    if (align == null) {
      align = this.align;
    }

    return _clone(align: align);
  }

  /**
   * Compares the content of this type, at the specified base and offset, with
   * the given value.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] value
   *   Value to compare.
   */
  bool compareContent(int base, int offset, value) {
    return _compareContent(base, offset, value);
  }

  /**
   * Creates and returns the binary data for this type at the specified memory
   * base and offset.
   * Does not allocates and does not frees memory.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   */
  BinaryData extern(int base, [int offset = 0]) {
    return new BinaryData._internal(this, base, offset);
  }

  /**
   * Returns the element of this type by the index, at the specified memory
   * base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] index
   *   Index of the element.
   */
  BinaryData getElement(int base, int offset, index) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    return _getElement(base, offset, index);
  }

  /**
   * Returns the value of the element of this type, by index, at the specified
   * memory base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] index
   *   Index of the element.
   */
  dynamic getElementValue(int base, int offset, index) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    return _getElementValue(base, offset, index);
  }

  /**
   * Returns the value of this type, at the specified memory base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   */
  dynamic getValue(int base, int offset) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    return _getValue(base, offset);
  }

  /**
   * Creates and returns the bogus binary object at NULL address.
   * Does not allocates and does not frees memory.
   *
   * Parameters:
   */
  BinaryObject nullObject() {
    return new BinaryObject._internal(this, 0, 0);
  }

  /**
   * Returns the offset of specified field in the structural type.
   *
   * Parameters:
   *   [String] member
   *   Name of the member.
   */
  int offsetOf(String member) {
    return _offsetOf(member);
  }

  /**
   * Returns the binary pointer type.
   *
   * Parameters:
   */
  BinaryType ptr() {
    return new PointerType(this, _dataModel);
  }

  /**
   * Sets the content of this type to specified value, at the specified memory
   * base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] value
   *   Value to set.
   */
  void setContent(int base, int offset, value) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    _setContent(base, offset, value);
  }

  /**
   * Sets the element of this type, by index, to specified value, at the
   * specified memory base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] index
   *   Index of the element.
   *
   *   [dynamic] value
   *   Value to set.
   */
  void setElement(int base, int offset, index, value) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    _setElement(base, offset, index, value);
  }

  /**
   * Sets the value of the element of this type, by index, to specified value,
   * at the specified memory base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *
   *   [dynamic] index
   *   Index of the element.
   *
   *   [dynamic] value
   *   Value to set.
   */
  void setElementValue(int base, int offset, index, value) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    _setElementValue(base, offset, index, value);
  }

  /**
   * Sets the value of this type to specified value, at the specified memory
   * base and offset.
   *
   * Parameters:
   *   [int] base
   *   Base part of the address.
   *
   *   [int] offset
   *   Offset part of the address.
   *    *
   *   [dynamic] value
   *   Value to set.
   */
  void setValue(int base, int offset, value) {
    if (base == null) {
      throw new ArgumentError("base: $base");
    }

    if (offset == null) {
      throw new ArgumentError("offset: $offset");
    }

    _setValue(base, offset, value);
  }

  /**
   * Returns the string representation.
   */
  String toString() => name;

  dynamic _cast(value) {
    BinaryTypeError.unablePerformingOperation(this, "cast", {
      "value": value
    });
    return null;
  }

  BinaryType _clone({int align});

  bool _compareContent(int base, int offset, value) {
    BinaryTypeError.unablePerformingOperation(this, "compare content", {
      "value": value
    });
    return null;
  }

  BinaryData _getElement(int base, int offset, index) {
    BinaryTypeError.unablePerformingOperation(this, "get element", {
      "index": index
    });
    return null;
  }

  dynamic _getElementValue(int base, int offset, index) {
    BinaryTypeError.unablePerformingOperation(this, "get element value", {
      "index": index
    });
    return null;
  }

  dynamic _getValue(int base, int offset) {
    BinaryTypeError.unablePerformingOperation(this, "get value");
    return null;
  }

  void _initialize(int base, int offset, value) {
    BinaryTypeError.unablePerformingOperation(this, "initialize", {
      "value": value
    });
  }

  int _offsetOf(String member) {
    BinaryTypeError.unablePerformingOperation(this, "offset of", {
      "member": member
    });

    return null;
  }

  void _setContent(int base, int offset, value) {
    BinaryTypeError.unablePerformingOperation(this, "set content", {
      "value": value
    });
  }

  void _setElement(int base, int offset, index, value) {
    BinaryTypeError.unablePerformingOperation(this, "set element", {
      "index": index,
      "value": value
    });
  }

  void _setElementValue(int base, int offset, index, value) {
    BinaryTypeError.unablePerformingOperation(this, "set element value", {
      "index": index,
      "value": value
    });
  }

  void _setValue(int base, int offset, value) {
    BinaryTypeError.unablePerformingOperation(this, "set value", {
      "value": value
    });
  }
}