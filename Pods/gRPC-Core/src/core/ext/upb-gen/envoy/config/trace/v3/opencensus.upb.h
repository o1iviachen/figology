/* This file was generated by upb_generator from the input file:
 *
 *     envoy/config/trace/v3/opencensus.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated.
 * NO CHECKED-IN PROTOBUF GENCODE */

#ifndef ENVOY_CONFIG_TRACE_V3_OPENCENSUS_PROTO_UPB_H__UPB_H_
#define ENVOY_CONFIG_TRACE_V3_OPENCENSUS_PROTO_UPB_H__UPB_H_

#include "upb/generated_code_support.h"

#include "envoy/config/trace/v3/opencensus.upb_minitable.h"

#include "envoy/config/core/v3/grpc_service.upb_minitable.h"
#include "opencensus/proto/trace/v1/trace_config.upb_minitable.h"
#include "envoy/annotations/deprecation.upb_minitable.h"
#include "udpa/annotations/migrate.upb_minitable.h"
#include "udpa/annotations/status.upb_minitable.h"
#include "udpa/annotations/versioning.upb_minitable.h"

// Must be last.
#include "upb/port/def.inc"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct envoy_config_trace_v3_OpenCensusConfig { upb_Message UPB_PRIVATE(base); } envoy_config_trace_v3_OpenCensusConfig;
struct envoy_config_core_v3_GrpcService;
struct opencensus_proto_trace_v1_TraceConfig;

typedef enum {
  envoy_config_trace_v3_OpenCensusConfig_NONE = 0,
  envoy_config_trace_v3_OpenCensusConfig_TRACE_CONTEXT = 1,
  envoy_config_trace_v3_OpenCensusConfig_GRPC_TRACE_BIN = 2,
  envoy_config_trace_v3_OpenCensusConfig_CLOUD_TRACE_CONTEXT = 3,
  envoy_config_trace_v3_OpenCensusConfig_B3 = 4
} envoy_config_trace_v3_OpenCensusConfig_TraceContext;



/* envoy.config.trace.v3.OpenCensusConfig */

