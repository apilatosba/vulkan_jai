//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



// Enumerations
spv_result_t :: enum s32 {
    SUCCESS                  :: 0;
    UNSUPPORTED              :: 1;
    END_OF_STREAM            :: 2;
    WARNING                  :: 3;
    FAILED_MATCH             :: 4;
    REQUESTED_TERMINATION    :: 5;
    ERROR_INTERNAL           :: -1;
    ERROR_OUT_OF_MEMORY      :: -2;
    ERROR_INVALID_POINTER    :: -3;
    ERROR_INVALID_BINARY     :: -4;
    ERROR_INVALID_TEXT       :: -5;
    ERROR_INVALID_TABLE      :: -6;
    ERROR_INVALID_VALUE      :: -7;
    ERROR_INVALID_DIAGNOSTIC :: -8;
    ERROR_INVALID_LOOKUP     :: -9;
    ERROR_INVALID_ID         :: -10;
    ERROR_INVALID_CFG        :: -11;
    ERROR_INVALID_LAYOUT     :: -12;
    ERROR_INVALID_CAPABILITY :: -13;
    ERROR_INVALID_DATA       :: -14;
    ERROR_MISSING_EXTENSION  :: -15;
    ERROR_WRONG_VERSION      :: -16;
    ERROR_FNVAR              :: -17;

    FORCE_32BIT_spv_result_t :: 2147483647;

    SPV_SUCCESS                  :: SUCCESS;
    SPV_UNSUPPORTED              :: UNSUPPORTED;
    SPV_END_OF_STREAM            :: END_OF_STREAM;
    SPV_WARNING                  :: WARNING;
    SPV_FAILED_MATCH             :: FAILED_MATCH;
    SPV_REQUESTED_TERMINATION    :: REQUESTED_TERMINATION;
    SPV_ERROR_INTERNAL           :: ERROR_INTERNAL;
    SPV_ERROR_OUT_OF_MEMORY      :: ERROR_OUT_OF_MEMORY;
    SPV_ERROR_INVALID_POINTER    :: ERROR_INVALID_POINTER;
    SPV_ERROR_INVALID_BINARY     :: ERROR_INVALID_BINARY;
    SPV_ERROR_INVALID_TEXT       :: ERROR_INVALID_TEXT;
    SPV_ERROR_INVALID_TABLE      :: ERROR_INVALID_TABLE;
    SPV_ERROR_INVALID_VALUE      :: ERROR_INVALID_VALUE;
    SPV_ERROR_INVALID_DIAGNOSTIC :: ERROR_INVALID_DIAGNOSTIC;
    SPV_ERROR_INVALID_LOOKUP     :: ERROR_INVALID_LOOKUP;
    SPV_ERROR_INVALID_ID         :: ERROR_INVALID_ID;
    SPV_ERROR_INVALID_CFG        :: ERROR_INVALID_CFG;
    SPV_ERROR_INVALID_LAYOUT     :: ERROR_INVALID_LAYOUT;
    SPV_ERROR_INVALID_CAPABILITY :: ERROR_INVALID_CAPABILITY;
    SPV_ERROR_INVALID_DATA       :: ERROR_INVALID_DATA;
    SPV_ERROR_MISSING_EXTENSION  :: ERROR_MISSING_EXTENSION;
    SPV_ERROR_WRONG_VERSION      :: ERROR_WRONG_VERSION;
    SPV_ERROR_FNVAR              :: ERROR_FNVAR;

    SPV_FORCE_32BIT_spv_result_t :: FORCE_32BIT_spv_result_t;
}

// Severity levels of messages communicated to the consumer.
spv_message_level_t :: enum u32 {
    FATAL          :: 0;

    INTERNAL_ERROR :: 1;

    ERROR          :: 2;
    WARNING        :: 3;
    INFO           :: 4;
    DEBUG          :: 5;

    SPV_MSG_FATAL          :: FATAL;

    SPV_MSG_INTERNAL_ERROR :: INTERNAL_ERROR;

    SPV_MSG_ERROR          :: ERROR;
    SPV_MSG_WARNING        :: WARNING;
    SPV_MSG_INFO           :: INFO;
    SPV_MSG_DEBUG          :: DEBUG;
}

spv_endianness_t :: enum u32 {
    ENDIANNESS_LITTLE            :: 0;
    ENDIANNESS_BIG               :: 1;
    FORCE_32BIT_spv_endianness_t :: 2147483647;

    SPV_ENDIANNESS_LITTLE            :: ENDIANNESS_LITTLE;
    SPV_ENDIANNESS_BIG               :: ENDIANNESS_BIG;
    SPV_FORCE_32BIT_spv_endianness_t :: FORCE_32BIT_spv_endianness_t;
}

