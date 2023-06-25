const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "basisu-zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibCpp();
    lib.addCSourceFile("src/wrapper.cpp", &.{});
    lib.linkLibrary(b.dependency("basisu", .{
        .target = target,
        .optimize = optimize,
    }).artifact("basisu"));
    b.installArtifact(lib);

    const zig_wrapper = b.addModule("basisu-zig", .{
        .source_file = .{ .path = "src/main.zig" },
    });
    _ = zig_wrapper;
    // NOTE: There is *no* API on zig_wrapper (Build.Module) which would
    // allow us to link a library!
    //zig_wrapper.linkLibrary(lib);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    main_tests.linkLibrary(lib);

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
