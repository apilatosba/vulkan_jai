#import "osor_vulkan";
#import "Basic";
#import "glfw";
#import "Math";
#import "StableIndexArray";
#import "Hash_Table";
#import "Queue";
Thread :: #import "Thread";
#import "System";
#import "ApilaDispatch";

#if OS == .LINUX {
   #import "POSIX";
}

#scope_file
// i couldn get bindings generator to generate bindings for this function (you need to include vulkan headers and bla bla)
// so i manually add it here
libglfw :: #library "modules/glfw/source/build/src/libglfw";
glfwCreateWindowSurface :: (instance: VkInstance, window: *GLFWwindow, allocator: *VkAllocationCallbacks, surface: *VkSurfaceKHR) -> VkResult #foreign libglfw;
#scope_export

// not all fields has to be filled for each image
// image on gpu
Image :: struct {
   image:         VkImage;
   size:          [3] u32;
   format:        VkFormat;
   view:          VkImageView;   // this image view is the view over the entire image.
                                 // if i need views over individual mip levels for filling the mipmaps
                                 // should i just generate the views on the fly and then destory them.
                                 // idk man. stupid vulkan api. why do we need to create this object but just passing the data as is
                                 // not enough. i have this image view here because for example in swapchain images i need this every frame
                                 // or a sampled image on shader has one thats being reused a lot.
                                 //       - apila, 24/03/26
   arrayLayers:   u32;
   mipLevels:     u32;
   sampleCount:   u32;
   debugName:     string;
}

// this struct is a lil big in size
// almost 1KB
Input :: struct {
   keyboard:   KeyboardState;
   mouse:      MouseState;
}

KeyboardState :: struct {
   keysDown:         [MAX_KEY_COUNT] bool;
   pressedKeys:      [MAX_KEY_COUNT] u8;
   releasedKeys:     [MAX_KEY_COUNT] u8;
   characterQueue:   Queue(u32);

   MAX_KEY_COUNT :: 256;
}

MouseState :: struct {
   position:            Vector2;
   positionLastFrame:   Vector2;
   buttonsDown:         [MAX_BUTTON_COUNT] bool;
   buttonsPressed:      [MAX_BUTTON_COUNT] u8;
   buttonsReleased:     [MAX_BUTTON_COUNT] u8;
   wheel:               float;

   MAX_BUTTON_COUNT :: 16;
}

MouseButton :: enum {
   Button1  :: 0;
   Button2  :: 1;
   Button3  :: 2;
   Button4  :: 3;
   Button5  :: 4;
   Button6  :: 5;
   Button7  :: 6;
   Button8  :: 7;
   Left     :: Button1;
   Right    :: Button2;
   Middle   :: Button3;
}

/// <summary>
/// These are physical keys. these are not characters.
/// the values here corresponds to the key on the us layout.
/// for example KeyboardKey.Q means the key on the top left of the keyboard. doesnt matter what the layout is
/// i created aliases for some keys according to trq layout. they are prefixed with TRQ
/// </summary>
KeyboardKey :: enum {
   Unknown           :: -1;
   Space             :: 32;
   Apostrophe        :: 39;
   Comma             :: 44;
   Minus             :: 45;
   Period            :: 46;
   Slash             :: 47;
   D0                :: 48;
   D1                :: 49;
   D2                :: 50;
   D3                :: 51;
   D4                :: 52;
   D5                :: 53;
   D6                :: 54;
   D7                :: 55;
   D8                :: 56;
   D9                :: 57;
   Semicolon         :: 59;
   Equal             :: 61;
   A                 :: 65;
   B                 :: 66;
   C                 :: 67;
   D                 :: 68;
   E                 :: 69;
   F                 :: 70;
   G                 :: 71;
   H                 :: 72;
   I                 :: 73;
   J                 :: 74;
   K                 :: 75;
   L                 :: 76;
   M                 :: 77;
   N                 :: 78;
   O                 :: 79;
   P                 :: 80;
   Q                 :: 81;
   R                 :: 82;
   S                 :: 83;
   T                 :: 84;
   U                 :: 85;
   V                 :: 86;
   W                 :: 87;
   X                 :: 88;
   Y                 :: 89;
   Z                 :: 90;
   LeftBracket       :: 91;
   Backslash         :: 92;
   RightBracket      :: 93;
   GraveAccent       :: 96;
   World1            :: 161;
   World2            :: 162;
   Escape            :: 256;
   Enter             :: 257;
   Tab               :: 258;
   Backspace         :: 259;
   Insert            :: 260;
   Delete            :: 261;
   Right             :: 262;
   Left              :: 263;
   Down              :: 264;
   Up                :: 265;
   PageUp            :: 266;
   PageDown          :: 267;
   Home              :: 268;
   End               :: 269;
   CapsLock          :: 280;
   ScrollLock        :: 281;
   NumLock           :: 282;
   PrintScreen       :: 283;
   Pause             :: 284;
   F1                :: 290;
   F2                :: 291;
   F3                :: 292;
   F4                :: 293;
   F5                :: 294;
   F6                :: 295;
   F7                :: 296;
   F8                :: 297;
   F9                :: 298;
   F10               :: 299;
   F11               :: 300;
   F12               :: 301;
   F13               :: 302;
   F14               :: 303;
   F15               :: 304;
   F16               :: 305;
   F17               :: 306;
   F18               :: 307;
   F19               :: 308;
   F20               :: 309;
   F21               :: 310;
   F22               :: 311;
   F23               :: 312;
   F24               :: 313;
   F25               :: 314;
   Kp0               :: 320;
   Kp1               :: 321;
   Kp2               :: 322;
   Kp3               :: 323;
   Kp4               :: 324;
   Kp5               :: 325;
   Kp6               :: 326;
   Kp7               :: 327;
   Kp8               :: 328;
   Kp9               :: 329;
   KpDecimal         :: 330;
   KpDivide          :: 331;
   KpMultiply        :: 332;
   KpSubtract        :: 333;
   KpAdd             :: 334;
   KpEnter           :: 335;
   KpEqual           :: 336;
   LeftShift         :: 340;
   LeftControl       :: 341;
   LeftAlt           :: 342;
   LeftSuper         :: 343;
   RightShift        :: 344;
   RightControl      :: 345;
   RightAlt          :: 346;
   RightSuper        :: 347;
   Menu              :: 348;

   // trq equivalents for my own conveinience
   TRQSoftG          :: LeftBracket;
   TRQUe             :: RightBracket;
   TRQSh             :: Semicolon;
   TRQIe             :: Apostrophe;
   TRQComma          :: Backslash;
   TRQOe             :: Comma;
   TRQCh             :: Period;
   TRQDot            :: Slash;
   TRQDenden         :: GraveAccent;
   TRQAngleBracket   :: World1;
}

PolledEventType :: enum {
   None;
   Key;
   MouseButton;
   CursorPosition;
   Scroll;
}

// tagged union
PolledEvent :: struct {
   type: PolledEventType;
   union {
      key: struct {
         action: int;
         key: int;
      }

      mouseButton: struct {
         action: int;
         button: int;
      }

      cursorPosition: Vector2;

      scroll: struct {
         yOffset: float;
      }
   }
}

Int2 :: struct {
   x: int;
   y: int;
}

Window :: struct {
   window:                    *GLFWwindow;
   width:                     int;
   height:                    int;
   title:                     string;
   position:                  Int2;
   polledEventsQueue:         Queue(PolledEvent);
   input:                     Input;
   isFramebufferResized:      bool;
   surface:                   VkSurfaceKHR;

   // swapchain related things
   swapchain:                 VkSwapchainKHR;
   swapchainImages:           [] Image;

   // per frame buffers for the swapchain
   acquireImageSemaphores:    [] VkSemaphore;   // index using cpuFrameTimeline % count
   queueSubmitSemaphores:     [] VkSemaphore;   // index using cpuFrameTimeline % count
   queueSubmitFences:         [] VkFence;       // index using cpuFrameTimeline % count

   cpuFrameTimeline:          int; // incremented by one each frame.
   swapchainImageIndex:       u32; // output of AcquireSwapchainImage
}

