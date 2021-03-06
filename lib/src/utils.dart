part of binary_types;

class _Utils {
  static int alignOffset(int offset, int align) {
    var remainder = offset % align;
    if (remainder != 0) {
      offset -= remainder;
      offset += align;
    }

    return offset;
  }

  static checkPowerOfTwo(int value, String name) {
    if (value != null) {
      var powerOf2 = (value != 0) && ((value & (value - 1)) == 0);
      if (!powerOf2) {
        throw new ArgumentError("The '$name' ($value) should be power of 2 value.");
      }
    }
  }

  static int getMemberAlignment(BinaryType type, int align, bool packed) {
    if (align != null) {
      return align;
    } else if (packed) {
      return 1;
    } else {
      return type.align;
    }
  }

  static String toHex(int value, [int size]) {
    if (value == null) {
      value = 0;
    }

    if (size == null || size <= 0) {
      size = 8;
    }

    if (value < 0) {
      var max = 1;
      for (var i = 0; i < size; i++) {
        max <<= 8;
      }

      value &= (max - 1);
    }

    var result = value.toRadixString(16);
    var length = result.length;
    var rest = size * 2 - length;
    if (rest > 0) {
      result = new List<String>.filled(rest, "0").join() + result;
    }

    return "0x" + result;
  }

  static int toUnsigned(int value, int bitness) {
    var umax = (1 << bitness) - 1;
    if (value >= 0) {
      value &= umax;
    } else {
      var smax = umax ~/ 2;
      var smin = -(smax + 1);
      if (value >= smin) {
        value = umax + value + 1;
      } else {
        value = -(value) & umax;
        value = (umax - value + 1) & umax;
      }
    }

    return value;
  }
}