// The kinds of operands that an instruction may have.
//
// Some operand types are "concrete".  The binary parser uses a concrete
// operand type to describe an operand of a parsed instruction.
//
// The assembler uses all operand types.  In addition to determining what
// kind of value an operand may be, non-concrete operand types capture the
// fact that an operand might be optional (may be absent, or present exactly
// once), or might occur zero or more times.
//
// Sometimes we also need to be able to express the fact that an operand
// is a member of an optional tuple of values.  In that case the first member
// would be optional, and the subsequent members would be required.
//
// NOTE: Although we don't promise binary compatibility, as a courtesy, please
// add new enum values at the end.
spv_operand_type_t :: enum u32 {
    OPERAND_TYPE_NONE                                          :: 0;

    OPERAND_TYPE_ID                                            :: 1;
    OPERAND_TYPE_TYPE_ID                                       :: 2;
    OPERAND_TYPE_RESULT_ID                                     :: 3;
    OPERAND_TYPE_MEMORY_SEMANTICS_ID                           :: 4;
    OPERAND_TYPE_SCOPE_ID                                      :: 5;

    OPERAND_TYPE_LITERAL_INTEGER                               :: 6;

    OPERAND_TYPE_EXTENSION_INSTRUCTION_NUMBER                  :: 7;

    OPERAND_TYPE_SPEC_CONSTANT_OP_NUMBER                       :: 8;

    OPERAND_TYPE_TYPED_LITERAL_NUMBER                          :: 9;
    OPERAND_TYPE_LITERAL_FLOAT                                 :: 10;

    OPERAND_TYPE_LITERAL_STRING                                :: 11;

    OPERAND_TYPE_SOURCE_LANGUAGE                               :: 12;
    OPERAND_TYPE_EXECUTION_MODEL                               :: 13;
    OPERAND_TYPE_ADDRESSING_MODEL                              :: 14;
    OPERAND_TYPE_MEMORY_MODEL                                  :: 15;
    OPERAND_TYPE_EXECUTION_MODE                                :: 16;
    OPERAND_TYPE_STORAGE_CLASS                                 :: 17;
    OPERAND_TYPE_DIMENSIONALITY                                :: 18;
    OPERAND_TYPE_SAMPLER_ADDRESSING_MODE                       :: 19;
    OPERAND_TYPE_SAMPLER_FILTER_MODE                           :: 20;
    OPERAND_TYPE_SAMPLER_IMAGE_FORMAT                          :: 21;
    OPERAND_TYPE_IMAGE_CHANNEL_ORDER                           :: 22;
    OPERAND_TYPE_IMAGE_CHANNEL_DATA_TYPE                       :: 23;
    OPERAND_TYPE_FP_ROUNDING_MODE                              :: 24;
    OPERAND_TYPE_LINKAGE_TYPE                                  :: 25;
    OPERAND_TYPE_ACCESS_QUALIFIER                              :: 26;
    OPERAND_TYPE_FUNCTION_PARAMETER_ATTRIBUTE                  :: 27;
    OPERAND_TYPE_DECORATION                                    :: 28;
    OPERAND_TYPE_BUILT_IN                                      :: 29;
    OPERAND_TYPE_GROUP_OPERATION                               :: 30;
    OPERAND_TYPE_KERNEL_ENQ_FLAGS                              :: 31;
    OPERAND_TYPE_KERNEL_PROFILING_INFO                         :: 32;
    OPERAND_TYPE_CAPABILITY                                    :: 33;
    OPERAND_TYPE_FPENCODING                                    :: 34;

    OPERAND_TYPE_IMAGE                                         :: 35;
    OPERAND_TYPE_FP_FAST_MATH_MODE                             :: 36;
    OPERAND_TYPE_SELECTION_CONTROL                             :: 37;
    OPERAND_TYPE_LOOP_CONTROL                                  :: 38;
    OPERAND_TYPE_FUNCTION_CONTROL                              :: 39;
    OPERAND_TYPE_MEMORY_ACCESS                                 :: 40;
    OPERAND_TYPE_FRAGMENT_SHADING_RATE                         :: 41;

    OPERAND_TYPE_OPTIONAL_ID                                   :: 42;

    OPERAND_TYPE_OPTIONAL_IMAGE                                :: 43;

    OPERAND_TYPE_OPTIONAL_MEMORY_ACCESS                        :: 44;

    OPERAND_TYPE_OPTIONAL_LITERAL_INTEGER                      :: 45;

    OPERAND_TYPE_OPTIONAL_LITERAL_NUMBER                       :: 46;

    OPERAND_TYPE_OPTIONAL_TYPED_LITERAL_INTEGER                :: 47;

    OPERAND_TYPE_OPTIONAL_LITERAL_STRING                       :: 48;

    OPERAND_TYPE_OPTIONAL_ACCESS_QUALIFIER                     :: 49;

    OPERAND_TYPE_OPTIONAL_CIV                                  :: 50;

    OPERAND_TYPE_OPTIONAL_FPENCODING                           :: 51;

    OPERAND_TYPE_VARIABLE_ID                                   :: 52;
    OPERAND_TYPE_VARIABLE_LITERAL_INTEGER                      :: 53;

    OPERAND_TYPE_VARIABLE_LITERAL_INTEGER_ID                   :: 54;

    OPERAND_TYPE_VARIABLE_ID_LITERAL_INTEGER                   :: 55;

    OPERAND_TYPE_DEBUG_INFO_FLAGS                              :: 56;
    OPERAND_TYPE_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING            :: 57;
    OPERAND_TYPE_DEBUG_COMPOSITE_TYPE                          :: 58;
    OPERAND_TYPE_DEBUG_TYPE_QUALIFIER                          :: 59;
    OPERAND_TYPE_DEBUG_OPERATION                               :: 60;

    OPERAND_TYPE_CLDEBUG100_DEBUG_INFO_FLAGS                   :: 61;
    OPERAND_TYPE_CLDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING :: 62;
    OPERAND_TYPE_CLDEBUG100_DEBUG_COMPOSITE_TYPE               :: 63;
    OPERAND_TYPE_CLDEBUG100_DEBUG_TYPE_QUALIFIER               :: 64;
    OPERAND_TYPE_CLDEBUG100_DEBUG_OPERATION                    :: 65;
    OPERAND_TYPE_CLDEBUG100_DEBUG_IMPORTED_ENTITY              :: 66;

    OPERAND_TYPE_FPDENORM_MODE                                 :: 67;
    OPERAND_TYPE_FPOPERATION_MODE                              :: 68;

    OPERAND_TYPE_QUANTIZATION_MODES                            :: 69;

    OPERAND_TYPE_OVERFLOW_MODES                                :: 70;

    OPERAND_TYPE_RAY_FLAGS                                     :: 71;
    OPERAND_TYPE_RAY_QUERY_INTERSECTION                        :: 72;
    OPERAND_TYPE_RAY_QUERY_COMMITTED_INTERSECTION_TYPE         :: 73;

    OPERAND_TYPE_RAY_QUERY_CANDIDATE_INTERSECTION_TYPE         :: 74;

    OPERAND_TYPE_PACKED_VECTOR_FORMAT                          :: 75;

    OPERAND_TYPE_OPTIONAL_PACKED_VECTOR_FORMAT                 :: 76;

    OPERAND_TYPE_COOPERATIVE_MATRIX_OPERANDS                   :: 77;

    OPERAND_TYPE_OPTIONAL_COOPERATIVE_MATRIX_OPERANDS          :: 78;
    OPERAND_TYPE_COOPERATIVE_MATRIX_LAYOUT                     :: 79;
    OPERAND_TYPE_COOPERATIVE_MATRIX_USE                        :: 80;

    OPERAND_TYPE_INITIALIZATION_MODE_QUALIFIER                 :: 81;

    OPERAND_TYPE_HOST_ACCESS_QUALIFIER                         :: 82;

    OPERAND_TYPE_LOAD_CACHE_CONTROL                            :: 83;

    OPERAND_TYPE_STORE_CACHE_CONTROL                           :: 84;

    OPERAND_TYPE_NAMED_MAXIMUM_NUMBER_OF_REGISTERS             :: 85;

    OPERAND_TYPE_RAW_ACCESS_CHAIN_OPERANDS                     :: 86;

    OPERAND_TYPE_OPTIONAL_RAW_ACCESS_CHAIN_OPERANDS            :: 87;

    OPERAND_TYPE_TENSOR_CLAMP_MODE                             :: 88;

    OPERAND_TYPE_COOPERATIVE_MATRIX_REDUCE                     :: 89;

    OPERAND_TYPE_TENSOR_ADDRESSING_OPERANDS                    :: 90;

    OPERAND_TYPE_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS           :: 91;
    OPERAND_TYPE_OPTIONAL_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS  :: 92;

    OPERAND_TYPE_COOPERATIVE_VECTOR_MATRIX_LAYOUT              :: 93;
    OPERAND_TYPE_COMPONENT_TYPE                                :: 94;

    OPERAND_TYPE_KERNEL_PROPERTY_FLAGS                         :: 95;

    OPERAND_TYPE_SHDEBUG100_BUILD_IDENTIFIER_FLAGS             :: 96;
    OPERAND_TYPE_SHDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING :: 97;
    OPERAND_TYPE_SHDEBUG100_DEBUG_COMPOSITE_TYPE               :: 98;
    OPERAND_TYPE_SHDEBUG100_DEBUG_IMPORTED_ENTITY              :: 99;
    OPERAND_TYPE_SHDEBUG100_DEBUG_INFO_FLAGS                   :: 100;
    OPERAND_TYPE_SHDEBUG100_DEBUG_OPERATION                    :: 101;
    OPERAND_TYPE_SHDEBUG100_DEBUG_TYPE_QUALIFIER               :: 102;

    OPERAND_TYPE_TENSOR_OPERANDS                               :: 103;
    OPERAND_TYPE_OPTIONAL_TENSOR_OPERANDS                      :: 104;

    OPERAND_TYPE_OPTIONAL_CAPABILITY                           :: 105;
    OPERAND_TYPE_VARIABLE_CAPABILITY                           :: 106;

    OPERAND_TYPE_NUM_OPERAND_TYPES                             :: 107;

    FORCE_32BIT_spv_operand_type_t                             :: 2147483647;

    SPV_OPERAND_TYPE_NONE                                          :: OPERAND_TYPE_NONE;

    SPV_OPERAND_TYPE_ID                                            :: OPERAND_TYPE_ID;
    SPV_OPERAND_TYPE_TYPE_ID                                       :: OPERAND_TYPE_TYPE_ID;
    SPV_OPERAND_TYPE_RESULT_ID                                     :: OPERAND_TYPE_RESULT_ID;
    SPV_OPERAND_TYPE_MEMORY_SEMANTICS_ID                           :: OPERAND_TYPE_MEMORY_SEMANTICS_ID;
    SPV_OPERAND_TYPE_SCOPE_ID                                      :: OPERAND_TYPE_SCOPE_ID;

    SPV_OPERAND_TYPE_LITERAL_INTEGER                               :: OPERAND_TYPE_LITERAL_INTEGER;

    SPV_OPERAND_TYPE_EXTENSION_INSTRUCTION_NUMBER                  :: OPERAND_TYPE_EXTENSION_INSTRUCTION_NUMBER;

    SPV_OPERAND_TYPE_SPEC_CONSTANT_OP_NUMBER                       :: OPERAND_TYPE_SPEC_CONSTANT_OP_NUMBER;

    SPV_OPERAND_TYPE_TYPED_LITERAL_NUMBER                          :: OPERAND_TYPE_TYPED_LITERAL_NUMBER;
    SPV_OPERAND_TYPE_LITERAL_FLOAT                                 :: OPERAND_TYPE_LITERAL_FLOAT;

    SPV_OPERAND_TYPE_LITERAL_STRING                                :: OPERAND_TYPE_LITERAL_STRING;

    SPV_OPERAND_TYPE_SOURCE_LANGUAGE                               :: OPERAND_TYPE_SOURCE_LANGUAGE;
    SPV_OPERAND_TYPE_EXECUTION_MODEL                               :: OPERAND_TYPE_EXECUTION_MODEL;
    SPV_OPERAND_TYPE_ADDRESSING_MODEL                              :: OPERAND_TYPE_ADDRESSING_MODEL;
    SPV_OPERAND_TYPE_MEMORY_MODEL                                  :: OPERAND_TYPE_MEMORY_MODEL;
    SPV_OPERAND_TYPE_EXECUTION_MODE                                :: OPERAND_TYPE_EXECUTION_MODE;
    SPV_OPERAND_TYPE_STORAGE_CLASS                                 :: OPERAND_TYPE_STORAGE_CLASS;
    SPV_OPERAND_TYPE_DIMENSIONALITY                                :: OPERAND_TYPE_DIMENSIONALITY;
    SPV_OPERAND_TYPE_SAMPLER_ADDRESSING_MODE                       :: OPERAND_TYPE_SAMPLER_ADDRESSING_MODE;
    SPV_OPERAND_TYPE_SAMPLER_FILTER_MODE                           :: OPERAND_TYPE_SAMPLER_FILTER_MODE;
    SPV_OPERAND_TYPE_SAMPLER_IMAGE_FORMAT                          :: OPERAND_TYPE_SAMPLER_IMAGE_FORMAT;
    SPV_OPERAND_TYPE_IMAGE_CHANNEL_ORDER                           :: OPERAND_TYPE_IMAGE_CHANNEL_ORDER;
    SPV_OPERAND_TYPE_IMAGE_CHANNEL_DATA_TYPE                       :: OPERAND_TYPE_IMAGE_CHANNEL_DATA_TYPE;
    SPV_OPERAND_TYPE_FP_ROUNDING_MODE                              :: OPERAND_TYPE_FP_ROUNDING_MODE;
    SPV_OPERAND_TYPE_LINKAGE_TYPE                                  :: OPERAND_TYPE_LINKAGE_TYPE;
    SPV_OPERAND_TYPE_ACCESS_QUALIFIER                              :: OPERAND_TYPE_ACCESS_QUALIFIER;
    SPV_OPERAND_TYPE_FUNCTION_PARAMETER_ATTRIBUTE                  :: OPERAND_TYPE_FUNCTION_PARAMETER_ATTRIBUTE;
    SPV_OPERAND_TYPE_DECORATION                                    :: OPERAND_TYPE_DECORATION;
    SPV_OPERAND_TYPE_BUILT_IN                                      :: OPERAND_TYPE_BUILT_IN;
    SPV_OPERAND_TYPE_GROUP_OPERATION                               :: OPERAND_TYPE_GROUP_OPERATION;
    SPV_OPERAND_TYPE_KERNEL_ENQ_FLAGS                              :: OPERAND_TYPE_KERNEL_ENQ_FLAGS;
    SPV_OPERAND_TYPE_KERNEL_PROFILING_INFO                         :: OPERAND_TYPE_KERNEL_PROFILING_INFO;
    SPV_OPERAND_TYPE_CAPABILITY                                    :: OPERAND_TYPE_CAPABILITY;
    SPV_OPERAND_TYPE_FPENCODING                                    :: OPERAND_TYPE_FPENCODING;

    SPV_OPERAND_TYPE_IMAGE                                         :: OPERAND_TYPE_IMAGE;
    SPV_OPERAND_TYPE_FP_FAST_MATH_MODE                             :: OPERAND_TYPE_FP_FAST_MATH_MODE;
    SPV_OPERAND_TYPE_SELECTION_CONTROL                             :: OPERAND_TYPE_SELECTION_CONTROL;
    SPV_OPERAND_TYPE_LOOP_CONTROL                                  :: OPERAND_TYPE_LOOP_CONTROL;
    SPV_OPERAND_TYPE_FUNCTION_CONTROL                              :: OPERAND_TYPE_FUNCTION_CONTROL;
    SPV_OPERAND_TYPE_MEMORY_ACCESS                                 :: OPERAND_TYPE_MEMORY_ACCESS;
    SPV_OPERAND_TYPE_FRAGMENT_SHADING_RATE                         :: OPERAND_TYPE_FRAGMENT_SHADING_RATE;

    SPV_OPERAND_TYPE_OPTIONAL_ID                                   :: OPERAND_TYPE_OPTIONAL_ID;

    SPV_OPERAND_TYPE_OPTIONAL_IMAGE                                :: OPERAND_TYPE_OPTIONAL_IMAGE;

    SPV_OPERAND_TYPE_OPTIONAL_MEMORY_ACCESS                        :: OPERAND_TYPE_OPTIONAL_MEMORY_ACCESS;

    SPV_OPERAND_TYPE_OPTIONAL_LITERAL_INTEGER                      :: OPERAND_TYPE_OPTIONAL_LITERAL_INTEGER;

    SPV_OPERAND_TYPE_OPTIONAL_LITERAL_NUMBER                       :: OPERAND_TYPE_OPTIONAL_LITERAL_NUMBER;

    SPV_OPERAND_TYPE_OPTIONAL_TYPED_LITERAL_INTEGER                :: OPERAND_TYPE_OPTIONAL_TYPED_LITERAL_INTEGER;

    SPV_OPERAND_TYPE_OPTIONAL_LITERAL_STRING                       :: OPERAND_TYPE_OPTIONAL_LITERAL_STRING;

    SPV_OPERAND_TYPE_OPTIONAL_ACCESS_QUALIFIER                     :: OPERAND_TYPE_OPTIONAL_ACCESS_QUALIFIER;

    SPV_OPERAND_TYPE_OPTIONAL_CIV                                  :: OPERAND_TYPE_OPTIONAL_CIV;

    SPV_OPERAND_TYPE_OPTIONAL_FPENCODING                           :: OPERAND_TYPE_OPTIONAL_FPENCODING;

    SPV_OPERAND_TYPE_VARIABLE_ID                                   :: OPERAND_TYPE_VARIABLE_ID;
    SPV_OPERAND_TYPE_VARIABLE_LITERAL_INTEGER                      :: OPERAND_TYPE_VARIABLE_LITERAL_INTEGER;

    SPV_OPERAND_TYPE_VARIABLE_LITERAL_INTEGER_ID                   :: OPERAND_TYPE_VARIABLE_LITERAL_INTEGER_ID;

    SPV_OPERAND_TYPE_VARIABLE_ID_LITERAL_INTEGER                   :: OPERAND_TYPE_VARIABLE_ID_LITERAL_INTEGER;

    SPV_OPERAND_TYPE_DEBUG_INFO_FLAGS                              :: OPERAND_TYPE_DEBUG_INFO_FLAGS;
    SPV_OPERAND_TYPE_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING            :: OPERAND_TYPE_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING;
    SPV_OPERAND_TYPE_DEBUG_COMPOSITE_TYPE                          :: OPERAND_TYPE_DEBUG_COMPOSITE_TYPE;
    SPV_OPERAND_TYPE_DEBUG_TYPE_QUALIFIER                          :: OPERAND_TYPE_DEBUG_TYPE_QUALIFIER;
    SPV_OPERAND_TYPE_DEBUG_OPERATION                               :: OPERAND_TYPE_DEBUG_OPERATION;

    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_INFO_FLAGS                   :: OPERAND_TYPE_CLDEBUG100_DEBUG_INFO_FLAGS;
    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING :: OPERAND_TYPE_CLDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING;
    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_COMPOSITE_TYPE               :: OPERAND_TYPE_CLDEBUG100_DEBUG_COMPOSITE_TYPE;
    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_TYPE_QUALIFIER               :: OPERAND_TYPE_CLDEBUG100_DEBUG_TYPE_QUALIFIER;
    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_OPERATION                    :: OPERAND_TYPE_CLDEBUG100_DEBUG_OPERATION;
    SPV_OPERAND_TYPE_CLDEBUG100_DEBUG_IMPORTED_ENTITY              :: OPERAND_TYPE_CLDEBUG100_DEBUG_IMPORTED_ENTITY;

    SPV_OPERAND_TYPE_FPDENORM_MODE                                 :: OPERAND_TYPE_FPDENORM_MODE;
    SPV_OPERAND_TYPE_FPOPERATION_MODE                              :: OPERAND_TYPE_FPOPERATION_MODE;

    SPV_OPERAND_TYPE_QUANTIZATION_MODES                            :: OPERAND_TYPE_QUANTIZATION_MODES;

    SPV_OPERAND_TYPE_OVERFLOW_MODES                                :: OPERAND_TYPE_OVERFLOW_MODES;

    SPV_OPERAND_TYPE_RAY_FLAGS                                     :: OPERAND_TYPE_RAY_FLAGS;
    SPV_OPERAND_TYPE_RAY_QUERY_INTERSECTION                        :: OPERAND_TYPE_RAY_QUERY_INTERSECTION;
    SPV_OPERAND_TYPE_RAY_QUERY_COMMITTED_INTERSECTION_TYPE         :: OPERAND_TYPE_RAY_QUERY_COMMITTED_INTERSECTION_TYPE;

    SPV_OPERAND_TYPE_RAY_QUERY_CANDIDATE_INTERSECTION_TYPE         :: OPERAND_TYPE_RAY_QUERY_CANDIDATE_INTERSECTION_TYPE;

    SPV_OPERAND_TYPE_PACKED_VECTOR_FORMAT                          :: OPERAND_TYPE_PACKED_VECTOR_FORMAT;

    SPV_OPERAND_TYPE_OPTIONAL_PACKED_VECTOR_FORMAT                 :: OPERAND_TYPE_OPTIONAL_PACKED_VECTOR_FORMAT;

    SPV_OPERAND_TYPE_COOPERATIVE_MATRIX_OPERANDS                   :: OPERAND_TYPE_COOPERATIVE_MATRIX_OPERANDS;

    SPV_OPERAND_TYPE_OPTIONAL_COOPERATIVE_MATRIX_OPERANDS          :: OPERAND_TYPE_OPTIONAL_COOPERATIVE_MATRIX_OPERANDS;
    SPV_OPERAND_TYPE_COOPERATIVE_MATRIX_LAYOUT                     :: OPERAND_TYPE_COOPERATIVE_MATRIX_LAYOUT;
    SPV_OPERAND_TYPE_COOPERATIVE_MATRIX_USE                        :: OPERAND_TYPE_COOPERATIVE_MATRIX_USE;

    SPV_OPERAND_TYPE_INITIALIZATION_MODE_QUALIFIER                 :: OPERAND_TYPE_INITIALIZATION_MODE_QUALIFIER;

    SPV_OPERAND_TYPE_HOST_ACCESS_QUALIFIER                         :: OPERAND_TYPE_HOST_ACCESS_QUALIFIER;

    SPV_OPERAND_TYPE_LOAD_CACHE_CONTROL                            :: OPERAND_TYPE_LOAD_CACHE_CONTROL;

    SPV_OPERAND_TYPE_STORE_CACHE_CONTROL                           :: OPERAND_TYPE_STORE_CACHE_CONTROL;

    SPV_OPERAND_TYPE_NAMED_MAXIMUM_NUMBER_OF_REGISTERS             :: OPERAND_TYPE_NAMED_MAXIMUM_NUMBER_OF_REGISTERS;

    SPV_OPERAND_TYPE_RAW_ACCESS_CHAIN_OPERANDS                     :: OPERAND_TYPE_RAW_ACCESS_CHAIN_OPERANDS;

    SPV_OPERAND_TYPE_OPTIONAL_RAW_ACCESS_CHAIN_OPERANDS            :: OPERAND_TYPE_OPTIONAL_RAW_ACCESS_CHAIN_OPERANDS;

    SPV_OPERAND_TYPE_TENSOR_CLAMP_MODE                             :: OPERAND_TYPE_TENSOR_CLAMP_MODE;

    SPV_OPERAND_TYPE_COOPERATIVE_MATRIX_REDUCE                     :: OPERAND_TYPE_COOPERATIVE_MATRIX_REDUCE;

    SPV_OPERAND_TYPE_TENSOR_ADDRESSING_OPERANDS                    :: OPERAND_TYPE_TENSOR_ADDRESSING_OPERANDS;

    SPV_OPERAND_TYPE_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS           :: OPERAND_TYPE_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS;
    SPV_OPERAND_TYPE_OPTIONAL_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS  :: OPERAND_TYPE_OPTIONAL_MATRIX_MULTIPLY_ACCUMULATE_OPERANDS;

    SPV_OPERAND_TYPE_COOPERATIVE_VECTOR_MATRIX_LAYOUT              :: OPERAND_TYPE_COOPERATIVE_VECTOR_MATRIX_LAYOUT;
    SPV_OPERAND_TYPE_COMPONENT_TYPE                                :: OPERAND_TYPE_COMPONENT_TYPE;

    SPV_OPERAND_TYPE_KERNEL_PROPERTY_FLAGS                         :: OPERAND_TYPE_KERNEL_PROPERTY_FLAGS;

    SPV_OPERAND_TYPE_SHDEBUG100_BUILD_IDENTIFIER_FLAGS             :: OPERAND_TYPE_SHDEBUG100_BUILD_IDENTIFIER_FLAGS;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING :: OPERAND_TYPE_SHDEBUG100_DEBUG_BASE_TYPE_ATTRIBUTE_ENCODING;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_COMPOSITE_TYPE               :: OPERAND_TYPE_SHDEBUG100_DEBUG_COMPOSITE_TYPE;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_IMPORTED_ENTITY              :: OPERAND_TYPE_SHDEBUG100_DEBUG_IMPORTED_ENTITY;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_INFO_FLAGS                   :: OPERAND_TYPE_SHDEBUG100_DEBUG_INFO_FLAGS;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_OPERATION                    :: OPERAND_TYPE_SHDEBUG100_DEBUG_OPERATION;
    SPV_OPERAND_TYPE_SHDEBUG100_DEBUG_TYPE_QUALIFIER               :: OPERAND_TYPE_SHDEBUG100_DEBUG_TYPE_QUALIFIER;

    SPV_OPERAND_TYPE_TENSOR_OPERANDS                               :: OPERAND_TYPE_TENSOR_OPERANDS;
    SPV_OPERAND_TYPE_OPTIONAL_TENSOR_OPERANDS                      :: OPERAND_TYPE_OPTIONAL_TENSOR_OPERANDS;

    SPV_OPERAND_TYPE_OPTIONAL_CAPABILITY                           :: OPERAND_TYPE_OPTIONAL_CAPABILITY;
    SPV_OPERAND_TYPE_VARIABLE_CAPABILITY                           :: OPERAND_TYPE_VARIABLE_CAPABILITY;

    SPV_OPERAND_TYPE_NUM_OPERAND_TYPES                             :: OPERAND_TYPE_NUM_OPERAND_TYPES;

    SPV_FORCE_32BIT_spv_operand_type_t                             :: FORCE_32BIT_spv_operand_type_t;
}

