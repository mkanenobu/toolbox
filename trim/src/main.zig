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

    var stdin = io.getStdIn().reader();
    var buf: [1024]u8 = undefined;
    while (true) {
        const n = try stdin.read(&buf);
        if (n == 0) {
            break;
        }
        try list.appendSlice(buf[0..n]);
    }

    const trimmed = trim_whitespace(list.items);
    const stdout = io.getStdOut().writer();
    _ = try stdout.write(trimmed);
}

fn trim_whitespace(s: []const u8) []const u8 {
    return mem.trim(u8, s, &ascii.whitespace);
}

test "trim_whitespace" {
    const input = "\t  hello, world!\r\n  ";
    const expected = "hello, world!";
    const actual = trim_whitespace(input);

    try std.testing.expectEqualDeep(expected, actual);
}