VulkanThings :: struct {
   instance:                                    VkInstance;
   physicalDevice:                              VkPhysicalDevice;
   maxMsaaSamples:                              VkSampleCountFlags;
   graphicsQueueFamilyIndexWithPresentSupport:  u32;
   device:                                      VkDevice;
   vmaAllocator:                                VmaAllocator;
   surfaceFormat:                               VkSurfaceFormatKHR;
   presentMode:                                 VkPresentModeKHR;
   commandPools:                                [] CommandPool;   // one pool per thread. thread local storages. 0th index is for the main thread.
                                                                  //
                                                                  // this field is meant to be global but it is fine to keep it here
                                                                  // since the whole struct has only one global instance.
   graphicsQueue:                               VkQueue;    // TODO add a transfer queue if youd like
   graphicsQueueTimelineSemaphore:              Semaphore;
   graphicsQueueSubmitMutex:                    Thread.Mutex;
}

// stores a single VkCommandBuffer and all the command buffers allocated from it
// one instance of this struct is accessed from only one single thread.
// this is meant to be a TLS storage to use with ApilaDispatch
CommandPool :: struct {
   commandPool:   VkCommandPool;
   buffers:       [..] CommandBuffer;
}

CommandBuffer :: struct {
   cmd:                 VkCommandBuffer;
   doneTimelineValue:   u64;  // implicit usage:
                              // when you start recording i set this field to U64_MAX
                              // so that if you start recording again this command buffer will not be picked again
                              // until it finishes executing. i could have created a command buffer state enum or a boolean
                              // "isRecording" but idk man.
                              //       - apila, 26/03/25
}

// if semaphore is binary then value field is ignored
// i have this so i can have a unified struct to use in Submit function
Semaphore :: struct {
   semaphore:  VkSemaphore;
   value:      u64;
}

RenderPassAttachmentInfo :: struct {
   image:            *Image;
   hasClearValue:    bool;
   clearValue:       struct {
                        color:      Vector4;
                        depth:      float32;
                        stencil:    u32;
                     };
   imageView:        VkImageView; // if set overrides image.imageView
   resolveImageView: VkImageView; // if null then no resolve
}

RenderPassDescription :: struct {
   colorTargets:        [] RenderPassAttachmentInfo;
   hasDepthTarget:      bool;
   depthTarget:         RenderPassAttachmentInfo;
   hasStencilTarget:    bool;
   stencilTarget:       RenderPassAttachmentInfo;
}

// globals
vk:                     VulkanThings;
glfwWindowToWindow:     Table(*GLFWwindow, StableIndexArrayHandle); // index into "windows" array
windows:                StableIndexArray(Window); // this array owns the windows

//
// BUG:
// there is a bug when resizing window it stops rendering and weird glitches happen.
// also sometimes after resizing it doesnt go back to normal and i have to resize again to make it go normal.
// i guess the issue is 100% related to how i recreate swapchain
//

main :: () {
   InitializeThreads();
   windowIndex := InitializeVulkanAndWindow();

   window := Get(*windows, windowIndex);
   while (!glfwWindowShouldClose(window.window)) {
      defer window = Get(*windows, windowIndex);

      AcquireSwapchainImage(window);
      glfwPollEvents();

      cmd := StartCommandRecording();

      timeSinceStart: float = xx glfwGetTime();

      renderPassDescription: RenderPassDescription = .{
         colorTargets = .[
            .{
               image = *window.swapchainImages[window.swapchainImageIndex],
               hasClearValue = true,
               clearValue = .{
                  color = .{ sin(10 * timeSinceStart), sin(20 * timeSinceStart), sin(30 * timeSinceStart), 1 }
               },
            },
         ],
         hasDepthTarget = false,
         hasStencilTarget = false,
      };

      BeginRenderPass(cmd, renderPassDescription);
      EndRenderPass(cmd);

      SubmitAndPresent(cmd, window);
   }
}

GetImageViewFromRenderPassAttachmentInfo :: (info: RenderPassAttachmentInfo) -> VkImageView {
   return ifx info.imageView != null then info.imageView else info.image.view;
}

Vector4ToVkClearColorValue :: (v: Vector4) -> VkClearColorValue {
   result: VkClearColorValue;
   result.float32_ = .[v.x, v.y, v.z, v.w];
   return result;
}

BeginRenderPass :: (cmd: *CommandBuffer, description: RenderPassDescription) {
   assert(description.colorTargets.count > 0, "description.colorTargets.count: %", description.colorTargets.count);
   assert(!description.hasStencilTarget, "stencil not implemented");

   colorAttachmentInfos := NewArray(description.colorTargets.count, VkRenderingAttachmentInfo,, temp);
   for 0..description.colorTargets.count - 1 {
      colorAttachmentInfos[it] = .{
         sType = VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO,
         pNext = null,
         clearValue = ifx description.colorTargets[it].hasClearValue then .{
            color = Vector4ToVkClearColorValue(description.colorTargets[it].clearValue.color),
         } else VkClearValue.{ color = .{ float32_ = .[1, 0, 1, 1] } },
         loadOp = ifx description.colorTargets[it].hasClearValue then VK_ATTACHMENT_LOAD_OP_CLEAR else VK_ATTACHMENT_LOAD_OP_LOAD,
         storeOp = VK_ATTACHMENT_STORE_OP_STORE,
         imageLayout = VK_IMAGE_LAYOUT_GENERAL,
         imageView = GetImageViewFromRenderPassAttachmentInfo(description.colorTargets[it]),
         resolveMode = ifx description.colorTargets[it].resolveImageView != null then VK_RESOLVE_MODE_AVERAGE_BIT else VK_RESOLVE_MODE_NONE,
         resolveImageLayout = ifx description.colorTargets[it].resolveImageView != null then VK_IMAGE_LAYOUT_GENERAL else 0,
         resolveImageView = description.colorTargets[it].resolveImageView,
      };
   }

   depthAttachmentInfo: VkRenderingAttachmentInfo = .{
      sType = VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO,
      pNext = null,
      clearValue = ifx description.depthTarget.hasClearValue then .{
         depthStencil = .{ description.depthTarget.clearValue.depth, description.depthTarget.clearValue.stencil }
      } else VkClearValue.{ depthStencil = .{ 1, 0 } } ,
      loadOp = ifx description.depthTarget.hasClearValue then VK_ATTACHMENT_LOAD_OP_CLEAR else VK_ATTACHMENT_LOAD_OP_LOAD,
      storeOp = VK_ATTACHMENT_STORE_OP_STORE,
      imageLayout = VK_IMAGE_LAYOUT_GENERAL,
      imageView = ifx description.hasDepthTarget then GetImageViewFromRenderPassAttachmentInfo(description.depthTarget) else null,
   };

   // is this is wrong? if the imageView targets a mip level then what?
   // then i think i need to use the extent of the mip level
   renderAreaWidth := description.colorTargets[0].image.size[0];
   renderAreaHeight := description.colorTargets[0].image.size[1];

   renderingInfo: VkRenderingInfo = .{
      sType = VK_STRUCTURE_TYPE_RENDERING_INFO,
      pNext = null,
      colorAttachmentCount = xx colorAttachmentInfos.count,
      pColorAttachments = colorAttachmentInfos.data,
      pDepthAttachment = *depthAttachmentInfo,
      renderArea = .{
         offset = .{ 0, 0 },
         extent = .{ renderAreaWidth, renderAreaHeight },
      },
      layerCount = 1,
      pStencilAttachment = null,
   };

   vkCmdBeginRendering(cmd.cmd, *renderingInfo);

   scissor: VkRect2D = .{ .{ 0, 0 }, .{ renderAreaWidth, renderAreaHeight } };
   vkCmdSetScissorWithCountEXT(cmd.cmd, 1, *scissor);

   viewport: VkViewport = .{ 0, xx renderAreaHeight, xx renderAreaWidth, -cast(float) renderAreaHeight, 0, 1 };
   vkCmdSetViewport(cmd.cmd, 0, 1, *viewport);
   vkCmdSetViewportWithCountEXT(cmd.cmd, 1, *viewport);

   colorWriteMask := NewArray(description.colorTargets.count, VkColorComponentFlags,, temp);
   for 0..colorWriteMask.count - 1 {
      colorWriteMask[it] = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
   }
   vkCmdSetColorWriteMaskEXT(cmd.cmd, 0, xx colorWriteMask.count, colorWriteMask.data);

   rasterizationSamples := description.colorTargets[0].image.sampleCount;
   vkCmdSetRasterizationSamplesEXT(cmd.cmd, xx rasterizationSamples);

   sampleMask := u32.[U32_MAX, U32_MAX];
   vkCmdSetSampleMaskEXT(cmd.cmd, xx rasterizationSamples, sampleMask.data);
}

