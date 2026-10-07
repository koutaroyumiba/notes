const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    var stdout = &stdout_writer.interface;

    const bytes = [_]u8{ 0x48, 0x65, 0x6C, 0x6C, 0x6F };

    try stdout.print("{s}\n", .{bytes});
    try stdout.print("{any}\n", .{@TypeOf("A literal value")});

    const string_object = "This is an example";
    try stdout.print("Bytes that represent the string object: ", .{});
    for (string_object) |byte| {
        try stdout.print("{X} ", .{byte});
    }
    try stdout.print("\n", .{});
    try stdout.flush();
}
