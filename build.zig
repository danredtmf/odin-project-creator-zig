const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const create = b.addStaticLibrary(.{
        .name = "create",
        .root_source_file = b.path("src/create/create.zig"),
        .target = target,
        .optimize = optimize,
    });

    const constants = b.addStaticLibrary(.{
        .name = "create",
        .root_source_file = b.path("src/create/constants.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "odin-project-creator-zig",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibrary(create);
    exe.linkLibrary(constants);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the application");
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    run_step.dependOn(&run_cmd.step);
}