EndRenderPass :: (cmd: *CommandBuffer) {
   vkCmdEndRendering(cmd.cmd);
}

// outputs to window.swapchainImageIndex
AcquireSwapchainImage :: (window: *Window) {
   window.cpuFrameTimeline += 1;

   //
   // the frameIndex calculated in Present must be the same as this one
   // meaning that window.cpuFrameTimeline must be the same across the frame
   // which means that i need to either increment window.cpuFrameTimeline at the start
   // or at the end of the frame. right now i do it at the start of the frame in this function
   //

   frameIndex := window.cpuFrameTimeline % window.acquireImageSemaphores.count;
   swapchainImageIndex: u32;

   vkResult := vkWaitForFences(vk.device, 1, *window.queueSubmitFences[frameIndex], xx true, U64_MAX);
   assert(vkResult == VK_SUCCESS);

   while (true) {
      acquireImageResult := vkAcquireNextImageKHR(
         vk.device,
         window.swapchain,
         U64_MAX,
         window.acquireImageSemaphores[frameIndex],
         null,
         *swapchainImageIndex
      );

      if (acquireImageResult == VK_ERROR_OUT_OF_DATE_KHR) {
         RecreateSwapchain(window);
         continue;
      } else {
         assert(acquireImageResult == VK_SUCCESS);
      }

      break;
   }

   vkResult = vkResetFences(vk.device, 1, *window.queueSubmitFences[frameIndex]);
   assert(vkResult == VK_SUCCESS);

   window.swapchainImageIndex = swapchainImageIndex;

   // transition layout to general
   {
      cmd := StartCommandRecording();
      defer Submit(cmd);

      barrier: VkImageMemoryBarrier2 = .{
         sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER_2,
         pNext = null,
         oldLayout = VK_IMAGE_LAYOUT_UNDEFINED,
         newLayout = VK_IMAGE_LAYOUT_GENERAL,
         srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
         dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
         image = window.swapchainImages[window.swapchainImageIndex].image,
         subresourceRange = .{
            aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1
         },
         srcAccessMask = VK_ACCESS_2_NONE,
         srcStageMask = VK_PIPELINE_STAGE_2_NONE,
         dstAccessMask = VK_ACCESS_2_MEMORY_READ_BIT | VK_ACCESS_2_MEMORY_WRITE_BIT,
         dstStageMask = VK_PIPELINE_STAGE_2_COLOR_ATTACHMENT_OUTPUT_BIT | VK_PIPELINE_STAGE_2_TRANSFER_BIT,
      };

      dependencyInfo: VkDependencyInfo = .{
         sType = VK_STRUCTURE_TYPE_DEPENDENCY_INFO,
         pNext = null,
         imageMemoryBarrierCount = 1,
         pImageMemoryBarriers = *barrier
      };

      vkCmdPipelineBarrier2(cmd.cmd, *dependencyInfo);
   }
}

StartCommandRecording :: () -> *CommandBuffer {
   commandPool := *vk.commandPools[context.thread_index];

   // get an available command buffer
   gpuSemaphoreTime: u64;
   vkResult := vkGetSemaphoreCounterValue(vk.device, vk.graphicsQueueTimelineSemaphore.semaphore, *gpuSemaphoreTime);
   assert(vkResult == VK_SUCCESS);
   commandBuffer: *CommandBuffer = null;
   for * cmd: commandPool.buffers {
      if (gpuSemaphoreTime >= cmd.doneTimelineValue) {
         commandBuffer = cmd;
         break;
      }
   }

   // allocate a new command buffer since all of them are busy
   if (commandBuffer == null) {
      commandBuffer = array_add(*commandPool.buffers);

      allocateInfo: VkCommandBufferAllocateInfo = .{
         sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
         pNext = null,
         commandPool = commandPool.commandPool,
         level = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
         commandBufferCount = 1,
      };

      vkResult = vkAllocateCommandBuffers(vk.device, *allocateInfo, *commandBuffer.cmd);
      assert(vkResult == VK_SUCCESS);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_COMMAND_BUFFER, xx commandBuffer.cmd, tprint("vk.commandPools[%].buffers[%] command buffer", context.thread_index, commandPool.buffers.count - 1));
   }

   beginInfo: VkCommandBufferBeginInfo = .{
      sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
      pNext = null,
      flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
      pInheritanceInfo = null,
   };

   vkResult = vkBeginCommandBuffer(commandBuffer.cmd, *beginInfo);
   assert(vkResult == VK_SUCCESS);

   commandBuffer.doneTimelineValue = U64_MAX;

   return commandBuffer;
}

// whatever AcquireSwapchainImage returned is presented
// you should call AcquireSwapchainImage then this function in order.
// you shouldnt call one of them one more than once without calling the other
// there is no checks for this but it is hard to mess this up since you set up your main loop once
//
// ugly as design
// but this ugly ass design comes from the ugly ass design of vulkan swapchain and their special
// synchronization designs. so it is okay
SubmitAndPresent :: (cmd: *CommandBuffer, window: *Window) {
   frameIndex := window.cpuFrameTimeline % window.swapchainImages.count;

   // transition layout to present
   {
      barrier: VkImageMemoryBarrier2 = .{
         sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER_2,
         pNext = null,
         oldLayout = VK_IMAGE_LAYOUT_GENERAL,
         newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
         srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
         dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
         image = window.swapchainImages[window.swapchainImageIndex].image,
         subresourceRange = .{
            aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1
         },
         srcAccessMask = VK_ACCESS_2_MEMORY_WRITE_BIT,
         srcStageMask = VK_PIPELINE_STAGE_2_COLOR_ATTACHMENT_OUTPUT_BIT | VK_PIPELINE_STAGE_2_TRANSFER_BIT,
         dstAccessMask = VK_ACCESS_2_NONE,
         dstStageMask = VK_PIPELINE_STAGE_2_NONE,
      };

      dependencyInfo: VkDependencyInfo = .{
         sType = VK_STRUCTURE_TYPE_DEPENDENCY_INFO,
         pNext = null,
         imageMemoryBarrierCount = 1,
         pImageMemoryBarriers = *barrier
      };

      vkCmdPipelineBarrier2(cmd.cmd, *dependencyInfo);
   }

   Submit(
      cmd,
      waitSemaphores = .[.{window.acquireImageSemaphores[frameIndex], 0 /* ignored for binary semaphores */}],
      signalSemaphores = .[.{window.queueSubmitSemaphores[frameIndex], 0 /* ignored for binary semaphores */}],
      fence = window.queueSubmitFences[frameIndex]
   );

   presentInfo: VkPresentInfoKHR = .{
      sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,
      pNext = null,
      waitSemaphoreCount = 1,
      pWaitSemaphores = *window.queueSubmitSemaphores[frameIndex],
      swapchainCount = 1,
      pSwapchains = *window.swapchain,
      pImageIndices = *window.swapchainImageIndex,
   };

   vkQueuePresentKHRResult := vkQueuePresentKHR(vk.graphicsQueue, *presentInfo);

   if (vkQueuePresentKHRResult == VK_ERROR_OUT_OF_DATE_KHR || vkQueuePresentKHRResult == VK_SUBOPTIMAL_KHR || window.isFramebufferResized) {
      RecreateSwapchain(window);
      window.isFramebufferResized = false;
   } else {
      assert(vkQueuePresentKHRResult == VK_SUCCESS);
   }
}

