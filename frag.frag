#version 460

#extension GL_EXT_buffer_reference : require
#extension GL_EXT_mesh_shader : require

layout(buffer_reference) buffer FragmentData {
    vec4 color;
};

layout(push_constant) uniform PC {
   FragmentData taskData; // i put FragmentData but it stands for void* since there is no void*
   FragmentData meshData; // i put FragmentData but it stands for void* since there is no void*
   FragmentData fragmentData;
};

layout(location = 0) out vec4 fragColor;

void ApilaFS() {
    fragColor = fragmentData.color;
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
