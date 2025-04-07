const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cglm_lib = b.addSharedLibrary(.{ .name = "cglm", .optimize = optimize, .target = target });
    cglm_lib.addIncludePath(b.path("include"));
    cglm_lib.addCSourceFiles(
        .{
            .files = &.{
                "src/euler.c",
                "src/affine.c",
                "src/io.c",
                "src/quat.c",
                "src/cam.c",
                "src/vec2.c",
                "src/ivec2.c",
                "src/vec3.c",
                "src/ivec3.c",
                "src/vec4.c",
                "src/ivec4.c",
                "src/mat2.c",
                "src/mat2x3.c",
                "src/mat2x4.c",
                "src/mat3.c",
                "src/mat3x2.c",
                "src/mat3x4.c",
                "src/mat4.c",
                "src/mat4x2.c",
                "src/mat4x3.c",
                "src/plane.c",
                "src/noise.c",
                "src/frustum.c",
                "src/box.c",
                "src/aabb2d.c",
                "src/project.c",
                "src/sphere.c",
                "src/ease.c",
                "src/curve.c",
                "src/bezier.c",
                "src/ray.c",
                "src/affine2d.c",
                "src/clipspace/ortho_lh_no.c",
                "src/clipspace/ortho_lh_zo.c",
                "src/clipspace/ortho_rh_no.c",
                "src/clipspace/ortho_rh_zo.c",
                "src/clipspace/persp_lh_no.c",
                "src/clipspace/persp_lh_zo.c",
                "src/clipspace/persp_rh_no.c",
                "src/clipspace/persp_rh_zo.c",
                "src/clipspace/view_lh_no.c",
                "src/clipspace/view_lh_zo.c",
                "src/clipspace/view_rh_no.c",
                "src/clipspace/view_rh_zo.c",
                "src/clipspace/project_no.c",
                "src/clipspace/project_zo.c",
            },

            .flags = &.{
                // temporary args, only for windows
                "-DCGLM_EXPORTS",
            },
        },
    );
    cglm_lib.linkLibC();
    cglm_lib.linkSystemLibrary("m");

    cglm_lib.installHeadersDirectory(b.path("include"), "", .{});
    b.installArtifact(cglm_lib);

    const test_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    test_mod.addCSourceFiles(.{
        .files = &.{
            "test/runner.c",
            "test/src/test_bezier.c",
            "test/src/test_clamp.c",
            "test/src/test_common.c",
            "test/src/test_euler.c",
            "test/src/tests.c",
            "test/src/test_struct.c",
        },
    });
    test_mod.addIncludePath(b.path("include"));
    test_mod.linkLibrary(cglm_lib);

    const test_exe = b.addExecutable(.{ .name = "test", .root_module = test_mod });

    const test_runner = b.addRunArtifact(test_exe);
    const test_step = b.step("test", "run cglm tests suite");
    test_step.dependOn(&test_runner.step);

    const translatedBinding = b.addTranslateC(.{
        .root_source_file = b.path("include/cglm/call.h"),
        .target = target,
        .optimize = optimize,
    });
    _ = translatedBinding.addModule("cglm-binding");
}