// every time you submit, the timeline semaphore is incremented
// so if the counter reaches the value you submitted then it means that operations is done
// so you can know which command buffers are finished executing.
// store their signal value and if the counter exceeds that value then you are free to destroy/reset/reuse that command buffer
Submit :: (cmd: *CommandBuffer, waitSemaphores: [] Semaphore = .{}, signalSemaphores: [] Semaphore = .{}, fence: VkFence = null) {
   vkResult := vkEndCommandBuffer(cmd.cmd);
   assert(vkResult == VK_SUCCESS);

   Thread.lock(*vk.graphicsQueueSubmitMutex);
   defer Thread.unlock(*vk.graphicsQueueSubmitMutex);

   vk.graphicsQueueTimelineSemaphore.value += 1;
   cmd.doneTimelineValue = vk.graphicsQueueTimelineSemaphore.value;

   commandBufferSubmitInfo: VkCommandBufferSubmitInfo = .{
      sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_SUBMIT_INFO,
      pNext = null,
      commandBuffer = cmd.cmd,
   };

   signalSemaphoreSubmitInfos := NewArray(signalSemaphores.count + 1, VkSemaphoreSubmitInfo,, temp);
   // the queue timeline semaphore is always there
   signalSemaphoreSubmitInfos[0] = .{
      sType = VK_STRUCTURE_TYPE_SEMAPHORE_SUBMIT_INFO,
      pNext = null,
      semaphore = vk.graphicsQueueTimelineSemaphore.semaphore,
      value = cmd.doneTimelineValue,
      stageMask = VK_PIPELINE_STAGE_2_ALL_COMMANDS_BIT, // idk what i do
   };

   for 1..signalSemaphores.count {
      signalSemaphoreSubmitInfos[it] = .{
         sType = VK_STRUCTURE_TYPE_SEMAPHORE_SUBMIT_INFO,
         pNext = null,
         semaphore = signalSemaphores[it - 1].semaphore,
         value = signalSemaphores[it - 1].value,
      };
   };

   waitSemaphoreSubmitInfos := NewArray(waitSemaphores.count, VkSemaphoreSubmitInfo,, temp);
   for 0..waitSemaphoreSubmitInfos.count - 1 {
      waitSemaphoreSubmitInfos[it] = .{
         sType = VK_STRUCTURE_TYPE_SEMAPHORE_SUBMIT_INFO,
         pNext = null,
         semaphore = waitSemaphores[it].semaphore,
         value = waitSemaphores[it].value,
      };
   };

   submitInfo2: VkSubmitInfo2 = .{
      sType = VK_STRUCTURE_TYPE_SUBMIT_INFO_2,
      pNext = null,
      commandBufferInfoCount = 1,
      pCommandBufferInfos = *commandBufferSubmitInfo,
      signalSemaphoreInfoCount = xx signalSemaphoreSubmitInfos.count,
      pSignalSemaphoreInfos = signalSemaphoreSubmitInfos.data,
      waitSemaphoreInfoCount = xx waitSemaphoreSubmitInfos.count,
      pWaitSemaphoreInfos = waitSemaphoreSubmitInfos.data,
   };

   vkResult = vkQueueSubmit2(vk.graphicsQueue, 1, *submitInfo2, fence);
   assert(vkResult == VK_SUCCESS);
}

