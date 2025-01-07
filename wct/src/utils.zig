const std = @import("std");
const unicode = std.unicode;

pub fn maxLenString(l: []const []const u8) !usize {
    var max: usize = 0;
    for (l) |s| {
        const len = try unicode.utf8CountCodepoints(s);
        if (len > max) {
            max = len;
        }
    }
    return max;
}

test "maxLenString" {
    const l = [_][]const u8{
        "hello",
        "world",
        "こんにちは!",
    };
    const got = maxLenString(&l);
    const want = 6;
    try std.testing.expectEqual(got, want);
}
