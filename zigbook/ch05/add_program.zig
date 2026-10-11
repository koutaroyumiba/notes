const std = @import("std");

fn add_and_increment(a: u8, b: u8) u8 {
    const sum = a + b;
    const incremented = sum + 1;
    return incremented;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var n = add_and_increment(2, 3);
    n = add_and_increment(n, n);
    try stdout.print("Result: {d}!\n", .{n});
    try stdout.flush();
}