InitializeVulkanAndWindow :: () -> indexIntoGlobalWindowsArray: StableIndexArrayHandle {
   #if OS == .LINUX {
      vulkan := dlopen("libvulkan.so.1", RTLD_LAZY);
      assert(vulkan != null);
      load_vulkan_loader_procedures(vulkan, dlsym);
   } else {
      #assert false;
   }

   assert(IsValidationLayerSupported());

   if (glfwInit() == 0) {
      print("failed to initialize glfw\n");
      exit(69);
   }

   glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
   // cant inline because of #c_call
   GlfwErrorCallback :: (errorCode: s32, description: *u8) #c_call {
      push_context {
         print("GLFW Error: % - %", errorCode, to_string(description));
      }
   }
   glfwSetErrorCallback(GlfwErrorCallback);
   glfwGetRequiredInstanceExtensionsCount: u32;
   requiredExtensionsByGlfw: **u8 = glfwGetRequiredInstanceExtensions(*glfwGetRequiredInstanceExtensionsCount);

   applicationInfo: VkApplicationInfo = .{
      sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
      pNext = null,
      pApplicationName = "Apila Game 10",
      applicationVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      pEngineName = "Apila Engine 4",
      engineVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      apiVersion = VK_MAKE_API_VERSION(0, 1, 4, 0),
   };

   instanceExtensionsToEnable := NewArray(glfwGetRequiredInstanceExtensionsCount + 1, *u8,, temp);
   instanceExtensionsToEnable[0] = to_c_string(VK_EXT_DEBUG_UTILS_EXTENSION_NAME,, temp);
   for 1..glfwGetRequiredInstanceExtensionsCount {
      instanceExtensionsToEnable[it] = requiredExtensionsByGlfw[it - 1];
   }

   layersToEnable := *u8.["VK_LAYER_KHRONOS_validation\0"];
   instanceCreateInfo: VkInstanceCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      pNext = null,
      pApplicationInfo = *applicationInfo,
      enabledExtensionCount = xx instanceExtensionsToEnable.count,
      ppEnabledExtensionNames = instanceExtensionsToEnable.data,
      enabledLayerCount = layersToEnable.count,
      ppEnabledLayerNames = layersToEnable.data,
   };

   vkResult := vkCreateInstance(*instanceCreateInfo, null, *vk.instance);
   assert(vkResult == VK_SUCCESS);

   load_vulkan_instance_procedures(vk.instance);

   vk.physicalDevice = ChoosePhysicalDevice(vk.instance);
   physicalDeviceProperties: VkPhysicalDeviceProperties;
   physicalDeviceFeatures: VkPhysicalDeviceFeatures;
   vkGetPhysicalDeviceProperties(vk.physicalDevice, *physicalDeviceProperties);
   vkGetPhysicalDeviceFeatures(vk.physicalDevice, *physicalDeviceFeatures);
   print("Selected physical device: %\n", to_string(physicalDeviceProperties.deviceName.data));
   print("API version: %\n", VkVersionToString(physicalDeviceProperties.apiVersion,, temp));
   maxMsaaSamples := GetMaxSupportedMsaaSamples(physicalDeviceProperties);
   vk.maxMsaaSamples = maxMsaaSamples;

   deviceExtensionProperties: [] VkExtensionProperties;
   vkResult = vkEnumerateDeviceExtensionProperties(vk.physicalDevice, "", xx *deviceExtensionProperties.count, null);
   assert(vkResult == VK_SUCCESS);

   deviceExtensionProperties.data = temporary_alloc(deviceExtensionProperties.count * size_of(VkExtensionProperties)); // cant allocate on stack. jai doesnt support it
   vkResult = vkEnumerateDeviceExtensionProperties(vk.physicalDevice, "", xx *deviceExtensionProperties.count, deviceExtensionProperties.data);
   assert(vkResult == VK_SUCCESS);

   deviceExtensionsToEnable := *u8.[
      to_c_string(VK_KHR_SWAPCHAIN_EXTENSION_NAME,, temp),
      to_c_string(VK_KHR_8BIT_STORAGE_EXTENSION_NAME,, temp),
      to_c_string(VK_KHR_PUSH_DESCRIPTOR_EXTENSION_NAME,, temp),
      to_c_string(VK_EXT_MESH_SHADER_EXTENSION_NAME,, temp),
      to_c_string(VK_EXT_EXTENDED_DYNAMIC_STATE_3_EXTENSION_NAME,, temp),
      to_c_string(VK_EXT_SHADER_OBJECT_EXTENSION_NAME,, temp),
      // VK_KHR_DYNAMIC_RENDERING_EXTENSION_NAME // promoted to core in 1.3
   ];

   for deviceExtensionToEnable: deviceExtensionsToEnable {
      found := false;
      for deviceExtensionProperty: deviceExtensionProperties {
         if (to_string(deviceExtensionToEnable) == to_string(deviceExtensionProperty.extensionName.data)) {
            found = true;
            break;
         }
      }

      assert(found, "Device extension % not found in the selected device %\n", to_string(deviceExtensionToEnable), to_string(physicalDeviceProperties.deviceName.data));
   }

   vk.graphicsQueueFamilyIndexWithPresentSupport = U32_MAX;
   queueFamilyCount: u32 = 0;
   vkGetPhysicalDeviceQueueFamilyProperties(vk.physicalDevice, *queueFamilyCount, null);
   queueFamilyProperties: [] VkQueueFamilyProperties;
   queueFamilyProperties.count = queueFamilyCount;
   queueFamilyProperties.data = temporary_alloc(queueFamilyCount * size_of(VkQueueFamilyProperties)); // jai doesnt allow to allocate on the stack
   vkGetPhysicalDeviceQueueFamilyProperties(vk.physicalDevice, *queueFamilyCount, queueFamilyProperties.data);

   window, windowIndex := CreateWindowThePartBeforeDeviceCreation(640, 480, "kayu4");

   for 0..queueFamilyCount - 1 {
      graphicsSupport := false;
      presentSupport: VkBool32 = xx false;
      vkResult = vkGetPhysicalDeviceSurfaceSupportKHR(vk.physicalDevice, cast(u32)it, window.surface, *presentSupport);
      assert(vkResult == VK_SUCCESS);

      queueFamily: VkQueueFamilyProperties = queueFamilyProperties[it];

      if ((queueFamily.queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0) {
         vk.graphicsQueueFamilyIndexWithPresentSupport = cast(u32) it;
         graphicsSupport = true;
      }

      if (graphicsSupport && presentSupport) {
         break;
      }

      if (it == queueFamilyCount - 1) {
         assert(false, "Failed to find a suitable queue family!");
      }
   }

   queuePriority := 1.0;
   deviceQueueCreateInfo: VkDeviceQueueCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      pNext = null,
      queueFamilyIndex = vk.graphicsQueueFamilyIndexWithPresentSupport,
      queueCount = 1,
      pQueuePriorities = *queuePriority,
   };

   deviceFeaturesToEnable: VkPhysicalDeviceFeatures = .{
      fillModeNonSolid = xx true,
      samplerAnisotropy = xx true,
      depthClamp = xx true,
   };

   shaderObjectFeaturesExt: VkPhysicalDeviceShaderObjectFeaturesEXT = .{
      sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_OBJECT_FEATURES_EXT,
      pNext = null,
      shaderObject = xx true,
   };

   extendedDynamicState3Features: VkPhysicalDeviceExtendedDynamicState3FeaturesEXT = .{
      sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_3_FEATURES_EXT,
      pNext = *shaderObjectFeaturesExt,
      extendedDynamicState3PolygonMode = xx true,
      extendedDynamicState3ColorBlendEnable = xx true,
      extendedDynamicState3ColorBlendEquation = xx true,
      extendedDynamicState3DepthClampEnable = xx true,
      // extendedDynamicState3RasterizationSamples = true, // bugged out
      // extendedDynamicState3SampleMask = true,           // bugged out
   };

   meshShaderFeatures: VkPhysicalDeviceMeshShaderFeaturesEXT = .{
      sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_EXT,
      pNext = *extendedDynamicState3Features,
      meshShader = xx true,
      taskShader = xx true,
   };

   vulkan13Features: VkPhysicalDeviceVulkan13Features = .{
      sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_FEATURES,
      pNext = *meshShaderFeatures,
      dynamicRendering = xx true,
      synchronization2 = xx true,
      maintenance4 = xx true, // stupidass compiler optimizations
   };

   vulkan12Features: VkPhysicalDeviceVulkan12Features = .{
      sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_2_FEATURES,
      pNext = *vulkan13Features,
      // descriptorIndexing = true,
      storageBuffer8BitAccess = xx true,
      timelineSemaphore = xx true,
   };

   deviceCreateInfo: VkDeviceCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      pNext = *vulkan12Features,
      pQueueCreateInfos = *deviceQueueCreateInfo,
      queueCreateInfoCount = 1,
      pEnabledFeatures = *deviceFeaturesToEnable,
      enabledLayerCount = layersToEnable.count,
      ppEnabledLayerNames = layersToEnable.data,
      enabledExtensionCount = deviceExtensionsToEnable.count,
      ppEnabledExtensionNames = deviceExtensionsToEnable.data,
   };

   vkResult = vkCreateDevice(vk.physicalDevice, *deviceCreateInfo, null, *vk.device);
   assert(vkResult == VK_SUCCESS);
   load_vulkan_device_procedures(vk.device);
   VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_DEVICE, xx vk.device, "ApilaVkDevice");

   vkGetDeviceQueue(vk.device, vk.graphicsQueueFamilyIndexWithPresentSupport, 0, *vk.graphicsQueue);
   VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_QUEUE, xx vk.graphicsQueue, "vk.graphicsQueue");
   vk.graphicsQueueTimelineSemaphore = CreateTimelineSemaphore(debugName = "vk.graphicsQueueTimelineSemaphore");
   Thread.init(*vk.graphicsQueueSubmitMutex);

   vulkanFunctions: VmaVulkanFunctions = .{
      vkGetInstanceProcAddr = vkGetInstanceProcAddr,
      vkGetDeviceProcAddr = vkGetDeviceProcAddr,
      vkGetPhysicalDeviceProperties = vkGetPhysicalDeviceProperties,
      vkGetPhysicalDeviceMemoryProperties = vkGetPhysicalDeviceMemoryProperties,
      vkAllocateMemory = vkAllocateMemory,
      vkFreeMemory = vkFreeMemory,
      vkMapMemory = vkMapMemory,
      vkUnmapMemory = vkUnmapMemory,
      vkFlushMappedMemoryRanges = vkFlushMappedMemoryRanges,
      vkInvalidateMappedMemoryRanges = vkInvalidateMappedMemoryRanges,
      vkBindBufferMemory = vkBindBufferMemory,
      vkBindImageMemory = vkBindImageMemory,
      vkGetBufferMemoryRequirements = vkGetBufferMemoryRequirements,
      vkGetImageMemoryRequirements = vkGetImageMemoryRequirements,
      vkCreateBuffer = vkCreateBuffer,
      vkDestroyBuffer = vkDestroyBuffer,
      vkCreateImage = vkCreateImage,
      vkDestroyImage = vkDestroyImage,
      vkCmdCopyBuffer = vkCmdCopyBuffer,
      vkGetBufferMemoryRequirements2KHR = vkGetBufferMemoryRequirements2KHR,
      vkGetImageMemoryRequirements2KHR = vkGetImageMemoryRequirements2KHR,
      vkBindBufferMemory2KHR = vkBindBufferMemory2KHR,
      vkBindImageMemory2KHR = vkBindImageMemory2KHR,
      vkGetPhysicalDeviceMemoryProperties2KHR = vkGetPhysicalDeviceMemoryProperties2KHR,
      vkGetDeviceBufferMemoryRequirements = vkGetDeviceBufferMemoryRequirements,
      vkGetDeviceImageMemoryRequirements = vkGetDeviceImageMemoryRequirements,
      // vkGetMemoryWin32HandleKHR = vkGetMemoryWin32HandleKHR,
   };

   vmaAllocatorCreateInfo: VmaAllocatorCreateInfo = .{
      physicalDevice = vk.physicalDevice,
      device = vk.device,
      instance = vk.instance,
      flags = xx VmaAllocatorCreateFlagBits.KHR_MAINTENANCE4_BIT,
      vulkanApiVersion = physicalDeviceProperties.apiVersion,
      pVulkanFunctions = *vulkanFunctions,
   };

   vkResult = vmaCreateAllocator(*vmaAllocatorCreateInfo, *vk.vmaAllocator);
   assert(vkResult == VK_SUCCESS);

   formatCount: u32;
   vkResult = vkGetPhysicalDeviceSurfaceFormatsKHR(vk.physicalDevice, window.surface, *formatCount, null);
   assert(vkResult == VK_SUCCESS);
   surfaceFormats: [] VkSurfaceFormatKHR;
   surfaceFormats.count = formatCount;
   surfaceFormats.data = temporary_alloc(formatCount * size_of(VkSurfaceFormatKHR));

   // these are the all available formats in my machine
   // surface format: B8G8R8A8Unorm, SrgbNonLinear
   // surface format: B8G8R8A8Srgb, SrgbNonLinear
   if (formatCount != 0) {
      vkResult = vkGetPhysicalDeviceSurfaceFormatsKHR(vk.physicalDevice, window.surface, *formatCount, surfaceFormats.data);
      assert(vkResult == VK_SUCCESS);
   }

   presentModeCount: u32;
   vkResult = vkGetPhysicalDeviceSurfacePresentModesKHR(vk.physicalDevice, window.surface, *presentModeCount, null);
   assert(vkResult == VK_SUCCESS);
   presentModes: [] VkPresentModeKHR;
   presentModes.count = presentModeCount;
   presentModes.data = temporary_alloc(presentModeCount * size_of(VkPresentModeKHR));

   if (presentModeCount != 0) {
      vkResult = vkGetPhysicalDeviceSurfacePresentModesKHR(vk.physicalDevice, window.surface, *presentModeCount, presentModes.data);
      assert(vkResult == VK_SUCCESS);
   }

   isSwapChainAdequate: bool = surfaceFormats.count != 0 && presentModes.count != 0;
   assert(isSwapChainAdequate, "Swapchain is not adequate");

   vk.surfaceFormat = ChooseSwapSurfaceFormat(surfaceFormats);
   vk.presentMode = ChooseSwapPresentMode(presentModes);

   vk.commandPools = NewArray(threadCount, CommandPool);
   for 0..threadCount - 1 {
      vk.commandPools[it].commandPool = CreateCommandPool(vk.graphicsQueueFamilyIndexWithPresentSupport);
   }

   CreateSwapchain(window);

   return windowIndex;
}