UPB_INLINE envoy_config_trace_v3_OpenCensusConfig* envoy_config_trace_v3_OpenCensusConfig_new(upb_Arena* arena) {
  return (envoy_config_trace_v3_OpenCensusConfig*)_upb_Message_New(&envoy__config__trace__v3__OpenCensusConfig_msg_init, arena);
}
UPB_INLINE envoy_config_trace_v3_OpenCensusConfig* envoy_config_trace_v3_OpenCensusConfig_parse(const char* buf, size_t size, upb_Arena* arena) {
  envoy_config_trace_v3_OpenCensusConfig* ret = envoy_config_trace_v3_OpenCensusConfig_new(arena);
  if (!ret) return NULL;
  if (upb_Decode(buf, size, UPB_UPCAST(ret), &envoy__config__trace__v3__OpenCensusConfig_msg_init, NULL, 0, arena) !=
      kUpb_DecodeStatus_Ok) {
    return NULL;
  }
  return ret;
}
UPB_INLINE envoy_config_trace_v3_OpenCensusConfig* envoy_config_trace_v3_OpenCensusConfig_parse_ex(const char* buf, size_t size,
                           const upb_ExtensionRegistry* extreg,
                           int options, upb_Arena* arena) {
  envoy_config_trace_v3_OpenCensusConfig* ret = envoy_config_trace_v3_OpenCensusConfig_new(arena);
  if (!ret) return NULL;
  if (upb_Decode(buf, size, UPB_UPCAST(ret), &envoy__config__trace__v3__OpenCensusConfig_msg_init, extreg, options,
                 arena) != kUpb_DecodeStatus_Ok) {
    return NULL;
  }
  return ret;
}
UPB_INLINE char* envoy_config_trace_v3_OpenCensusConfig_serialize(const envoy_config_trace_v3_OpenCensusConfig* msg, upb_Arena* arena, size_t* len) {
  char* ptr;
  (void)upb_Encode(UPB_UPCAST(msg), &envoy__config__trace__v3__OpenCensusConfig_msg_init, 0, arena, &ptr, len);
  return ptr;
}
UPB_INLINE char* envoy_config_trace_v3_OpenCensusConfig_serialize_ex(const envoy_config_trace_v3_OpenCensusConfig* msg, int options,
                                 upb_Arena* arena, size_t* len) {
  char* ptr;
  (void)upb_Encode(UPB_UPCAST(msg), &envoy__config__trace__v3__OpenCensusConfig_msg_init, options, arena, &ptr, len);
  return ptr;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_trace_config(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {1, UPB_SIZE(12, 16), 64, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE const struct opencensus_proto_trace_v1_TraceConfig* envoy_config_trace_v3_OpenCensusConfig_trace_config(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const struct opencensus_proto_trace_v1_TraceConfig* default_val = NULL;
  const struct opencensus_proto_trace_v1_TraceConfig* ret;
  const upb_MiniTableField field = {1, UPB_SIZE(12, 16), 64, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&opencensus__proto__trace__v1__TraceConfig_msg_init);
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_has_trace_config(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {1, UPB_SIZE(12, 16), 64, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  return upb_Message_HasBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_stdout_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {2, UPB_SIZE(16, 9), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_stdout_exporter_enabled(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  bool default_val = false;
  bool ret;
  const upb_MiniTableField field = {2, UPB_SIZE(16, 9), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_stackdriver_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {3, UPB_SIZE(17, 10), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_stackdriver_exporter_enabled(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  bool default_val = false;
  bool ret;
  const upb_MiniTableField field = {3, UPB_SIZE(17, 10), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_stackdriver_project_id(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {4, UPB_SIZE(40, 24), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE upb_StringView envoy_config_trace_v3_OpenCensusConfig_stackdriver_project_id(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  upb_StringView default_val = upb_StringView_FromString("");
  upb_StringView ret;
  const upb_MiniTableField field = {4, UPB_SIZE(40, 24), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_zipkin_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {5, UPB_SIZE(18, 11), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_zipkin_exporter_enabled(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  bool default_val = false;
  bool ret;
  const upb_MiniTableField field = {5, UPB_SIZE(18, 11), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_zipkin_url(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {6, UPB_SIZE(48, 40), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE upb_StringView envoy_config_trace_v3_OpenCensusConfig_zipkin_url(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  upb_StringView default_val = upb_StringView_FromString("");
  upb_StringView ret;
  const upb_MiniTableField field = {6, UPB_SIZE(48, 40), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_incoming_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE int32_t const* envoy_config_trace_v3_OpenCensusConfig_incoming_trace_context(const envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  const upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  const upb_Array* arr = upb_Message_GetArray(UPB_UPCAST(msg), &field);
  if (arr) {
    if (size) *size = arr->UPB_PRIVATE(size);
    return (int32_t const*)upb_Array_DataPtr(arr);
  } else {
    if (size) *size = 0;
    return NULL;
  }
}
UPB_INLINE const upb_Array* _envoy_config_trace_v3_OpenCensusConfig_incoming_trace_context_upb_array(const envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  const upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  const upb_Array* arr = upb_Message_GetArray(UPB_UPCAST(msg), &field);
  if (size) {
    *size = arr ? arr->UPB_PRIVATE(size) : 0;
  }
  return arr;
}
UPB_INLINE upb_Array* _envoy_config_trace_v3_OpenCensusConfig_incoming_trace_context_mutable_upb_array(envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size, upb_Arena* arena) {
  const upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetOrCreateMutableArray(UPB_UPCAST(msg),
                                                       &field, arena);
  if (size) {
    *size = arr ? arr->UPB_PRIVATE(size) : 0;
  }
  return arr;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_outgoing_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE int32_t const* envoy_config_trace_v3_OpenCensusConfig_outgoing_trace_context(const envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  const upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  const upb_Array* arr = upb_Message_GetArray(UPB_UPCAST(msg), &field);
  if (arr) {
    if (size) *size = arr->UPB_PRIVATE(size);
    return (int32_t const*)upb_Array_DataPtr(arr);
  } else {
    if (size) *size = 0;
    return NULL;
  }
}
UPB_INLINE const upb_Array* _envoy_config_trace_v3_OpenCensusConfig_outgoing_trace_context_upb_array(const envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  const upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  const upb_Array* arr = upb_Message_GetArray(UPB_UPCAST(msg), &field);
  if (size) {
    *size = arr ? arr->UPB_PRIVATE(size) : 0;
  }
  return arr;
}
UPB_INLINE upb_Array* _envoy_config_trace_v3_OpenCensusConfig_outgoing_trace_context_mutable_upb_array(envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size, upb_Arena* arena) {
  const upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetOrCreateMutableArray(UPB_UPCAST(msg),
                                                       &field, arena);
  if (size) {
    *size = arr ? arr->UPB_PRIVATE(size) : 0;
  }
  return arr;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_stackdriver_address(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {10, UPB_SIZE(56, 72), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE upb_StringView envoy_config_trace_v3_OpenCensusConfig_stackdriver_address(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  upb_StringView default_val = upb_StringView_FromString("");
  upb_StringView ret;
  const upb_MiniTableField field = {10, UPB_SIZE(56, 72), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_ocagent_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {11, UPB_SIZE(28, 12), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_ocagent_exporter_enabled(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  bool default_val = false;
  bool ret;
  const upb_MiniTableField field = {11, UPB_SIZE(28, 12), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_ocagent_address(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {12, UPB_SIZE(64, 88), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE upb_StringView envoy_config_trace_v3_OpenCensusConfig_ocagent_address(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  upb_StringView default_val = upb_StringView_FromString("");
  upb_StringView ret;
  const upb_MiniTableField field = {12, UPB_SIZE(64, 88), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_stackdriver_grpc_service(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {13, UPB_SIZE(32, 104), 65, 1, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE const struct envoy_config_core_v3_GrpcService* envoy_config_trace_v3_OpenCensusConfig_stackdriver_grpc_service(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const struct envoy_config_core_v3_GrpcService* default_val = NULL;
  const struct envoy_config_core_v3_GrpcService* ret;
  const upb_MiniTableField field = {13, UPB_SIZE(32, 104), 65, 1, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&envoy__config__core__v3__GrpcService_msg_init);
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_has_stackdriver_grpc_service(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {13, UPB_SIZE(32, 104), 65, 1, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  return upb_Message_HasBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_clear_ocagent_grpc_service(envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {14, UPB_SIZE(36, 112), 66, 2, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Message_ClearBaseField(UPB_UPCAST(msg), &field);
}
UPB_INLINE const struct envoy_config_core_v3_GrpcService* envoy_config_trace_v3_OpenCensusConfig_ocagent_grpc_service(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const struct envoy_config_core_v3_GrpcService* default_val = NULL;
  const struct envoy_config_core_v3_GrpcService* ret;
  const upb_MiniTableField field = {14, UPB_SIZE(36, 112), 66, 2, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&envoy__config__core__v3__GrpcService_msg_init);
  _upb_Message_GetNonExtensionField(UPB_UPCAST(msg), &field,
                                    &default_val, &ret);
  return ret;
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_has_ocagent_grpc_service(const envoy_config_trace_v3_OpenCensusConfig* msg) {
  const upb_MiniTableField field = {14, UPB_SIZE(36, 112), 66, 2, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  return upb_Message_HasBaseField(UPB_UPCAST(msg), &field);
}

UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_trace_config(envoy_config_trace_v3_OpenCensusConfig *msg, struct opencensus_proto_trace_v1_TraceConfig* value) {
  const upb_MiniTableField field = {1, UPB_SIZE(12, 16), 64, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&opencensus__proto__trace__v1__TraceConfig_msg_init);
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE struct opencensus_proto_trace_v1_TraceConfig* envoy_config_trace_v3_OpenCensusConfig_mutable_trace_config(envoy_config_trace_v3_OpenCensusConfig* msg, upb_Arena* arena) {
  struct opencensus_proto_trace_v1_TraceConfig* sub = (struct opencensus_proto_trace_v1_TraceConfig*)envoy_config_trace_v3_OpenCensusConfig_trace_config(msg);
  if (sub == NULL) {
    sub = (struct opencensus_proto_trace_v1_TraceConfig*)_upb_Message_New(&opencensus__proto__trace__v1__TraceConfig_msg_init, arena);
    if (sub) envoy_config_trace_v3_OpenCensusConfig_set_trace_config(msg, sub);
  }
  return sub;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_stdout_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig *msg, bool value) {
  const upb_MiniTableField field = {2, UPB_SIZE(16, 9), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_stackdriver_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig *msg, bool value) {
  const upb_MiniTableField field = {3, UPB_SIZE(17, 10), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_stackdriver_project_id(envoy_config_trace_v3_OpenCensusConfig *msg, upb_StringView value) {
  const upb_MiniTableField field = {4, UPB_SIZE(40, 24), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_zipkin_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig *msg, bool value) {
  const upb_MiniTableField field = {5, UPB_SIZE(18, 11), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_zipkin_url(envoy_config_trace_v3_OpenCensusConfig *msg, upb_StringView value) {
  const upb_MiniTableField field = {6, UPB_SIZE(48, 40), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE int32_t* envoy_config_trace_v3_OpenCensusConfig_mutable_incoming_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetMutableArray(UPB_UPCAST(msg), &field);
  if (arr) {
    if (size) *size = arr->UPB_PRIVATE(size);
    return (int32_t*)upb_Array_MutableDataPtr(arr);
  } else {
    if (size) *size = 0;
    return NULL;
  }
}
UPB_INLINE int32_t* envoy_config_trace_v3_OpenCensusConfig_resize_incoming_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, size_t size, upb_Arena* arena) {
  upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  return (int32_t*)upb_Message_ResizeArrayUninitialized(UPB_UPCAST(msg),
                                                   &field, size, arena);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_add_incoming_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, int32_t val, upb_Arena* arena) {
  upb_MiniTableField field = {8, UPB_SIZE(20, 56), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetOrCreateMutableArray(
      UPB_UPCAST(msg), &field, arena);
  if (!arr || !UPB_PRIVATE(_upb_Array_ResizeUninitialized)(
                  arr, arr->UPB_PRIVATE(size) + 1, arena)) {
    return false;
  }
  UPB_PRIVATE(_upb_Array_Set)
  (arr, arr->UPB_PRIVATE(size) - 1, &val, sizeof(val));
  return true;
}
UPB_INLINE int32_t* envoy_config_trace_v3_OpenCensusConfig_mutable_outgoing_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, size_t* size) {
  upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetMutableArray(UPB_UPCAST(msg), &field);
  if (arr) {
    if (size) *size = arr->UPB_PRIVATE(size);
    return (int32_t*)upb_Array_MutableDataPtr(arr);
  } else {
    if (size) *size = 0;
    return NULL;
  }
}
UPB_INLINE int32_t* envoy_config_trace_v3_OpenCensusConfig_resize_outgoing_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, size_t size, upb_Arena* arena) {
  upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  return (int32_t*)upb_Message_ResizeArrayUninitialized(UPB_UPCAST(msg),
                                                   &field, size, arena);
}
UPB_INLINE bool envoy_config_trace_v3_OpenCensusConfig_add_outgoing_trace_context(envoy_config_trace_v3_OpenCensusConfig* msg, int32_t val, upb_Arena* arena) {
  upb_MiniTableField field = {9, UPB_SIZE(24, 64), 0, kUpb_NoSub, 5, (int)kUpb_FieldMode_Array | (int)kUpb_LabelFlags_IsPacked | (int)kUpb_LabelFlags_IsAlternate | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  upb_Array* arr = upb_Message_GetOrCreateMutableArray(
      UPB_UPCAST(msg), &field, arena);
  if (!arr || !UPB_PRIVATE(_upb_Array_ResizeUninitialized)(
                  arr, arr->UPB_PRIVATE(size) + 1, arena)) {
    return false;
  }
  UPB_PRIVATE(_upb_Array_Set)
  (arr, arr->UPB_PRIVATE(size) - 1, &val, sizeof(val));
  return true;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_stackdriver_address(envoy_config_trace_v3_OpenCensusConfig *msg, upb_StringView value) {
  const upb_MiniTableField field = {10, UPB_SIZE(56, 72), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_ocagent_exporter_enabled(envoy_config_trace_v3_OpenCensusConfig *msg, bool value) {
  const upb_MiniTableField field = {11, UPB_SIZE(28, 12), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_ocagent_address(envoy_config_trace_v3_OpenCensusConfig *msg, upb_StringView value) {
  const upb_MiniTableField field = {12, UPB_SIZE(64, 88), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_stackdriver_grpc_service(envoy_config_trace_v3_OpenCensusConfig *msg, struct envoy_config_core_v3_GrpcService* value) {
  const upb_MiniTableField field = {13, UPB_SIZE(32, 104), 65, 1, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&envoy__config__core__v3__GrpcService_msg_init);
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE struct envoy_config_core_v3_GrpcService* envoy_config_trace_v3_OpenCensusConfig_mutable_stackdriver_grpc_service(envoy_config_trace_v3_OpenCensusConfig* msg, upb_Arena* arena) {
  struct envoy_config_core_v3_GrpcService* sub = (struct envoy_config_core_v3_GrpcService*)envoy_config_trace_v3_OpenCensusConfig_stackdriver_grpc_service(msg);
  if (sub == NULL) {
    sub = (struct envoy_config_core_v3_GrpcService*)_upb_Message_New(&envoy__config__core__v3__GrpcService_msg_init, arena);
    if (sub) envoy_config_trace_v3_OpenCensusConfig_set_stackdriver_grpc_service(msg, sub);
  }
  return sub;
}
UPB_INLINE void envoy_config_trace_v3_OpenCensusConfig_set_ocagent_grpc_service(envoy_config_trace_v3_OpenCensusConfig *msg, struct envoy_config_core_v3_GrpcService* value) {
  const upb_MiniTableField field = {14, UPB_SIZE(36, 112), 66, 2, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)};
  UPB_PRIVATE(_upb_MiniTable_StrongReference)(&envoy__config__core__v3__GrpcService_msg_init);
  upb_Message_SetBaseField((upb_Message *)msg, &field, &value);
}
UPB_INLINE struct envoy_config_core_v3_GrpcService* envoy_config_trace_v3_OpenCensusConfig_mutable_ocagent_grpc_service(envoy_config_trace_v3_OpenCensusConfig* msg, upb_Arena* arena) {
  struct envoy_config_core_v3_GrpcService* sub = (struct envoy_config_core_v3_GrpcService*)envoy_config_trace_v3_OpenCensusConfig_ocagent_grpc_service(msg);
  if (sub == NULL) {
    sub = (struct envoy_config_core_v3_GrpcService*)_upb_Message_New(&envoy__config__core__v3__GrpcService_msg_init, arena);
    if (sub) envoy_config_trace_v3_OpenCensusConfig_set_ocagent_grpc_service(msg, sub);
  }
  return sub;
}

#ifdef __cplusplus
}  /* extern "C" */
#endif

#include "upb/port/undef.inc"

#endif  /* ENVOY_CONFIG_TRACE_V3_OPENCENSUS_PROTO_UPB_H__UPB_H_ */
