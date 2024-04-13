const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "xcode-frameworks",
        .root_source_file = b.addWriteFiles().add("empty.c", ""),
        .target = target,
        .optimize = optimize,
    });
    addPaths(&lib.root_module); // just for testing
    lib.linkLibC();
    lib.installHeadersDirectory(b.path("include"), ".", .{});
    b.installArtifact(lib);
}

pub fn addPaths(mod: *std.Build.Module) void {
    mod.addSystemFrameworkPath(.{ .path = sdkPath("/Frameworks") });
    mod.addSystemIncludePath(.{ .path = sdkPath("/include") });
    mod.addLibraryPath(.{ .path = sdkPath("/lib") });
}

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("suffix must be an absolute path");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}