CreateTimelineSemaphore :: (initialValue: u64 = 0, debugName := "") -> Semaphore {
   typeCreateInfo: VkSemaphoreTypeCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_SEMAPHORE_TYPE_CREATE_INFO,
      pNext = null,
      semaphoreType = VK_SEMAPHORE_TYPE_TIMELINE,
      initialValue = initialValue,
   };

   createInfo: VkSemaphoreCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
      pNext = *typeCreateInfo,
   };

   timelineSemaphore: VkSemaphore;
   vkResult := vkCreateSemaphore(vk.device, *createInfo, null, *timelineSemaphore);
   assert(vkResult == VK_SUCCESS);
   if (debugName.count > 0) {
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_SEMAPHORE, xx xx timelineSemaphore, debugName);
   }

   return .{
      timelineSemaphore,
      initialValue
   };
}

CreateCommandPool :: (queueFamilyIndex: u32) -> VkCommandPool {
   assert(vk.device != null);

   poolInfo: VkCommandPoolCreateInfo = .{
      sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
      pNext = null,
      flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
      queueFamilyIndex = queueFamilyIndex,
   };

   result: VkCommandPool;
   vkResult := vkCreateCommandPool(vk.device, *poolInfo, null, *result);
   assert(vkResult == VK_SUCCESS);

   return result;
}

ChooseSwapPresentMode :: (availablePresentModes: [] VkPresentModeKHR) -> VkPresentModeKHR {
   // i made this up. dont know what to pick
   presentModePreference := VkPresentModeKHR.[
      .VK_PRESENT_MODE_FIFO_KHR,
      .VK_PRESENT_MODE_FIFO_RELAXED_KHR,
      .VK_PRESENT_MODE_MAILBOX_KHR,
      .VK_PRESENT_MODE_IMMEDIATE_KHR
   ];

   for preferredMode: presentModePreference {
      if (array_find(availablePresentModes, preferredMode)) {
         return preferredMode;
      }
   }

   assert(false, "No preferred present mode found");
   return 0;
}

ChooseSwapSurfaceFormat :: (surfaceFormats: [] VkSurfaceFormatKHR) -> VkSurfaceFormatKHR {
   for availableFormat: surfaceFormats {
      if (availableFormat.format == .VK_FORMAT_B8G8R8A8_SRGB && availableFormat.colorSpace == .VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
         return availableFormat;
      }
   }

   return surfaceFormats[0];
}

// convenient overload
VkSetDebugUtilsObjectNameExt :: (device: VkDevice, objectType: VkObjectType, handle: u64, label: string) -> VkResult {
   info: VkDebugUtilsObjectNameInfoEXT = .{
      sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT,
      pNext = null,
      objectType = objectType,
      objectHandle = handle,
      pObjectName = to_c_string(label,, temp)
   };

   return vkSetDebugUtilsObjectNameEXT(device, *info);
}

