//
// a pipeline can be created from spirv, or from the shader procedures themselves (written with ApilaSpirv). their spirv is baked into the executable:
//
//    // shaders.jai
//    #import "ApilaSpirv";
//    ComputeData :: struct { ... }
//    MyShader :: (data: *ComputeData) { ... }
//
//    // main.jai
//    #import "VulkanJai";
//    SHADERS :: #import,file "shaders.jai";
//    pipeline := CreateComputePipeline(SHADERS.MyShader, 64);
//
// the shaders are baked by the metaprogram, so a program that bakes shaders has a build script that imports this module with METAPROGRAM = true
// and gives it every message of the workspace:
//
//    VulkanJai :: #import "VulkanJai"(METAPROGRAM = true);
//    ...
//    while true {
//       message := compiler_wait_for_message();
//       VulkanJai.ProcessMessage(message);
//       ...
//    }
//

#module_parameters (METAPROGRAM := false);

#if METAPROGRAM {
   #load "metaprogram.jai";
} else {
   #load "vulkan.jai";
   #load "baking.jai";
}
