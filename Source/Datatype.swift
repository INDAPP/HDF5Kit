// Copyright © 2015 Venture Media Labs. All rights reserved.
//
// This file is part of HDF5Kit. The full HDF5Kit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

public enum DataClass: Int32 {
    case NoClass   = -1  // error
    case Integer   = 0   // integer types
    case Float     = 1   // floating-point types
    case Time      = 2   // date and time types
    case String    = 3   // character string types
    case BitField  = 4   // bit field types
    case Opaque    = 5   // opaque types
    case Compound  = 6   // compound types
    case Reference = 7   // reference types
    case Enum      = 8	 // enumeration types
    case VarLength = 9	 // Variable-Length types
    case Array     = 10	 // Array types
}


public class Datatype : Object {
    /// Create a Datatype from a class and a size
    public class func create(dataClass: DataClass, size: Int) -> Datatype {
        let id = H5Tcreate(H5T_class_t(dataClass.rawValue), size)
        guard id >= 0 else {
            fatalError("Failed to create Datatype")
        }
        return Datatype(id: id)
    }

    /// Copies an existing Datatype from a native type
    public class func copy(type type: NativeType) -> Datatype {
        let id = H5Tcopy(type.rawValue)
        return Datatype(id: id)
    }

    public class func createDouble() -> Datatype {
        return copy(type: .Double)
    }

    public class func createInt() -> Datatype {
        return copy(type: .Int)
    }

    public class func createString() -> Datatype {
        let id = H5Tcopy(H5T_C_S1_g)
        H5Tset_size(id, -1)
        return Datatype(id: id)
    }

    public var `class`: DataClass {
        return DataClass(rawValue: H5Tget_class(id).rawValue)!
    }

    public var nativeType: NativeType? {
        let tid = H5Tget_native_type(id, H5T_DIR_ASCEND)
        defer {
            H5Tclose(tid)
        }

        switch (tid) {
        case NativeType.Int.rawValue: return .Int
        case NativeType.UInt.rawValue: return .UInt
        case NativeType.Float.rawValue: return .Float
        case NativeType.Double.rawValue: return .Double
        case NativeType.Int8.rawValue: return .Int8
        case NativeType.UInt8.rawValue: return .UInt8
        case NativeType.Int16.rawValue: return .Int16
        case NativeType.UInt16.rawValue: return .UInt16
        case NativeType.Int32.rawValue: return .Int32
        case NativeType.UInt32.rawValue: return .UInt32
        case NativeType.Int64.rawValue: return .Int64
        case NativeType.UInt64.rawValue: return .UInt64
        case NativeType.Opaque.rawValue: return .Opaque
        default: return nil
        }
    }

    public enum Order: Int32 {
        case Error        = -1
        case LittleEndian = 0
        case BigEndian    = 1
        case Vax          = 2
        case Mixed        = 3
        case Nonde        = 4
    }

    /// The byte order of the Datatype
    public var order: Order {
        get {
            return Order(rawValue: H5Tget_order(id).rawValue)!
        }
        set {
            H5Tset_order(id, H5T_order_t(newValue.rawValue))
        }
    }
}