spv_ext_inst_type_t :: enum u32 {
    EXT_INST_TYPE_NONE                                     :: 0;
    EXT_INST_TYPE_GLSL_STD_450                             :: 1;
    EXT_INST_TYPE_OPENCL_STD                               :: 2;
    EXT_INST_TYPE_SPV_AMD_SHADER_EXPLICIT_VERTEX_PARAMETER :: 3;
    EXT_INST_TYPE_SPV_AMD_SHADER_TRINARY_MINMAX            :: 4;
    EXT_INST_TYPE_SPV_AMD_GCN_SHADER                       :: 5;
    EXT_INST_TYPE_SPV_AMD_SHADER_BALLOT                    :: 6;
    EXT_INST_TYPE_DEBUGINFO                                :: 7;
    EXT_INST_TYPE_OPENCL_DEBUGINFO_100                     :: 8;
    EXT_INST_TYPE_NONSEMANTIC_CLSPVREFLECTION              :: 9;
    EXT_INST_TYPE_NONSEMANTIC_SHADER_DEBUGINFO_100         :: 10;
    EXT_INST_TYPE_NONSEMANTIC_VKSPREFLECTION               :: 11;
    EXT_INST_TYPE_TOSA_001000_1                            :: 12;
    EXT_INST_TYPE_ARM_MOTION_ENGINE_100                    :: 13;

    EXT_INST_TYPE_NONSEMANTIC_UNKNOWN                      :: 14;

    FORCE_32BIT_spv_ext_inst_type_t                        :: 2147483647;

    SPV_EXT_INST_TYPE_NONE                                     :: EXT_INST_TYPE_NONE;
    SPV_EXT_INST_TYPE_GLSL_STD_450                             :: EXT_INST_TYPE_GLSL_STD_450;
    SPV_EXT_INST_TYPE_OPENCL_STD                               :: EXT_INST_TYPE_OPENCL_STD;
    SPV_EXT_INST_TYPE_SPV_AMD_SHADER_EXPLICIT_VERTEX_PARAMETER :: EXT_INST_TYPE_SPV_AMD_SHADER_EXPLICIT_VERTEX_PARAMETER;
    SPV_EXT_INST_TYPE_SPV_AMD_SHADER_TRINARY_MINMAX            :: EXT_INST_TYPE_SPV_AMD_SHADER_TRINARY_MINMAX;
    SPV_EXT_INST_TYPE_SPV_AMD_GCN_SHADER                       :: EXT_INST_TYPE_SPV_AMD_GCN_SHADER;
    SPV_EXT_INST_TYPE_SPV_AMD_SHADER_BALLOT                    :: EXT_INST_TYPE_SPV_AMD_SHADER_BALLOT;
    SPV_EXT_INST_TYPE_DEBUGINFO                                :: EXT_INST_TYPE_DEBUGINFO;
    SPV_EXT_INST_TYPE_OPENCL_DEBUGINFO_100                     :: EXT_INST_TYPE_OPENCL_DEBUGINFO_100;
    SPV_EXT_INST_TYPE_NONSEMANTIC_CLSPVREFLECTION              :: EXT_INST_TYPE_NONSEMANTIC_CLSPVREFLECTION;
    SPV_EXT_INST_TYPE_NONSEMANTIC_SHADER_DEBUGINFO_100         :: EXT_INST_TYPE_NONSEMANTIC_SHADER_DEBUGINFO_100;
    SPV_EXT_INST_TYPE_NONSEMANTIC_VKSPREFLECTION               :: EXT_INST_TYPE_NONSEMANTIC_VKSPREFLECTION;
    SPV_EXT_INST_TYPE_TOSA_001000_1                            :: EXT_INST_TYPE_TOSA_001000_1;
    SPV_EXT_INST_TYPE_ARM_MOTION_ENGINE_100                    :: EXT_INST_TYPE_ARM_MOTION_ENGINE_100;

    SPV_EXT_INST_TYPE_NONSEMANTIC_UNKNOWN                      :: EXT_INST_TYPE_NONSEMANTIC_UNKNOWN;

    SPV_FORCE_32BIT_spv_ext_inst_type_t                        :: FORCE_32BIT_spv_ext_inst_type_t;
}

