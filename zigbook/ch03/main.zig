const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.SafeAllocator.init(std.heap.c_allocator, .{});
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    std.debug.print("{}\n", .{some_number.*});
}
