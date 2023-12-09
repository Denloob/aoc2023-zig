const std = @import("std");
const part1 = false;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();

    var buf = std.ArrayList(u8).init(std.heap.page_allocator);
    defer buf.deinit();

    var sum: i32 = 0;
    while (true) {
        stdin.streamUntilDelimiter(buf.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => {
                break;
            },
            else => return err,
        };

        var first_digit: u8 = for (0..buf.items.len) |i| {
            if (extractNumber(buf.items[i..])) |number| {
                break number;
            }
        };

        var i = buf.items.len;
        var last_digit: u8 = while (i > 0) {
            i -= 1;

            if (extractNumber(buf.items[i..])) |number| {
                break number;
            }
        };

        sum += first_digit * 10 + last_digit;
        buf.clearRetainingCapacity();
    }

    std.debug.print("{d}\n", .{sum});
}

const number_names = [_][]const u8{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

pub fn extractNumber(arr: []const u8) ?u8 {
    if (std.ascii.isDigit(arr[0]))
        return arr[0] - '0';

    if (part1)
        return null;

    for (number_names, 1..) |name, num| {
        if (std.mem.startsWith(u8, arr, name))
            return @intCast(num);
    }

    return null;
}
