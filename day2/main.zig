const std = @import("std");

const part1 = false;

const CubeCounts = enum(i32) { red = 12, green = 13, blue = 14 };
const Game = struct { red: i32 = 0, green: i32 = 0, blue: i32 = 0 };

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

        var game_info_it = std.mem.splitScalar(u8, trimStart(buf.items, "Game "), ':');
        var game_number = try std.fmt.parseInt(i32, game_info_it.next().?, 10);
        var game_it = std.mem.splitScalar(u8, game_info_it.next().?, ';');

        sum += if (part1) try solve1(game_number, &game_it) else try solve2(&game_it);
        buf.clearRetainingCapacity();
    }

    std.debug.print("{d}\n", .{sum});
}

pub fn solve2(game_it: *std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar)) !i32 {
    var totalCubeCount = try parseGame(game_it.next().?);
    while (game_it.next()) |game_str| {
        var game = try parseGame(game_str);
        totalCubeCount.red = @max(totalCubeCount.red, game.red);
        totalCubeCount.blue = @max(totalCubeCount.blue, game.blue);
        totalCubeCount.green = @max(totalCubeCount.green, game.green);
    }

    return totalCubeCount.red * totalCubeCount.green * totalCubeCount.blue;
}

pub fn solve1(game_number: i32, game_it: *std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar)) !i32 {
    while (game_it.next()) |game_str| {
        var game = try parseGame(game_str);
        if (game.red > @intFromEnum(CubeCounts.red) or game.green > @intFromEnum(CubeCounts.green) or game.blue > @intFromEnum(CubeCounts.blue))
            return 0;
    }

    return game_number;
}

pub fn trimStart(str: []const u8, characters: []const u8) []const u8 {
    if (std.mem.startsWith(u8, str, characters)) {
        return str[characters.len..];
    }

    return str;
}

pub fn parseGame(str: []const u8) !Game {
    var game = Game{};

    var cubes_it = std.mem.splitScalar(u8, str, ',');
    while (cubes_it.next()) |cubes| {
        var info_it = std.mem.splitScalar(u8, trimStart(cubes, " "), ' ');
        var count = try std.fmt.parseInt(i32, info_it.next().?, 10);
        var name = info_it.next().?;
        if (std.mem.eql(u8, name, "red")) {
            game.red = count;
        } else if (std.mem.eql(u8, name, "green")) {
            game.green = count;
        } else if (std.mem.eql(u8, name, "blue")) {
            game.blue = count;
        }
    }

    return game;
}