ChooseSwapExtent :: (capabilities: VkSurfaceCapabilitiesKHR, window: *GLFWwindow) -> VkExtent2D {
   if (capabilities.currentExtent.width != U32_MAX) {
      return capabilities.currentExtent;
   } else {
      result: VkExtent2D;
      width: s32;
      height: s32;
      glfwGetFramebufferSize(window, *width, *height);

      result = .{
         width = xx width,
         height = xx height
      };

      result.width = clamp(result.width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
      result.height = clamp(result.height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);

      return result;
   }
}

GetMinImageCountToRequestInSwapchainCreation :: (surfaceCapabilities: VkSurfaceCapabilitiesKHR) -> u32 {
   minImageCount: u32 = surfaceCapabilities.minImageCount;
   maxImageCount: u32 = surfaceCapabilities.maxImageCount;

   imageCount: u32;
   imageCount = minImageCount + 1;
   if (maxImageCount > 0 && imageCount > maxImageCount) {
      imageCount = maxImageCount;
   }

   return imageCount;
}

RecreateSwapchain :: (window: *Window) {
   vkResult := vkDeviceWaitIdle(vk.device);
   assert(vkResult == VK_SUCCESS);
   DestroySwapchain(window);
   CreateSwapchain(window);
}

DestroySwapchain :: (window: *Window) {
   for 0..window.swapchainImages.count - 1 {
      vkDestroyImageView(vk.device, window.swapchainImages[it].view, null);
      vkDestroySemaphore(vk.device, window.acquireImageSemaphores[it], null);
      vkDestroySemaphore(vk.device, window.queueSubmitSemaphores[it], null);
      vkDestroyFence(vk.device, window.queueSubmitFences[it], null);
   }

   vkDestroySwapchainKHR(vk.device, window.swapchain, null);

   free(window.swapchainImages.data);
   free(window.acquireImageSemaphores.data);
   free(window.queueSubmitSemaphores.data);
   free(window.queueSubmitFences.data);
}

CreateWindow :: (width: int, height: int, title: string) -> resultPtrButNotStableIfUnderlyingArrayResizes: *Window, indexIntoGlobalWindowsArray: StableIndexArrayHandle {
   windowPtr, windowIndex := CreateWindowThePartBeforeDeviceCreation(width, height, title);
   CreateSwapchain(windowPtr);
   return windowPtr, windowIndex;
}

// outputs to window.swapchain
CreateSwapchain :: (window: *Window) {
   assert(window != null);
   assert(window.window != null);
   assert(window.surface != null);

   surfaceCapabilities: VkSurfaceCapabilitiesKHR;
   vkResult := vkGetPhysicalDeviceSurfaceCapabilitiesKHR(vk.physicalDevice, window.surface, *surfaceCapabilities);
   assert(vkResult == VK_SUCCESS);
   swapExtent: VkExtent2D = ChooseSwapExtent(surfaceCapabilities, window.window);
   minImageCountToRequestFromSwapchainCreation := GetMinImageCountToRequestInSwapchainCreation(surfaceCapabilities);

   swapchainCreateInfo: VkSwapchainCreateInfoKHR = .{
      sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
      pNext = null,
      surface = window.surface,
      minImageCount = minImageCountToRequestFromSwapchainCreation,
      imageFormat = vk.surfaceFormat.format,
      imageColorSpace = vk.surfaceFormat.colorSpace,
      imageExtent = swapExtent,
      imageArrayLayers = 1,
      imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT,
      imageSharingMode = .VK_SHARING_MODE_EXCLUSIVE,
      queueFamilyIndexCount = 0,
      pQueueFamilyIndices = null,
      preTransform = surfaceCapabilities.currentTransform,
      compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
      presentMode = vk.presentMode,
      clipped = xx true,
      oldSwapchain = null,
   };

   vkResult = vkCreateSwapchainKHR(vk.device, *swapchainCreateInfo, null, *window.swapchain);
   assert(vkResult == VK_SUCCESS);

   swapchainImageCount: u32 = 0;
   vkGetSwapchainImagesKHR(vk.device, window.swapchain, *swapchainImageCount, null);
   swapchainImages: [] VkImage;
   swapchainImages.count = swapchainImageCount;
   swapchainImages.data = temporary_alloc(swapchainImageCount * size_of(VkImage));
   vkResult = vkGetSwapchainImagesKHR(vk.device, window.swapchain, *swapchainImageCount, swapchainImages.data);
   assert(vkResult == VK_SUCCESS);

   swapchainImageViews: [] VkImageView;
   swapchainImageViews.count = swapchainImageCount;
   swapchainImageViews.data = temporary_alloc(swapchainImageCount * size_of(VkImageView));
   for 0..swapchainImageCount - 1 {
      imageViewCreateInfo: VkImageViewCreateInfo = .{
         sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
         pNext = null,
         image = swapchainImages[it],
         viewType = VK_IMAGE_VIEW_TYPE_2D,
         format = vk.surfaceFormat.format,
         components = .{
            r = VK_COMPONENT_SWIZZLE_IDENTITY,
            g = VK_COMPONENT_SWIZZLE_IDENTITY,
            b = VK_COMPONENT_SWIZZLE_IDENTITY,
            a = VK_COMPONENT_SWIZZLE_IDENTITY,
         },
         subresourceRange = .{
            aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1,
         },
      };

      vkResult = vkCreateImageView(vk.device, *imageViewCreateInfo, null, *swapchainImageViews[it]);
      assert(vkResult == VK_SUCCESS);
   }

   // fill in the values created by vkCreateSwapchainKHR() and vkCreateImageView()
   window.swapchainImages = NewArray(swapchainImageCount, Image);
   for 0..swapchainImageCount - 1 {
      window.swapchainImages[it].image = swapchainImages[it];
      window.swapchainImages[it].size = .[swapExtent.width, swapExtent.height, 1];
      window.swapchainImages[it].format = vk.surfaceFormat.format;
      window.swapchainImages[it].view = swapchainImageViews[it];
      window.swapchainImages[it].arrayLayers = 1;
      window.swapchainImages[it].mipLevels = 1;
      window.swapchainImages[it].sampleCount = 1;
      window.swapchainImages[it].debugName = sprint("\"%\" swapchain image(%)", window.title, it);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_IMAGE, xx window.swapchainImages[it].image, window.swapchainImages[it].debugName);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_IMAGE_VIEW, xx window.swapchainImages[it].view, tprint("%[ImageView]", window.swapchainImages[it].debugName));
   }

   //
   // per frame buffers is part of swapchain becasue when you recreate the swapchain
   // you might (prolly not) get a new image count since it is the driver that decides it
   // so i have to readjust the sync objects. i can do like if size didnt change then do nothing
   // if changed then recreate but unnecessary complexity just recreate. also who the fuck resizes a window
   // when playing a game anyways
   //       - apila, 27/03/26
   //

   // per frame buffers
   window.acquireImageSemaphores = NewArray(swapchainImageCount, VkSemaphore);
   window.queueSubmitSemaphores = NewArray(swapchainImageCount, VkSemaphore);
   window.queueSubmitFences = NewArray(swapchainImageCount, VkFence);

   for 0..swapchainImageCount - 1 {
      semaphoreCreateInfo: VkSemaphoreCreateInfo = .{
         sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
         pNext = null,
         flags = 0,
      };

      semaphore: VkSemaphore;
      vkResult := vkCreateSemaphore(vk.device, *semaphoreCreateInfo, null, *semaphore);
      assert(vkResult == VK_SUCCESS);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_SEMAPHORE, xx semaphore, tprint("window.acquireImageSemaphores[%]", it));
      window.acquireImageSemaphores[it] = semaphore;

      vkResult = vkCreateSemaphore(vk.device, *semaphoreCreateInfo, null, *semaphore);
      assert(vkResult == VK_SUCCESS);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_SEMAPHORE, xx semaphore, tprint("window.queueSubmitSemaphores[%]", it));
      window.queueSubmitSemaphores[it] = semaphore;

      fenceCreateInfo: VkFenceCreateInfo = .{
         sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
         pNext = null,
         flags = VK_FENCE_CREATE_SIGNALED_BIT,
      };

      fence: VkFence;
      vkResult = vkCreateFence(vk.device, *fenceCreateInfo, null, *fence);
      assert(vkResult == VK_SUCCESS);
      VkSetDebugUtilsObjectNameExt(vk.device, VK_OBJECT_TYPE_FENCE, xx fence, tprint("window.queueSubmitFences[%]", it));
      window.queueSubmitFences[it] = fence;
   }
}

