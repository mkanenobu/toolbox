const std = @import("std");
const io = std.io;
const mem = std.mem;
const ascii = std.ascii;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        if (gpa.deinit() == .leak)  {
            std.debug.print("gpa leaked\n", .{});
        }
    }
    const allocator = gpa.allocator();

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    var stdin = std.io.getStdIn().reader();
    var buf: [1024]u8 = undefined;
    while (true) {
        const n = try stdin.read(&buf);
        if (n == 0) {
            break;
        }
        try list.appendSlice(buf[0..n]);
    }

    const trimmed = trim(list.items, &ascii.whitespace);
    const stdout = std.io.getStdOut().writer();
    _ = try stdout.write(trimmed);
}

fn trim(s: []const u8, cutset: []const u8) []const u8 {
    return mem.trim(u8, s, cutset);
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
