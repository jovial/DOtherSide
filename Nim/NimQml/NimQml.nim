import NimQmlTypes
import tables

## NimQml aims to provide binding to the QML for the Nim programming language

export QObject
export QApplication
export QVariant
export QQmlApplicationEngine
export QQmlContext

type QMetaType* {.pure.} = enum ## \
  ## Qt metatypes values used for specifing the 
  ## signals and slots argument and return types.
  ##
  ## This enum mimic the QMetaType::Type C++ enum
  UnknownType = cint(0), 
  Bool = cint(1),
  Int = cint(2), 
  QString = cint(10), 
  VoidStar = cint(31),
  QVariant = cint(41), 
  Void = cint(43)

proc debugMsg(message: string) = 
  echo "NimQml: ", message

proc debugMsg(typeName: string, procName: string) = 
  var message = typeName
  message &= ": "
  message &= procName
  debugMsg(message)

proc debugMsg(typeName: string, procName: string, userMessage: string) = 
  var message = typeName
  message &= ": "
  message &= procName
  message &= " "
  message &= userMessage
  debugMsg(message)

# QVariant
proc dos_qvariant_create(variant: var pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_create_int(variant: var pointer, value: cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_create_bool(variant: var pointer, value: bool) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_create_string(variant: var pointer, value: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_create_qobject(variant: var pointer, value: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_delete(variant: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_isnull(variant: pointer, isNull: var bool) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_toInt(variant: pointer, value: var cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_toBool(variant: pointer, value: var bool) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_toString(variant: pointer, value: var cstring, length: var cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_setInt(variant: pointer, value: cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_setBool(variant: pointer, value: bool) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qvariant_setString(variant: pointer, value: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_chararray_delete(rawCString: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}

proc create*(variant: var QVariant) =
  ## Create a new QVariant
  var data: pointer
  dos_qvariant_create(data)
  variant = QVariant(data)

proc create*(variant: var QVariant, value: cint) = 
  ## Create a new QVariant given a cint value
  var data: pointer
  dos_qvariant_create_int(data, value)
  variant = QVariant(data)

proc create*(variant: var QVariant, value: bool) =
  ## Create a new QVariant given a bool value  
  var data: pointer
  dos_qvariant_create_bool(data, value)
  variant = QVariant(data)

proc create*(variant: var QVariant, value: string) = 
  ## Create a new QVariant given a string value
  var data: pointer
  dos_qvariant_create_string(data, value)
  variant = QVariant(data)

proc create*(variant: var QVariant, value: QObject) =
  ## Create a new QVariant given a QObject
  var data: pointer
  dos_qvariant_create_qobject(data, value.data)
  variant = QVariant(data)

proc delete*(variant: QVariant) = 
  ## Delete a QVariant
  debugMsg("QVariant", "delete")
  dos_qvariant_delete(pointer(variant))

proc isNull*(variant: QVariant): bool = 
  ## Return true if the QVariant value is null, false otherwise
  dos_qvariant_isnull(pointer(variant), result)

proc intVal*(variant: QVariant): int = 
  ## Return the QVariant value as int
  var rawValue: cint
  dos_qvariant_toInt(pointer(variant), rawValue)
  result = cast[int](rawValue)

proc `intVal=`*(variant: QVariant, value: int) = 
  ## Sets the QVariant value int value
  var rawValue = cast[cint](value)
  dos_qvariant_setInt(pointer(variant), rawValue)

proc boolVal*(variant: QVariant): bool = 
  ## Return the QVariant value as bool
  dos_qvariant_toBool(pointer(variant), result)

proc `boolVal=`*(variant: QVariant, value: bool) =
  ## Sets the QVariant bool value
  dos_qvariant_setBool(pointer(variant), value)

proc stringVal*(variant: QVariant): string = 
  ## Return the QVariant value as string
  var rawCString: cstring
  var rawCStringLength: cint
  dos_qvariant_toString(pointer(variant), rawCString, rawCStringLength)
  result = $rawCString
  dos_chararray_delete(rawCString)

proc `stringVal=`*(variant: QVariant, value: string) = 
  ## Sets the QVariant string value
  dos_qvariant_setString(pointer(variant), value)


# QQmlApplicationEngine
proc dos_qqmlapplicationengine_create(engine: var pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qqmlapplicationengine_load(engine: pointer, filename: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qqmlapplicationengine_context(engine: pointer, context: var pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qqmlapplicationengine_delete(engine: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}

proc create*(engine: var QQmlApplicationEngine) = 
  ## Create an new QQmlApplicationEngine
  var temp: pointer
  dos_qqmlapplicationengine_create(temp)
  engine = QQmlApplicationEngine(temp)

proc load*(engine: QQmlApplicationEngine, filename: cstring) = 
  ## Load the given Qml file 
  dos_qqmlapplicationengine_load(pointer(engine), filename)

proc rootContext*(engine: QQmlApplicationEngine): QQmlContext =
  ## Return the engine root context
  var context: pointer
  dos_qqmlapplicationengine_context(pointer(engine), context)
  result = cast[QQmlContext](context)

proc delete*(engine: QQmlApplicationEngine) = 
  ## Delete the given QQmlApplicationEngine
  debugMsg("QQmlApplicationEngine", "delete")
  dos_qqmlapplicationengine_delete(pointer(engine))

# QQmlContext
proc dos_qqmlcontext_setcontextproperty(context: pointer, propertyName: cstring, propertyValue: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}

proc setContextProperty*(context: QQmlContext, propertyName: string, propertyValue: QVariant) = 
  ## Sets a new property with the given value
  dos_qqmlcontext_setcontextproperty(pointer(context), propertyName, pointer(propertyValue))

# QApplication
proc dos_qguiapplication_create() {.cdecl, dynlib: "libDOtherSide.so", importc.}
proc dos_qguiapplication_exec() {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qguiapplication_delete() {.cdecl, dynlib:"libDOtherSide.so", importc.}

proc create*(application: QApplication) = 
  ## Create a new QApplication
  dos_qguiapplication_create()

proc exec*(application: QApplication) =
  ## Start the Qt event loop
  dos_qguiapplication_exec()

proc delete*(application: QApplication) = 
  ## Delete the given QApplication
  dos_qguiapplication_delete()

# QObject
type QVariantArray {.unchecked.} = array[0..0, QVariant]
type QVariantArrayPtr = ptr QVariantArray

proc toVariantSeq(args: QVariantArrayPtr, numArgs: cint): seq[QVariant] =
  result = @[]
  for i in 0..numArgs-1:
    result.add(args[i])

proc toCIntSeq(metaTypes: openarray[QMetaType]): seq[cint] =
  result = @[]
  for metaType in metaTypes:
    result.add(cint(metaType))
    
proc dos_qobject_create(qobject: var pointer, nimobject: pointer, qobjectCallback: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qobject_delete(qobject: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qobject_slot_create(qobject: pointer, slotName: cstring, argumentsCount: cint, argumentsMetaTypes: ptr cint, slotIndex: var cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qobject_signal_create(qobject: pointer, signalName: cstring, argumentsCount: cint, argumentsMetaTypes: ptr cint, signalIndex: var cint) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qobject_signal_emit(qobject: pointer, signalName: cstring, argumentsCount: cint, arguments: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qobject_property_create(qobject: pointer, propertyName: cstring, propertyType: cint, readSlot: cstring, writeSlot: cstring, notifySignal: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}

method onSlotCalled*(nimobject: QObject, slotName: string, args: openarray[QVariant]) =
  ## Called from the NimQml bridge when a slot is called from Qml.
  ## Subclasses can override the given method for handling the slot call
  discard()

proc qobjectCallback(nimobject: pointer, slotName: QVariant, numArguments: cint, arguments: QVariantArrayPtr) {.exportc.} =
  var nimQObjectCasted = cast[ptr QObject](nimobject)
  # forward to the QObject subtype instance
  nimQObjectCasted[].onSlotCalled(slotName.stringVal, arguments.toVariantSeq(numArguments))

proc create*(qobject: var QObject) =
  ## Create a new QObject
  qobject.name = "QObject"
  qobject.slots = initTable[string,cint]()
  qobject.signals = initTable[string, cint]()
  dos_qobject_create(qobject.data, addr(qobject), qobjectCallback)

proc delete*(qobject: QObject) = 
  ## Delete the given QObject
  dos_qobject_delete(qobject.data)

proc registerSlot*(qobject: var QObject, 
                   slotName: string, 
                   metaTypes: openarray[QMetaType]) =
  ## Register a slot in the QObject with the given name and signature
  # Copy the metatypes array
  var copy = toCIntSeq(metatypes)
  var index: cint 
  dos_qobject_slot_create(qobject.data, slotName, cint(copy.len), cast[ptr cint](addr(copy[0])), index)
  qobject.slots[slotName] = index

proc registerSignal*(qobject: var QObject, 
                     signalName: string, 
                     metatypes: openarray[QMetaType]) =
  ## Register a signal in the QObject with the given name and signature
  var index: cint 
  if metatypes.len > 0:
    var copy = toCIntSeq(metatypes)
    dos_qobject_signal_create(qobject.data, signalName, cast[cint](copy.len), cast[ptr cint](addr(copy[0])), index)
  else:
    dos_qobject_signal_create(qobject.data, signalName, 0, cast[ptr cint](0), index)
  qobject.signals[signalName] = index

proc registerProperty*(qobject: var QObject, 
                       propertyName: string, 
                       propertyType: QMetaType, 
                       readSlot: string, 
                       writeSlot: string, 
                       notifySignal: string) =
  ## Register a property in the QObject with the given name and type.
  dos_qobject_property_create(qobject.data, propertyName, cast[cint](propertyType), readSlot, writeSlot, notifySignal)

proc emit*(qobject: QObject, signalName: string, args: openarray[QVariant] = []) =
  ## Emit the signal with the given name and values
  if args.len > 0: 
    var copy: seq[QVariant]
    for i in 0..args.len-1:
      copy.add(args[i])
    dos_qobject_signal_emit(qobject.data, signalName, cast[cint](args.len), cast[pointer](addr(copy[0]))) 
  else:
    dos_qobject_signal_emit(qobject.data, signalName, 0, cast[pointer](0))

# QQuickView
proc dos_qquickview_create(view: var pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qquickview_delete(view: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qquickview_show(view: pointer) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qquickview_source(view: pointer, filename: var cstring, length: var int) {.cdecl, dynlib:"libDOtherSide.so", importc.}
proc dos_qquickview_set_source(view: pointer, filename: cstring) {.cdecl, dynlib:"libDOtherSide.so", importc.}

proc create(view: var QQuickView) =
  ## Create a new QQuickView
  var temp: pointer
  dos_qquickview_create(temp)
  view = QQuickView(temp)

proc source(view: QQuickView): cstring = 
  ## Return the source Qml file loaded by the view
  var length: int
  dos_qquickview_source(pointer(view), result, length)  

proc `source=`(view: QQuickView, filename: cstring) =
  ## Sets the source Qml file laoded by the view
  dos_qquickview_set_source(pointer(view), filename)

proc show(view: QQuickView) = 
  ## Sets the view visible 
  dos_qquickview_show(pointer(view))

proc delete(view: QQuickView) =
  ## Delete the given QQuickView
  dos_qquickview_delete(pointer(view))



