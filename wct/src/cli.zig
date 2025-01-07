const std = @import("std");
const clap = @import("clap");
const mem = std.mem;

pub fn parseCliArgs(allocator: mem.Allocator) !CliArgs {
    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\<str>...
        \\
    );

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = allocator,
    }) catch |err| {
        // Report useful error and exit.
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    return CliArgs{
        .allocator = allocator,
        .files = try allocator.dupe([]const u8, res.positionals),
    };
}

pub const CliArgs = struct {
    const Self = @This();

    allocator: mem.Allocator,

    files: []const []const u8,

    pub fn deinit(self: Self) void {
        self.allocator.free(self.files);
    }
};
