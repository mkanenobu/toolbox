const std = @import("std");
const cli = @import("./cli.zig");
const wc = @import("./wordcount.zig");
const utils = @import("./utils.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const r = gpa.deinit();
        if (r == .leak) {
            std.debug.print("gpa leaked: {}\n", .{r});
        }
    }

    const cli_args = try cli.parseCliArgs(allocator);
    defer cli_args.deinit();

    const flags = wc.WcFlags{
        .bytes = true,
        .chars = true,
        .lines = true,
        .words = true,
    };

    const stdout = std.io.getStdOut().writer();

    for (cli_args.files) |file| {
        const r = wc.wordcount(file, flags) catch |err| {
            std.debug.print("{s}: {any}\n", .{ file, err });
            continue;
        };
        // TODO: align to longest filename
        try stdout.print("{s}: {s}\n", .{ file, r });
    }
}

test {
    _ = @import("./cli.zig");
    _ = @import("./wordcount.zig");
    _ = @import("./utils.zig");

    std.testing.refAllDecls(@This());
}