// This determines at a high level the kind of a binary-encoded literal
// number, but not the bit width.
// In principle, these could probably be folded into new entries in
// spv_operand_type_t.  But then we'd have some special case differences
// between the assembler and disassembler.
spv_number_kind_t :: enum u32 {
    NONE         :: 0;
    UNSIGNED_INT :: 1;
    SIGNED_INT   :: 2;
    FLOATING     :: 3;

    SPV_NUMBER_NONE         :: NONE;
    SPV_NUMBER_UNSIGNED_INT :: UNSIGNED_INT;
    SPV_NUMBER_SIGNED_INT   :: SIGNED_INT;
    SPV_NUMBER_FLOATING     :: FLOATING;
}

// Represent the encoding of floating point values
spv_fp_encoding_t :: enum u32 {
    UNKNOWN          :: 0;

    IEEE754_BINARY16 :: 1;
    IEEE754_BINARY32 :: 2;
    IEEE754_BINARY64 :: 3;
    BFLOAT16         :: 4;
    FLOAT8_E4M3      :: 5;
    FLOAT8_E5M2      :: 6;

    SPV_FP_ENCODING_UNKNOWN          :: UNKNOWN;

    SPV_FP_ENCODING_IEEE754_BINARY16 :: IEEE754_BINARY16;
    SPV_FP_ENCODING_IEEE754_BINARY32 :: IEEE754_BINARY32;
    SPV_FP_ENCODING_IEEE754_BINARY64 :: IEEE754_BINARY64;
    SPV_FP_ENCODING_BFLOAT16         :: BFLOAT16;
    SPV_FP_ENCODING_FLOAT8_E4M3      :: FLOAT8_E4M3;
    SPV_FP_ENCODING_FLOAT8_E5M2      :: FLOAT8_E5M2;
}

spv_text_to_binary_options_t :: enum u32 {
    TEXT_TO_BINARY_OPTION_NONE                 :: 1;

    TEXT_TO_BINARY_OPTION_PRESERVE_NUMERIC_IDS :: 2;
    FORCE_32BIT_spv_text_to_binary_options_t   :: 2147483647;

    SPV_TEXT_TO_BINARY_OPTION_NONE                 :: TEXT_TO_BINARY_OPTION_NONE;

    SPV_TEXT_TO_BINARY_OPTION_PRESERVE_NUMERIC_IDS :: TEXT_TO_BINARY_OPTION_PRESERVE_NUMERIC_IDS;
    SPV_FORCE_32BIT_spv_text_to_binary_options_t   :: FORCE_32BIT_spv_text_to_binary_options_t;
}

