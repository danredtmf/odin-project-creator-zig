const std = @import("std");
const builtin = @import("builtin");
const print = std.debug.print;
const create = @import("create/create.zig");
const constants = @import("create/constants.zig");

const Options = struct {
    name: ?[]const u8 = null,
    ols: bool = false,
    vscode: bool = false,
    help: bool = false,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();

    const args = try std.process.argsAlloc(arena_allocator);
    var options = Options{};

    var i: usize = 1;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "--ols")) {
            options.ols = true;
        } else if (std.mem.eql(u8, arg, "--vscode")) {
            options.vscode = true;
        } else if (std.mem.eql(u8, arg, "--help")) {
            options.help = true;
        } else if (std.mem.startsWith(u8, arg, "-")) {
            print("Unknown option: {s}\n", .{arg});
            return error.InvalidArgument;
        } else {
            if (options.name == null) {
                options.name = arg;
            } else {
                print("Unexpected argument: {s}\n", .{arg});
                return error.InvalidArgument;
            }
        }
    }

    if (options.help) {
        print("{s}\n", .{constants.PROGRAM_HELP});
        return;
    }

    const project_name = options.name orelse {
        print("Project name is required!\nType `--help` for more info.", .{});
        return error.MissingProjectName;
    };

    if (project_name.len == 0) {
        print("Project name cannot be empty!\nType `--help` for more info.", .{});
        return error.InvalidProjectName;
    }

    const project_path = try std.fs.path.join(arena_allocator, &[_][]const u8{ ".", project_name });
    try create.folder(project_path);

    try create.mainFile(arena_allocator, &project_path);

    if (options.ols) {
        try create.ols(arena_allocator, &project_path);
    }

    if (options.vscode) {
        try create.vscodeConfig(arena_allocator, &project_path);
    }

    print("Project `{s}` created successfully!\n", .{project_name});
}
