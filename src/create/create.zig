const std = @import("std");
const builtin = @import("builtin");
const print = std.debug.print;
const constants = @import("./constants.zig");

pub fn folder(path: []const u8) !void {
    const folderName = result: {
        if (std.mem.lastIndexOf(u8, path, "/")) |last_index| {
            break :result path[last_index + 1 ..];
        } else {
            break :result path;
        }
    };

    const exists = blk: {
        std.fs.cwd().access(path, .{}) catch |err| {
            if (err == error.FileNotFound) break :blk false;
            return err;
        };
        break :blk true;
    };

    if (!exists) {
        try std.fs.cwd().makeDir(path);
        print("Folder `{s}` has been created!\n", .{folderName});
    }
}

pub fn mainFile(arena_allocator: std.mem.Allocator, path: *const []u8) !void {
    const main_odin_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ path.*, "main.odin" });
    const file = if (builtin.os.tag == .windows)
        try std.fs.cwd().createFile(main_odin_path)
    else
        try std.fs.cwd().createFile(main_odin_path, .{ .mode = 0o755 });
    defer file.close();
    try file.writeAll(constants.MAIN_ODIN_DATA);
    print("`main.odin` has been created!\n", .{});
}

pub fn ols(arena_allocator: std.mem.Allocator, path: *const []u8) !void {
    const ols_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ path.*, "ols.json" });
    const ols_file = try std.fs.cwd().createFile(ols_path, .{});
    try ols_file.writeAll(constants.OLS_JSON_CONTENT);
    print("`ols.json` has been created!\n", .{});
}

pub fn vscodeConfig(arena_allocator: std.mem.Allocator, path: *const []u8) !void {
    const vscode_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ path.*, ".vscode" });
    try folder(vscode_path);

    const launch_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ vscode_path, "launch.json" });
    try std.fs.cwd().writeFile(.{ .sub_path = launch_path, .data = constants.VSCODE_LAUNCH_CONTENT });

    const tasks_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ vscode_path, "tasks.json" });
    try std.fs.cwd().writeFile(.{ .sub_path = tasks_path, .data = constants.VSCODE_TASKS_CONTENT });

    print("`VSCode` configuration has been created!\n", .{});
}