// creates glfw window and vulkan surface attached to it
CreateWindowThePartBeforeDeviceCreation :: (width: int, height: int, title: string) -> resultPtrButNotStableIfUnderlyingArrayResizes: *Window, indexIntoGlobalWindowsArray: StableIndexArrayHandle {
   result: Window;
   result.window = glfwCreateWindow(xx width, xx height, to_c_string(title,, temp), null, null);

   if (result.window == null) {
      print("Failed to create GLFW window\n");
      exit(69);
   }

   result.width = width;
   result.height = height;
   result.title = title;

   {
      positionX: s32;
      positionY: s32;
      glfwGetWindowPos(result.window, *positionX, *positionY);
      result.position.x = positionX;
      result.position.y = positionY;
   }

   if (glfwRawMouseMotionSupported() != 0) {
      glfwSetInputMode(result.window, GLFW_RAW_MOUSE_MOTION, 1);
   }

   WindowSizeCallback: GLFWwindowsizefun : (glfwWindow: *GLFWwindow, width: s32, height: s32) #c_call {
      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);
         window.width = width;
         window.height = height;
      }
   };
   glfwSetWindowSizeCallback(result.window, WindowSizeCallback);

   KeyCallback: GLFWkeyfun : (glfwWindow: *GLFWwindow, key: s32, scancode: s32, action: s32, mods: s32) #c_call {
      // if (action == GLFW_PRESS) {
      //    result.input.keyboard.keys[(int)key] = true;
      // } else if (action == GLFW_RELEASE) {
      //    result.input.keyboard.keys[(int)key] = false;
      // }

      // when i press
      // - volume up
      // - volume down
      // - next track
      // - previous track
      // - play/stop
      // i get GLFW_KEY_UNKNOWN which is -1 and it crashes.
      // this didnt use to happen but now happens idk why.
      //    - apila, 22/11/25
      if (key == GLFW_KEY_UNKNOWN) {
         return;
      }

      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         polledEvent: PolledEvent;
         polledEvent.type = .Key;
         polledEvent.key = .{
            action = action,
            key = key
         };

         Enqueue(*window.polledEventsQueue, polledEvent);
      }
   };
   glfwSetKeyCallback(result.window, KeyCallback);

   CharCallback: GLFWcharfun : (glfwWindow: *GLFWwindow, c: u32) #c_call {
      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         Enqueue(*window.input.keyboard.characterQueue, c);
      }
   };
   glfwSetCharCallback(result.window, CharCallback);

   MouseButtonCallback: GLFWmousebuttonfun : (glfwWindow: *GLFWwindow, button: s32, action: s32, mods: s32) #c_call {
      // if (action == GLFW_PRESS) {
      //    result.input.mouse.buttons[(int)button] = true;
      // } else if (action == GLFW_RELEASE) {
      //    result.input.mouse.buttons[(int)button] = false;
      // }

      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         polledEvent: PolledEvent;
         polledEvent.type = .MouseButton;
         polledEvent.mouseButton = .{
            action = action,
            button = button
         };

         Enqueue(*window.polledEventsQueue, polledEvent);
      }
   };
   glfwSetMouseButtonCallback(result.window, MouseButtonCallback);

   CursorPosCallback: GLFWcursorposfun : (glfwWindow: *GLFWwindow, xpos: float64, ypos: float64) #c_call {
      // result.input.mouse.position = new Vector2((float)xpos, result.size.y - (float)ypos);

      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         polledEvent: PolledEvent;
         polledEvent.type = .CursorPosition;
         polledEvent.cursorPosition = .{ xx xpos, xx (window.height - ypos) };

         Enqueue(*window.polledEventsQueue, polledEvent);
      }
   };
   glfwSetCursorPosCallback(result.window, CursorPosCallback);

   ScrollCallback: GLFWscrollfun : (glfwWindow: *GLFWwindow, xoffset: float64, yoffset: float64) #c_call {
      // result.input.mouse.wheel = (float)yoffset;

      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         polledEvent: PolledEvent;
         polledEvent.type = .Scroll;
         polledEvent.scroll = .{
            yOffset = xx yoffset
         };

         Enqueue(*window.polledEventsQueue, polledEvent);
      }
   };
   glfwSetScrollCallback(result.window, ScrollCallback);

   FramebufferSizeCallback: GLFWframebuffersizefun : (glfwWindow: *GLFWwindow, width: s32, height: s32) #c_call {
      push_context {
         found, windowIndex := table_find(*glfwWindowToWindow, glfwWindow);
         assert(found);
         window := Get(*windows, windowIndex);

         window.isFramebufferResized = true;
      }
   };
   glfwSetFramebufferSizeCallback(result.window, FramebufferSizeCallback);

   vkResult := glfwCreateWindowSurface(vk.instance, result.window, null, *result.surface);
   assert(vkResult == VK_SUCCESS);

   windowIndex := Add(*windows, result);
   windowPtr := Get(*windows, windowIndex);
   table_add(*glfwWindowToWindow, result.window, windowIndex);
   return windowPtr, windowIndex;
}

ChoosePhysicalDevice :: (instance: VkInstance) -> VkPhysicalDevice {
   assert(instance != null);

   deviceCount: u32 = 0;
   result := vkEnumeratePhysicalDevices(instance, *deviceCount, null);
   assert(result == VK_SUCCESS);
   assert(deviceCount != 0, "Failed to find GPUs with Vulkan support!");

   // physicalDevices: [deviceCount] VkPhysicalDevice; // cant allocate stuff on the stack. wtf jai? no alloca support as of yet. 17/03/26
   physicalDevices: [] VkPhysicalDevice;
   physicalDevices.data = temporary_alloc(deviceCount * size_of(VkPhysicalDevice));
   physicalDevices.count = deviceCount;
   vkEnumeratePhysicalDevices(instance, *deviceCount, physicalDevices.data);

   meshShaderSupportedGpus := FilterGpusThatSupportMeshShaders(physicalDevices);
   if (meshShaderSupportedGpus.count == 0) {
      print("No GPU with mesh shader support found! Found devices:\n");
      for physicalDevices {
         properties: VkPhysicalDeviceProperties;
         vkGetPhysicalDeviceProperties(it, *properties);
         print("\t%\n", properties.deviceName);
      }

      assert(false);
   }

   discreteGpu, ok := GetFirstDiscreteGpu(meshShaderSupportedGpus);

   if (ok) {
      return discreteGpu;
   } else {
      return meshShaderSupportedGpus[0];
   }
}

FilterGpusThatSupportMeshShaders :: (gpus: [] VkPhysicalDevice) -> [] VkPhysicalDevice {
   filteredGpus: [..] VkPhysicalDevice;

   for gpus {
      meshShaderFeatures: VkPhysicalDeviceMeshShaderFeaturesEXT = .{
         sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_EXT,
         pNext = null,
      };

      features2: VkPhysicalDeviceFeatures2 = .{
         sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2,
         pNext = *meshShaderFeatures,
      };

      vkGetPhysicalDeviceFeatures2(it, *features2);

      if (meshShaderFeatures.meshShader && meshShaderFeatures.taskShader) {
         array_add(*filteredGpus, it);
      }
   }

   return filteredGpus;
}

GetFirstDiscreteGpu :: (gpus: [] VkPhysicalDevice) -> VkPhysicalDevice, bool {
   for gpus {
      properties: VkPhysicalDeviceProperties;
      vkGetPhysicalDeviceProperties(it, *properties);

      if (properties.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
         return it, true;
      }
   }

   return xx void, false;
}

VkVersionToString :: (version: u32) -> string {
   return sprint("%.%.%.%", VK_API_VERSION_VARIANT(version), VK_API_VERSION_MAJOR(version), VK_API_VERSION_MINOR(version), VK_API_VERSION_PATCH(version));
}

GetMaxSupportedMsaaSamples :: (physicalDeviceProperties: VkPhysicalDeviceProperties) -> VkSampleCountFlags {
   counts: VkSampleCountFlags = physicalDeviceProperties.limits.framebufferColorSampleCounts & physicalDeviceProperties.limits.framebufferDepthSampleCounts;

   if ((counts & VK_SAMPLE_COUNT_64_BIT) != 0) {
      return VK_SAMPLE_COUNT_64_BIT;
   } else if ((counts & VK_SAMPLE_COUNT_32_BIT) != 0) {
      return VK_SAMPLE_COUNT_32_BIT;
   } else if ((counts & VK_SAMPLE_COUNT_16_BIT) != 0) {
      return VK_SAMPLE_COUNT_16_BIT;
   } else if ((counts & VK_SAMPLE_COUNT_8_BIT) != 0) {
      return VK_SAMPLE_COUNT_8_BIT;
   } else if ((counts & VK_SAMPLE_COUNT_4_BIT) != 0) {
      return VK_SAMPLE_COUNT_4_BIT;
   } else if ((counts & VK_SAMPLE_COUNT_2_BIT) != 0) {
      return VK_SAMPLE_COUNT_2_BIT;
   }

   return VK_SAMPLE_COUNT_1_BIT;
}

IsValidationLayerSupported :: () -> bool {
   layerCount: u32;
   vkEnumerateInstanceLayerProperties(*layerCount, null);

   availableLayers := NewArray(layerCount, VkLayerProperties,, temp);
   vkEnumerateInstanceLayerProperties(*layerCount, availableLayers.data);

   for layerProperties: availableLayers {
      if ("VK_LAYER_KHRONOS_validation" == to_string(layerProperties.layerName)) {
         return true;
      }
   }

   return false;
}
