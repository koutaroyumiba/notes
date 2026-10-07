const std = @import("std");
const print = std.debug.print;

const Role = enum { SE, DPE, DE, DA, PM, PO, KS };

pub const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    fn print_name(self: User, stdout: *std.Io.Writer) !void {
        try stdout.print("{s}\n", .{self.name});
        try stdout.flush();
    }
};

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var area: []const u8 = undefined;
    const role = Role.SE;

    switch (role) {
        .PM, .SE, .DPE, .PO => {
            area = "Platform";
        },
        .DE, .DA => {
            area = "Data and Analytics";
        },
        .KS => {
            area = "Sales";
        },
    }

    print("{s}\n", .{area});

    const user = User.init(1, "Alice", "alice@example.com");
    try stdout.print("User #{d}: ", .{user.id});
    try user.print_name(stdout);
    try stdout.print("Email: {s}\n", .{user.email});
    try stdout.flush();
}
