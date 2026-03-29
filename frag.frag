#version 460

#extension GL_EXT_buffer_reference : require
#extension GL_EXT_mesh_shader : require
#extension GL_EXT_descriptor_heap: require
#extension GL_EXT_nonuniform_qualifier: require

layout(descriptor_heap) uniform sampler     samplerHeap[];
layout(descriptor_heap) uniform texture2D   imageHeap[];

layout(buffer_reference) buffer FragmentData {
    int samplerIndex;
    int imageIndex;
};

layout(push_constant) uniform PC {
   FragmentData taskData; // i put FragmentData but it stands for void* since there is no void*
   FragmentData meshData; // i put FragmentData but it stands for void* since there is no void*
   FragmentData fragmentData;
};

layout(location = 0) in vec2 vUv;
layout(location = 0) out vec4 fragColor;

void ApilaFS() {
    fragColor = texture(sampler2D(imageHeap[fragmentData.imageIndex], samplerHeap[fragmentData.samplerIndex]), vUv);
}


//
// imagine you have the following available
//
// // in a shared file
// FragmentData :: struct {
//     color: vec4;
// }
//
// // shader code
// ApilaFS :: (data: *FragmentData) -> vec4 {
//     return data.color;
// }
//
// imagine you have something like this:
//      #run CompileShader(#code ApilaFS);
//
// CompileShader uses jai compiler to get the ast and then does the spirv code generation
//
// what i want is pretty much possible but non existent in any programming language as of today
//