spv_binary_to_text_options_t :: enum u32 {
    BINARY_TO_TEXT_OPTION_NONE                   :: 1;
    BINARY_TO_TEXT_OPTION_PRINT                  :: 2;
    BINARY_TO_TEXT_OPTION_COLOR                  :: 4;
    BINARY_TO_TEXT_OPTION_INDENT                 :: 8;
    BINARY_TO_TEXT_OPTION_SHOW_BYTE_OFFSET       :: 16;

    BINARY_TO_TEXT_OPTION_NO_HEADER              :: 32;

    BINARY_TO_TEXT_OPTION_FRIENDLY_NAMES         :: 64;

    BINARY_TO_TEXT_OPTION_COMMENT                :: 128;

    BINARY_TO_TEXT_OPTION_NESTED_INDENT          :: 256;

    BINARY_TO_TEXT_OPTION_REORDER_BLOCKS         :: 512;

    BINARY_TO_TEXT_OPTION_HANDLE_UNKNOWN_OPCODES :: 1024;
    FORCE_32BIT_spv_binary_to_text_options_t     :: 2147483647;

    SPV_BINARY_TO_TEXT_OPTION_NONE                   :: BINARY_TO_TEXT_OPTION_NONE;
    SPV_BINARY_TO_TEXT_OPTION_PRINT                  :: BINARY_TO_TEXT_OPTION_PRINT;
    SPV_BINARY_TO_TEXT_OPTION_COLOR                  :: BINARY_TO_TEXT_OPTION_COLOR;
    SPV_BINARY_TO_TEXT_OPTION_INDENT                 :: BINARY_TO_TEXT_OPTION_INDENT;
    SPV_BINARY_TO_TEXT_OPTION_SHOW_BYTE_OFFSET       :: BINARY_TO_TEXT_OPTION_SHOW_BYTE_OFFSET;

    SPV_BINARY_TO_TEXT_OPTION_NO_HEADER              :: BINARY_TO_TEXT_OPTION_NO_HEADER;

    SPV_BINARY_TO_TEXT_OPTION_FRIENDLY_NAMES         :: BINARY_TO_TEXT_OPTION_FRIENDLY_NAMES;

    SPV_BINARY_TO_TEXT_OPTION_COMMENT                :: BINARY_TO_TEXT_OPTION_COMMENT;

    SPV_BINARY_TO_TEXT_OPTION_NESTED_INDENT          :: BINARY_TO_TEXT_OPTION_NESTED_INDENT;

    SPV_BINARY_TO_TEXT_OPTION_REORDER_BLOCKS         :: BINARY_TO_TEXT_OPTION_REORDER_BLOCKS;

    SPV_BINARY_TO_TEXT_OPTION_HANDLE_UNKNOWN_OPCODES :: BINARY_TO_TEXT_OPTION_HANDLE_UNKNOWN_OPCODES;
    SPV_FORCE_32BIT_spv_binary_to_text_options_t     :: FORCE_32BIT_spv_binary_to_text_options_t;
}

// The default id bound is to the minimum value for the id limit
// in the spir-v specification under the section "Universal Limits".
kDefaultMaxIdBound: u32 : 4194303;

// Information about an operand parsed from a binary SPIR-V module.
// Note that the values are not included.  You still need access to the binary
// to extract the values.
spv_parsed_operand_t :: struct {
    // Location of the operand, in words from the start of the instruction.
    offset:           u16;

    // Number of words occupied by this operand.
    num_words:        u16;

    // The "concrete" operand type.  See the definition of spv_operand_type_t
    // for details.
    type:             spv_operand_type_t;

    // If type is a literal number type, then number_kind says whether it's
    // a signed integer, an unsigned integer, or a floating point number.
    number_kind:      spv_number_kind_t;

    // The number of bits for a literal number type.
    number_bit_width: u32;

    // The encoding used for floating point values
    fp_encoding:      spv_fp_encoding_t;
}

// An instruction parsed from a binary SPIR-V module.
spv_parsed_instruction_t :: struct {
    // An array of words for this instruction, in native endianness.
    words:         *u32;

    // The number of words in this instruction.
    num_words:     u16;
    opcode:        u16;

    // The extended instruction type, if opcode is OpExtInst.  Otherwise
    // this is the "none" value.
    ext_inst_type: spv_ext_inst_type_t;

    // The type id, or 0 if this instruction doesn't have one.
    type_id:       u32;

    // The result id, or 0 if this instruction doesn't have one.
    result_id:     u32;

    // The array of parsed operands.
    operands:      *spv_parsed_operand_t;
    num_operands:  u16;
}

spv_parsed_header_t :: struct {
    // The magic number of the SPIR-V module.
    magic:     u32;

    // Version number.
    version:   u32;

    // Generator's magic number.
    generator: u32;

    // IDs bound for this module (0 < id < bound).
    bound:     u32;

    // reserved.
    reserved:  u32;
}

spv_const_binary_t :: struct {
    code:      *u32;
    wordCount: u64;
}

spv_binary_t :: struct {
    code:      *u32;
    wordCount: u64;
}

spv_text_t :: struct {
    str:    *u8;
    length: u64;
}

spv_position_t :: struct {
    line:   u64;
    column: u64;
    index:  u64;
}

spv_diagnostic_t :: struct {
    position:     spv_position_t;
    error:        *u8;
    isTextSource: bool;
}

spv_context_t :: struct {}

spv_validator_options_t :: struct {}

spv_optimizer_options_t :: struct {}

spv_reducer_options_t :: struct {}

spv_fuzzer_options_t :: struct {}

spv_optimizer_t :: struct {}

// Type Definitions
spv_const_binary :: *spv_const_binary_t;
spv_binary :: *spv_binary_t;
spv_text :: *spv_text_t;
spv_position :: *spv_position_t;
spv_diagnostic :: *spv_diagnostic_t;
spv_const_context :: *spv_context_t;
spv_context :: *spv_context_t;
spv_validator_options :: *spv_validator_options_t;
spv_const_validator_options :: *spv_validator_options_t;
spv_optimizer_options :: *spv_optimizer_options_t;
spv_const_optimizer_options :: *spv_optimizer_options_t;
spv_reducer_options :: *spv_reducer_options_t;
spv_const_reducer_options :: *spv_reducer_options_t;
spv_fuzzer_options :: *spv_fuzzer_options_t;
spv_const_fuzzer_options :: *spv_fuzzer_options_t;

// Returns the SPIRV-Tools software version as a null-terminated string.
// The contents of the underlying storage is valid for the remainder of
// the process.
spvSoftwareVersionString :: () -> *u8 #foreign libspirv_tools_shared;

// Returns a null-terminated string containing the name of the project,
// the software version string, and commit details.
// The contents of the underlying storage is valid for the remainder of
// the process.
spvSoftwareVersionDetailsString :: () -> *u8 #foreign libspirv_tools_shared;

// Certain target environments impose additional restrictions on SPIR-V, so it's
// often necessary to specify which one applies.  SPV_ENV_UNIVERSAL_* implies an
// environment-agnostic SPIR-V.
//
// When an API method needs to derive a SPIR-V version from a target environment
// (from the spv_context object), the method will choose the highest version of
// SPIR-V supported by the target environment.  Examples:
//    SPV_ENV_VULKAN_1_0           ->  SPIR-V 1.0
//    SPV_ENV_VULKAN_1_1           ->  SPIR-V 1.3
//    SPV_ENV_VULKAN_1_1_SPIRV_1_4 ->  SPIR-V 1.4
//    SPV_ENV_VULKAN_1_2           ->  SPIR-V 1.5
//    SPV_ENV_VULKAN_1_3           ->  SPIR-V 1.6
//    SPV_ENV_VULKAN_1_4           ->  SPIR-V 1.6
// Consult the description of API entry points for specific rules.
spv_target_env :: enum u32 {
    UNIVERSAL_1_0        :: 0;
    VULKAN_1_0           :: 1;
    UNIVERSAL_1_1        :: 2;
    OPENCL_2_1           :: 3;
    OPENCL_2_2           :: 4;
    OPENGL_4_0           :: 5;
    OPENGL_4_1           :: 6;
    OPENGL_4_2           :: 7;
    OPENGL_4_3           :: 8;

    OPENGL_4_5           :: 9;
    UNIVERSAL_1_2        :: 10;
    OPENCL_1_2           :: 11;

    OPENCL_EMBEDDED_1_2  :: 12;

    OPENCL_2_0           :: 13;

    OPENCL_EMBEDDED_2_0  :: 14;

    OPENCL_EMBEDDED_2_1  :: 15;
    OPENCL_EMBEDDED_2_2  :: 16;
    UNIVERSAL_1_3        :: 17;
    VULKAN_1_1           :: 18;
    WEBGPU_0             :: 19;
    UNIVERSAL_1_4        :: 20;

    VULKAN_1_1_SPIRV_1_4 :: 21;

    UNIVERSAL_1_5        :: 22;
    VULKAN_1_2           :: 23;

    UNIVERSAL_1_6        :: 24;
    VULKAN_1_3           :: 25;
    VULKAN_1_4           :: 26;

    MAX                  :: 27;

    SPV_ENV_UNIVERSAL_1_0        :: UNIVERSAL_1_0;
    SPV_ENV_VULKAN_1_0           :: VULKAN_1_0;
    SPV_ENV_UNIVERSAL_1_1        :: UNIVERSAL_1_1;
    SPV_ENV_OPENCL_2_1           :: OPENCL_2_1;
    SPV_ENV_OPENCL_2_2           :: OPENCL_2_2;
    SPV_ENV_OPENGL_4_0           :: OPENGL_4_0;
    SPV_ENV_OPENGL_4_1           :: OPENGL_4_1;
    SPV_ENV_OPENGL_4_2           :: OPENGL_4_2;
    SPV_ENV_OPENGL_4_3           :: OPENGL_4_3;

    SPV_ENV_OPENGL_4_5           :: OPENGL_4_5;
    SPV_ENV_UNIVERSAL_1_2        :: UNIVERSAL_1_2;
    SPV_ENV_OPENCL_1_2           :: OPENCL_1_2;

    SPV_ENV_OPENCL_EMBEDDED_1_2  :: OPENCL_EMBEDDED_1_2;

    SPV_ENV_OPENCL_2_0           :: OPENCL_2_0;

    SPV_ENV_OPENCL_EMBEDDED_2_0  :: OPENCL_EMBEDDED_2_0;

    SPV_ENV_OPENCL_EMBEDDED_2_1  :: OPENCL_EMBEDDED_2_1;
    SPV_ENV_OPENCL_EMBEDDED_2_2  :: OPENCL_EMBEDDED_2_2;
    SPV_ENV_UNIVERSAL_1_3        :: UNIVERSAL_1_3;
    SPV_ENV_VULKAN_1_1           :: VULKAN_1_1;
    SPV_ENV_WEBGPU_0             :: WEBGPU_0;
    SPV_ENV_UNIVERSAL_1_4        :: UNIVERSAL_1_4;

    SPV_ENV_VULKAN_1_1_SPIRV_1_4 :: VULKAN_1_1_SPIRV_1_4;

    SPV_ENV_UNIVERSAL_1_5        :: UNIVERSAL_1_5;
    SPV_ENV_VULKAN_1_2           :: VULKAN_1_2;

    SPV_ENV_UNIVERSAL_1_6        :: UNIVERSAL_1_6;
    SPV_ENV_VULKAN_1_3           :: VULKAN_1_3;
    SPV_ENV_VULKAN_1_4           :: VULKAN_1_4;

    SPV_ENV_MAX                  :: MAX;
}

