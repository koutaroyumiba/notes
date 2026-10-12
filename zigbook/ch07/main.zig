const std = @import("std");
const Request = @import("request.zig");
const Response = @import("response.zig");
const Server = @import("server.zig").Server;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = @splat(0);
    try Request.read_request(io, connection, request_buffer[0..]);
    const request = Request.parse_request(request_buffer[0..]);

    if (request.method == Request.Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection, io);
        } else {
            try Response.send_404(connection, io);
        }
    }

    std.debug.print("{any}", .{request});
}
