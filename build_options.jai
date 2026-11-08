// the options of the baking, VulkanJai.SetBuildOptions. loaded by the metaprogram (metaprogram.jai) and the baker (baker.jai)
BuildOptions :: struct {
   optimize:            bool;    // runs spirv-opt on every shader (ApilaSpirv.Optimize)
   validate:            bool;    // runs spirv-val on every shader, the build fails if one is invalid
   spirvOutputFolder:   string;  // if it is set every baked shader is also written there, to look at it with spirv-dis
   spirvOptPath:        string = "spirv-opt";
   spirvValPath:        string = "spirv-val";
}