// SPIR-V Validator can be parameterized with the following Universal Limits.
spv_validator_limit :: enum u32 {
    max_struct_members             :: 0;
    max_struct_depth               :: 1;
    max_local_variables            :: 2;
    max_global_variables           :: 3;
    max_switch_branches            :: 4;
    max_function_args              :: 5;
    max_control_flow_nesting_depth :: 6;
    max_access_chain_indexes       :: 7;
    max_id_bound                   :: 8;

    spv_validator_limit_max_struct_members             :: max_struct_members;
    spv_validator_limit_max_struct_depth               :: max_struct_depth;
    spv_validator_limit_max_local_variables            :: max_local_variables;
    spv_validator_limit_max_global_variables           :: max_global_variables;
    spv_validator_limit_max_switch_branches            :: max_switch_branches;
    spv_validator_limit_max_function_args              :: max_function_args;
    spv_validator_limit_max_control_flow_nesting_depth :: max_control_flow_nesting_depth;
    spv_validator_limit_max_access_chain_indexes       :: max_access_chain_indexes;
    spv_validator_limit_max_id_bound                   :: max_id_bound;
}

// Returns a string describing the given SPIR-V target environment.
spvTargetEnvDescription :: (env: spv_target_env) -> *u8 #foreign libspirv_tools_shared;

// Parses s into *env and returns true if successful.  If unparsable, returns
// false and sets *env to SPV_ENV_UNIVERSAL_1_0.
spvParseTargetEnv :: (s: *u8, env: *spv_target_env) -> bool #foreign libspirv_tools_shared;

// Determines the target env value with the least features but which enables
// the given Vulkan and SPIR-V versions. If such a target is supported, returns
// true and writes the value to |env|, otherwise returns false.
//
// The Vulkan version is given as an unsigned 32-bit number as specified in
// Vulkan section "29.2.1 Version Numbers": the major version number appears
// in bits 22 to 21, and the minor version is in bits 12 to 21.  The SPIR-V
// version is given in the SPIR-V version header word: major version in bits
// 16 to 23, and minor version in bits 8 to 15.
spvParseVulkanEnv :: (vulkan_ver: u32, spirv_ver: u32, env: *spv_target_env) -> bool #foreign libspirv_tools_shared;

// Creates a context object for most of the SPIRV-Tools API.
// Returns null if env is invalid.
//
// See specific API calls for how the target environment is interpreted
// (particularly assembly and validation).
spvContextCreate :: (env: spv_target_env) -> spv_context #foreign libspirv_tools_shared;

// Destroys the given context object.
spvContextDestroy :: (_context: spv_context) -> void #foreign libspirv_tools_shared;

// Creates a Validator options object with default options. Returns a valid
// options object. The object remains valid until it is passed into
// spvValidatorOptionsDestroy.
spvValidatorOptionsCreate :: () -> spv_validator_options #foreign libspirv_tools_shared;

// Destroys the given Validator options object.
spvValidatorOptionsDestroy :: (options: spv_validator_options) -> void #foreign libspirv_tools_shared;

// Records the maximum Universal Limit that is considered valid in the given
// Validator options object. <options> argument must be a valid options object.
spvValidatorOptionsSetUniversalLimit :: (options: spv_validator_options, limit_type: spv_validator_limit, limit: u32) -> void #foreign libspirv_tools_shared;

// Record whether or not the validator should relax the rules on types for
// stores to structs.  When relaxed, it will allow a type mismatch as long as
// the types are structs with the same layout.  Two structs have the same layout
// if
//
// 1) the members of the structs are either the same type or are structs with
// same layout, and
//
// 2) the decorations that affect the memory layout are identical for both
// types.  Other decorations are not relevant.
spvValidatorOptionsSetRelaxStoreStruct :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether or not the validator should relax the rules on pointer usage
// in logical addressing mode.
//
// When relaxed, it will allow the following usage cases of pointers:
// 1) OpVariable allocating an object whose type is a pointer type
// 2) OpReturnValue returning a pointer value
spvValidatorOptionsSetRelaxLogicalPointer :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether or not the validator should relax the rules because it is
// expected that the optimizations will make the code legal.
//
// When relaxed, it will allow the following:
// 1) It will allow relaxed logical pointers.  Setting this option will also
//    set that option.
// 2) Pointers that are pass as parameters to function calls do not have to
//    match the storage class of the formal parameter.
// 3) Pointers that are actual parameters on function calls do not have to point
//    to the same type pointed as the formal parameter.  The types just need to
//    logically match.
// 4) GLSLstd450 Interpolate* instructions can have a load of an interpolant
//    for a first argument.
spvValidatorOptionsSetBeforeHlslLegalization :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether the validator should use "relaxed" block layout rules.
// Relaxed layout rules are described by Vulkan extension
// VK_KHR_relaxed_block_layout, and they affect uniform blocks, storage blocks,
// and push constants.
//
// This is enabled by default when targeting Vulkan 1.1 or later.
// Relaxed layout is more permissive than the default rules in Vulkan 1.0.
spvValidatorOptionsSetRelaxBlockLayout :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether the validator should use standard block layout rules for
// uniform blocks.
spvValidatorOptionsSetUniformBufferStandardLayout :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether the validator should use "scalar" block layout rules.
// Scalar layout rules are more permissive than relaxed block layout.
//
// See Vulkan extension VK_EXT_scalar_block_layout.  The scalar alignment is
// defined as follows:
// - scalar alignment of a scalar is the scalar size
// - scalar alignment of a vector is the scalar alignment of its component
// - scalar alignment of a matrix is the scalar alignment of its component
// - scalar alignment of an array is the scalar alignment of its element
// - scalar alignment of a struct is the max scalar alignment among its
//   members
//
// For a struct in Uniform, StorageClass, or PushConstant:
// - a member Offset must be a multiple of the member's scalar alignment
// - ArrayStride or MatrixStride must be a multiple of the array or matrix
//   scalar alignment
spvValidatorOptionsSetScalarBlockLayout :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether the validator should use "scalar" block layout
// rules (as defined above) for Workgroup blocks.  See Vulkan
// extension VK_KHR_workgroup_memory_explicit_layout.
spvValidatorOptionsSetWorkgroupScalarBlockLayout :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether or not the validator should skip validating standard
// uniform/storage block layout.
spvValidatorOptionsSetSkipBlockLayout :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether or not the validator should allow the LocalSizeId
// decoration where the environment otherwise would not allow it.
spvValidatorOptionsSetAllowLocalSizeId :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Allow Offset (in addition to ConstOffset) for texture operations.
// Was added for VK_KHR_maintenance8
spvValidatorOptionsSetAllowOffsetTextureOperand :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Allow base operands of some bit operations to be non-32-bit wide.
// Was added for VK_KHR_maintenance9
spvValidatorOptionsSetAllowVulkan32BitBitwise :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Whether friendly names should be used in validation error messages.
spvValidatorOptionsSetFriendlyNames :: (options: spv_validator_options, val: bool) -> void #foreign libspirv_tools_shared;

// Creates an optimizer options object with default options. Returns a valid
// options object. The object remains valid until it is passed into
// |spvOptimizerOptionsDestroy|.
spvOptimizerOptionsCreate :: () -> spv_optimizer_options #foreign libspirv_tools_shared;

