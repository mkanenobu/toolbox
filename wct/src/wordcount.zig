const std = @import("std");
const fs = std.fs;
const unicode = std.unicode;
const ascii = std.ascii;

pub const WcFlags = struct {
    bytes: bool = false,
    chars: bool = true,
    lines: bool = false,
    words: bool = false,
};

const WcResult = struct {
    const Self = @This();

    flags: WcFlags,

    bytes: usize = 0,
    chars: usize = 0,
    lines: usize = 0,
    words: usize = 0,

    pub fn format(
        self: Self,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        var prevExists = false;
        if (self.flags.bytes) {
            try writer.print("bytes: {d}", .{self.bytes});
            prevExists = true;
        }
        if (self.flags.chars) {
            if (prevExists) try writer.writeAll(", ");
            try writer.print("chars: {d}", .{self.chars});
            prevExists = true;
        }
        if (self.flags.lines) {
            if (prevExists) try writer.writeAll(", ");
            try writer.print("lines: {d}", .{self.lines});
            prevExists = true;
        }
        if (self.flags.words) {
            if (prevExists) try writer.writeAll(", ");
            try writer.print("words: {d}", .{self.words});
        }
    }
};

pub fn wordcount(file: []const u8, flags: WcFlags) !WcResult {
    const f = try fs.cwd().openFile(file, .{});
    defer f.close();

    return wordcountImpl(&f.reader(), flags);
}

fn wordcountImpl(reader: anytype, flags: WcFlags) !WcResult {
    var buf: [2048]u8 = undefined;

    var chars: usize = 0;
    var bytes: usize = 0;
    var lines: usize = 0;
    var words: usize = 0;
    var in_word: bool = false;

    while (true) {
        const n = try reader.read(&buf);
        if (n == 0) break;

        const s = buf[0..n];

        if (flags.bytes) bytes += n;
        if (flags.lines) {
            lines += std.mem.count(u8, s, "\n");
        }
        if (flags.chars) {
            const n_chars = try count_unicode_chars(s);
            chars += n_chars;
        }
        if (flags.words) {
            for (s) |c| {
                if (ascii.isWhitespace(c)) {
                    in_word = false;
                } else if (!in_word) {
                    in_word = true;
                    words += 1;
                }
            }
        }
    }

    return WcResult{
        .flags = flags,

        .chars = chars,
        .bytes = bytes,
        .lines = lines,
        .words = words,
    };
}

fn count_unicode_chars(s: []const u8) !usize {
    return try unicode.utf8CountCodepoints(s);
}