// Destroys the given optimizer options object.
spvOptimizerOptionsDestroy :: (options: spv_optimizer_options) -> void #foreign libspirv_tools_shared;

// Records whether or not the optimizer should run the validator before
// optimizing.  If |val| is true, the validator will be run.
spvOptimizerOptionsSetRunValidator :: (options: spv_optimizer_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records the validator options that should be passed to the validator if it is
// run.
spvOptimizerOptionsSetValidatorOptions :: (options: spv_optimizer_options, val: spv_validator_options) -> void #foreign libspirv_tools_shared;

// Records the maximum possible value for the id bound.
spvOptimizerOptionsSetMaxIdBound :: (options: spv_optimizer_options, val: u32) -> void #foreign libspirv_tools_shared;

// Records whether all bindings within the module should be preserved.
spvOptimizerOptionsSetPreserveBindings :: (options: spv_optimizer_options, val: bool) -> void #foreign libspirv_tools_shared;

// Records whether all specialization constants within the module
// should be preserved.
spvOptimizerOptionsSetPreserveSpecConstants :: (options: spv_optimizer_options, val: bool) -> void #foreign libspirv_tools_shared;

// Creates a reducer options object with default options. Returns a valid
// options object. The object remains valid until it is passed into
// |spvReducerOptionsDestroy|.
spvReducerOptionsCreate :: () -> spv_reducer_options #foreign libspirv_tools_shared;

// Destroys the given reducer options object.
spvReducerOptionsDestroy :: (options: spv_reducer_options) -> void #foreign libspirv_tools_shared;

// Sets the maximum number of reduction steps that should run before the reducer
// gives up.
spvReducerOptionsSetStepLimit :: (options: spv_reducer_options, step_limit: u32) -> void #foreign libspirv_tools_shared;

// Sets the fail-on-validation-error option; if true, the reducer will return
// kStateInvalid if a reduction step yields a state that fails SPIR-V
// validation. Otherwise, an invalid state is treated as uninteresting and the
// reduction backtracks and continues.
spvReducerOptionsSetFailOnValidationError :: (options: spv_reducer_options, fail_on_validation_error: bool) -> void #foreign libspirv_tools_shared;

// Sets the function that the reducer should target.  If set to zero the reducer
// will target all functions as well as parts of the module that lie outside
// functions.  Otherwise the reducer will restrict reduction to the function
// with result id |target_function|, which is required to exist.
spvReducerOptionsSetTargetFunction :: (options: spv_reducer_options, target_function: u32) -> void #foreign libspirv_tools_shared;

// Creates a fuzzer options object with default options. Returns a valid
// options object. The object remains valid until it is passed into
// |spvFuzzerOptionsDestroy|.
spvFuzzerOptionsCreate :: () -> spv_fuzzer_options #foreign libspirv_tools_shared;

// Destroys the given fuzzer options object.
spvFuzzerOptionsDestroy :: (options: spv_fuzzer_options) -> void #foreign libspirv_tools_shared;

// Enables running the validator after every transformation is applied during
// a replay.
spvFuzzerOptionsEnableReplayValidation :: (options: spv_fuzzer_options) -> void #foreign libspirv_tools_shared;

// Sets the seed with which the random number generator used by the fuzzer
// should be initialized.
spvFuzzerOptionsSetRandomSeed :: (options: spv_fuzzer_options, seed: u32) -> void #foreign libspirv_tools_shared;

// Sets the range of transformations that should be applied during replay: 0
// means all transformations, +N means the first N transformations, -N means all
// except the final N transformations.
spvFuzzerOptionsSetReplayRange :: (options: spv_fuzzer_options, replay_range: s32) -> void #foreign libspirv_tools_shared;

// Sets the maximum number of steps that the shrinker should take before giving
// up.
spvFuzzerOptionsSetShrinkerStepLimit :: (options: spv_fuzzer_options, shrinker_step_limit: u32) -> void #foreign libspirv_tools_shared;

// Enables running the validator after every pass is applied during a fuzzing
// run.
spvFuzzerOptionsEnableFuzzerPassValidation :: (options: spv_fuzzer_options) -> void #foreign libspirv_tools_shared;

// Enables all fuzzer passes during a fuzzing run (instead of a random subset
// of passes).
spvFuzzerOptionsEnableAllPasses :: (options: spv_fuzzer_options) -> void #foreign libspirv_tools_shared;

// Encodes the given SPIR-V assembly text to its binary representation. The
// length parameter specifies the number of bytes for text. Encoded binary will
// be stored into *binary. Any error will be written into *diagnostic if
// diagnostic is non-null, otherwise the context's message consumer will be
// used. The generated binary is independent of the context and may outlive it.
// The SPIR-V binary version is set to the highest version of SPIR-V supported
// by the context's target environment.
spvTextToBinary :: (_context: spv_const_context, text: *u8, length: u64, binary: *spv_binary, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Encodes the given SPIR-V assembly text to its binary representation. Same as
// spvTextToBinary but with options. The options parameter is a bit field of
// spv_text_to_binary_options_t.
spvTextToBinaryWithOptions :: (_context: spv_const_context, text: *u8, length: u64, options: u32, binary: *spv_binary, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Frees an allocated text stream. This is a no-op if the text parameter
// is a null pointer.
spvTextDestroy :: (text: spv_text) -> void #foreign libspirv_tools_shared;

// Decodes the given SPIR-V binary representation to its assembly text. The
// word_count parameter specifies the number of words for binary. The options
// parameter is a bit field of spv_binary_to_text_options_t. Decoded text will
// be stored into *text. Any error will be written into *diagnostic if
// diagnostic is non-null, otherwise the context's message consumer will be
// used.
spvBinaryToText :: (_context: spv_const_context, binary: *u32, word_count: u64, options: u32, text: *spv_text, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Frees a binary stream from memory. This is a no-op if binary is a null
// pointer.
spvBinaryDestroy :: (binary: spv_binary) -> void #foreign libspirv_tools_shared;

// Validates a SPIR-V binary for correctness. Any errors will be written into
// *diagnostic if diagnostic is non-null, otherwise the context's message
// consumer will be used.
//
// Validate for SPIR-V spec rules for the SPIR-V version named in the
// binary's header (at word offset 1).  Additionally, if the context target
// environment is a client API (such as Vulkan 1.1), then validate for that
// client API version, to the extent that it is verifiable from data in the
// binary itself.
spvValidate :: (_context: spv_const_context, binary: spv_const_binary, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Validates a SPIR-V binary for correctness. Uses the provided Validator
// options. Any errors will be written into *diagnostic if diagnostic is
// non-null, otherwise the context's message consumer will be used.
//
// Validate for SPIR-V spec rules for the SPIR-V version named in the
// binary's header (at word offset 1).  Additionally, if the context target
// environment is a client API (such as Vulkan 1.1), then validate for that
// client API version, to the extent that it is verifiable from data in the
// binary itself, or in the validator options.
spvValidateWithOptions :: (_context: spv_const_context, options: spv_const_validator_options, binary: spv_const_binary, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Validates a raw SPIR-V binary for correctness. Any errors will be written
// into *diagnostic if diagnostic is non-null, otherwise the context's message
// consumer will be used.
spvValidateBinary :: (_context: spv_const_context, words: *u32, num_words: u64, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Creates a diagnostic object. The position parameter specifies the location in
// the text/binary stream. The message parameter, copied into the diagnostic
// object, contains the error message to display.
spvDiagnosticCreate :: (position: spv_position, message: *u8) -> spv_diagnostic #foreign libspirv_tools_shared;

// Destroys a diagnostic object.  This is a no-op if diagnostic is a null
// pointer.
spvDiagnosticDestroy :: (diagnostic: spv_diagnostic) -> void #foreign libspirv_tools_shared;

// Prints the diagnostic to stderr.
spvDiagnosticPrint :: (diagnostic: spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// Gets the name of an instruction, without the "Op" prefix.
spvOpcodeString :: (opcode: u32) -> *u8 #foreign libspirv_tools_shared;

// A pointer to a function that accepts a parsed SPIR-V header.
// The integer arguments are the 32-bit words from the header, as specified
// in SPIR-V 1.0 Section 2.3 Table 1.
// The function should return SPV_SUCCESS if parsing should continue.
spv_parsed_header_fn_t :: #type (user_data: *void, endian: spv_endianness_t, magic: u32, version: u32, generator: u32, id_bound: u32, reserved: u32) -> spv_result_t #c_call;

// A pointer to a function that accepts a parsed SPIR-V instruction.
// The parsed_instruction value is transient: it may be overwritten
// or released immediately after the function has returned.  That also
// applies to the words array member of the parsed instruction.  The
// function should return SPV_SUCCESS if and only if parsing should
// continue.
spv_parsed_instruction_fn_t :: #type (user_data: *void, parsed_instruction: *spv_parsed_instruction_t) -> spv_result_t #c_call;

// Parses a SPIR-V binary, specified as counted sequence of 32-bit words.
// Parsing feedback is provided via two callbacks provided as function
// pointers.  Each callback function pointer can be a null pointer, in
// which case it is never called.  Otherwise, in a valid parse the
// parsed-header callback is called once, and then the parsed-instruction
// callback once for each instruction in the stream.  The user_data parameter
// is supplied as context to the callbacks.  Returns SPV_SUCCESS on successful
// parse where the callbacks always return SPV_SUCCESS.  For an invalid parse,
// returns a status code other than SPV_SUCCESS, and if diagnostic is non-null
// also emits a diagnostic. If diagnostic is null the context's message consumer
// will be used to emit any errors. If a callback returns anything other than
// SPV_SUCCESS, then that status code is returned, no further callbacks are
// issued, and no additional diagnostics are emitted.
spvBinaryParse :: (_context: spv_const_context, user_data: *void, words: *u32, num_words: u64, parse_header: spv_parsed_header_fn_t, parse_instruction: spv_parsed_instruction_fn_t, diagnostic: *spv_diagnostic) -> spv_result_t #foreign libspirv_tools_shared;

// A pointer to a function that accepts a log message from an optimizer.
spv_message_consumer :: #type (unknown0: spv_message_level_t, unknown1: *u8, unknown2: *spv_position_t, unknown3: *u8) -> void #c_call;

#scope_file

#import "Basic"; // For assert

libspirv_tools_shared :: #library "linux/libSPIRV-Tools-shared";

#run {
    {
        info := type_info(spv_parsed_operand_t);
        for info.members {
            if it.name == {
                case "offset";
                    assert(it.offset_in_bytes == 0, "spv_parsed_operand_t.offset has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 2, "spv_parsed_operand_t.offset has unexpected size % instead of 2", it.type.runtime_size);
                case "num_words";
                    assert(it.offset_in_bytes == 2, "spv_parsed_operand_t.num_words has unexpected offset % instead of 2", it.offset_in_bytes);
                    assert(it.type.runtime_size == 2, "spv_parsed_operand_t.num_words has unexpected size % instead of 2", it.type.runtime_size);
                case "type";
                    assert(it.offset_in_bytes == 4, "spv_parsed_operand_t.type has unexpected offset % instead of 4", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_operand_t.type has unexpected size % instead of 4", it.type.runtime_size);
                case "number_kind";
                    assert(it.offset_in_bytes == 8, "spv_parsed_operand_t.number_kind has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_operand_t.number_kind has unexpected size % instead of 4", it.type.runtime_size);
                case "number_bit_width";
                    assert(it.offset_in_bytes == 12, "spv_parsed_operand_t.number_bit_width has unexpected offset % instead of 12", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_operand_t.number_bit_width has unexpected size % instead of 4", it.type.runtime_size);
                case "fp_encoding";
                    assert(it.offset_in_bytes == 16, "spv_parsed_operand_t.fp_encoding has unexpected offset % instead of 16", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_operand_t.fp_encoding has unexpected size % instead of 4", it.type.runtime_size);
            }
        }
        assert(size_of(spv_parsed_operand_t) == 20, "spv_parsed_operand_t has size % instead of 20", size_of(spv_parsed_operand_t));
    }

    {
        info := type_info(spv_parsed_instruction_t);
        for info.members {
            if it.name == {
                case "words";
                    assert(it.offset_in_bytes == 0, "spv_parsed_instruction_t.words has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_parsed_instruction_t.words has unexpected size % instead of 8", it.type.runtime_size);
                case "num_words";
                    assert(it.offset_in_bytes == 8, "spv_parsed_instruction_t.num_words has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 2, "spv_parsed_instruction_t.num_words has unexpected size % instead of 2", it.type.runtime_size);
                case "opcode";
                    assert(it.offset_in_bytes == 10, "spv_parsed_instruction_t.opcode has unexpected offset % instead of 10", it.offset_in_bytes);
                    assert(it.type.runtime_size == 2, "spv_parsed_instruction_t.opcode has unexpected size % instead of 2", it.type.runtime_size);
                case "ext_inst_type";
                    assert(it.offset_in_bytes == 12, "spv_parsed_instruction_t.ext_inst_type has unexpected offset % instead of 12", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_instruction_t.ext_inst_type has unexpected size % instead of 4", it.type.runtime_size);
                case "type_id";
                    assert(it.offset_in_bytes == 16, "spv_parsed_instruction_t.type_id has unexpected offset % instead of 16", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_instruction_t.type_id has unexpected size % instead of 4", it.type.runtime_size);
                case "result_id";
                    assert(it.offset_in_bytes == 20, "spv_parsed_instruction_t.result_id has unexpected offset % instead of 20", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_instruction_t.result_id has unexpected size % instead of 4", it.type.runtime_size);
                case "operands";
                    assert(it.offset_in_bytes == 24, "spv_parsed_instruction_t.operands has unexpected offset % instead of 24", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_parsed_instruction_t.operands has unexpected size % instead of 8", it.type.runtime_size);
                case "num_operands";
                    assert(it.offset_in_bytes == 32, "spv_parsed_instruction_t.num_operands has unexpected offset % instead of 32", it.offset_in_bytes);
                    assert(it.type.runtime_size == 2, "spv_parsed_instruction_t.num_operands has unexpected size % instead of 2", it.type.runtime_size);
            }
        }
        assert(size_of(spv_parsed_instruction_t) == 40, "spv_parsed_instruction_t has size % instead of 40", size_of(spv_parsed_instruction_t));
    }

    {
        info := type_info(spv_parsed_header_t);
        for info.members {
            if it.name == {
                case "magic";
                    assert(it.offset_in_bytes == 0, "spv_parsed_header_t.magic has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_header_t.magic has unexpected size % instead of 4", it.type.runtime_size);
                case "version";
                    assert(it.offset_in_bytes == 4, "spv_parsed_header_t.version has unexpected offset % instead of 4", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_header_t.version has unexpected size % instead of 4", it.type.runtime_size);
                case "generator";
                    assert(it.offset_in_bytes == 8, "spv_parsed_header_t.generator has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_header_t.generator has unexpected size % instead of 4", it.type.runtime_size);
                case "bound";
                    assert(it.offset_in_bytes == 12, "spv_parsed_header_t.bound has unexpected offset % instead of 12", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_header_t.bound has unexpected size % instead of 4", it.type.runtime_size);
                case "reserved";
                    assert(it.offset_in_bytes == 16, "spv_parsed_header_t.reserved has unexpected offset % instead of 16", it.offset_in_bytes);
                    assert(it.type.runtime_size == 4, "spv_parsed_header_t.reserved has unexpected size % instead of 4", it.type.runtime_size);
            }
        }
        assert(size_of(spv_parsed_header_t) == 20, "spv_parsed_header_t has size % instead of 20", size_of(spv_parsed_header_t));
    }

    {
        info := type_info(spv_const_binary_t);
        for info.members {
            if it.name == {
                case "code";
                    assert(it.offset_in_bytes == 0, "spv_const_binary_t.code has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_const_binary_t.code has unexpected size % instead of 8", it.type.runtime_size);
                case "wordCount";
                    assert(it.offset_in_bytes == 8, "spv_const_binary_t.wordCount has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_const_binary_t.wordCount has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(spv_const_binary_t) == 16, "spv_const_binary_t has size % instead of 16", size_of(spv_const_binary_t));
    }

    {
        info := type_info(spv_binary_t);
        for info.members {
            if it.name == {
                case "code";
                    assert(it.offset_in_bytes == 0, "spv_binary_t.code has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_binary_t.code has unexpected size % instead of 8", it.type.runtime_size);
                case "wordCount";
                    assert(it.offset_in_bytes == 8, "spv_binary_t.wordCount has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_binary_t.wordCount has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(spv_binary_t) == 16, "spv_binary_t has size % instead of 16", size_of(spv_binary_t));
    }

    {
        info := type_info(spv_text_t);
        for info.members {
            if it.name == {
                case "str";
                    assert(it.offset_in_bytes == 0, "spv_text_t.str has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_text_t.str has unexpected size % instead of 8", it.type.runtime_size);
                case "length";
                    assert(it.offset_in_bytes == 8, "spv_text_t.length has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_text_t.length has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(spv_text_t) == 16, "spv_text_t has size % instead of 16", size_of(spv_text_t));
    }

    {
        info := type_info(spv_position_t);
        for info.members {
            if it.name == {
                case "line";
                    assert(it.offset_in_bytes == 0, "spv_position_t.line has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_position_t.line has unexpected size % instead of 8", it.type.runtime_size);
                case "column";
                    assert(it.offset_in_bytes == 8, "spv_position_t.column has unexpected offset % instead of 8", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_position_t.column has unexpected size % instead of 8", it.type.runtime_size);
                case "index";
                    assert(it.offset_in_bytes == 16, "spv_position_t.index has unexpected offset % instead of 16", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_position_t.index has unexpected size % instead of 8", it.type.runtime_size);
            }
        }
        assert(size_of(spv_position_t) == 24, "spv_position_t has size % instead of 24", size_of(spv_position_t));
    }

    {
        info := type_info(spv_diagnostic_t);
        for info.members {
            if it.name == {
                case "position";
                    assert(it.offset_in_bytes == 0, "spv_diagnostic_t.position has unexpected offset % instead of 0", it.offset_in_bytes);
                    assert(it.type.runtime_size == 24, "spv_diagnostic_t.position has unexpected size % instead of 24", it.type.runtime_size);
                case "error";
                    assert(it.offset_in_bytes == 24, "spv_diagnostic_t.error has unexpected offset % instead of 24", it.offset_in_bytes);
                    assert(it.type.runtime_size == 8, "spv_diagnostic_t.error has unexpected size % instead of 8", it.type.runtime_size);
                case "isTextSource";
                    assert(it.offset_in_bytes == 32, "spv_diagnostic_t.isTextSource has unexpected offset % instead of 32", it.offset_in_bytes);
                    assert(it.type.runtime_size == 1, "spv_diagnostic_t.isTextSource has unexpected size % instead of 1", it.type.runtime_size);
            }
        }
        assert(size_of(spv_diagnostic_t) == 40, "spv_diagnostic_t has size % instead of 40", size_of(spv_diagnostic_t));
    }
}

