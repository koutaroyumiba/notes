const std = @import("std");

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_sym = "0123456789+/";
        return Base64{ ._table = upper ++ lower ++ numbers_sym };
    }

    pub fn char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }

    pub fn char_index(self: Base64, char: u8) u8 {
        if (char == '=') {
            return 64;
        }

        var i: u8 = 0;
        var output_index: u8 = 0;

        while (i < 64) : (i += 1) {
            if (self.char_at(i) == char) {
                break;
            }
            output_index += 1;
        }

        return output_index;
    }

    pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) {
            return "";
        }

        const out_len = calc_encode_length(input);
        var out = try allocator.alloc(u8, out_len);
        var buf = [3]u8{ 0, 0, 0 };
        var count: u8 = 0;
        var curr_index: u64 = 0;

        for (0..input.len) |i| {
            buf[count] = input[i];
            count += 1;

            if (count == 3) {
                out[curr_index] = self.char_at(buf[0] >> 2);
                out[curr_index + 1] = self.char_at(((buf[0] & 0x3) << 4) + (buf[1] >> 4));
                out[curr_index + 2] = self.char_at(((buf[1] & 0xf) << 2) + (buf[2] >> 6));
                out[curr_index + 3] = self.char_at(buf[2] & 0x3f);
                curr_index += 4;
                count = 0;
            }
        }

        if (count == 1) {
            out[curr_index] = self.char_at(buf[0] >> 2);
            out[curr_index + 1] = self.char_at((buf[0] & 0x3) << 4);
            out[curr_index + 2] = '=';
            out[curr_index + 3] = '=';
        }

        if (count == 2) {
            out[curr_index] = self.char_at(buf[0] >> 2);
            out[curr_index + 1] = self.char_at(((buf[0] & 0x3) << 4) + (buf[1] >> 4));
            out[curr_index + 2] = self.char_at((buf[1] & 0xf) << 2);
            out[curr_index + 3] = '=';
        }

        return out;
    }

    pub fn decode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) {
            return "";
        }

        const out_len = calc_decode_length(input);
        var buf = [4]u8{ 0, 0, 0, 0 };
        var count: u8 = 0;
        var curr_index: u64 = 0;
        var out = try allocator.alloc(u8, out_len);
        @memset(out[0..], 0);

        for (0..input.len) |i| {
            buf[count] = self.char_index(input[i]);
            count += 1;
            if (count == 4) {
                out[curr_index] = (buf[0] << 2) + (buf[1] >> 4);
                if (buf[2] != 64) {
                    out[curr_index + 1] = (buf[1] << 4) + (buf[2] >> 2);
                }
                if (buf[3] != 64) {
                    out[curr_index + 2] = (buf[2] << 6) + buf[3];
                }

                curr_index += 3;
                count = 0;
            }
        }

        return out;
    }
};

fn calc_encode_length(input: []const u8) usize {
    if (input.len < 3) {
        return 4;
    }

    const n_groups: usize = @divCeil(input.len, 3);
    return n_groups * 4;
}

fn calc_decode_length(input: []const u8) usize {
    if (input.len < 4) {
        return 3;
    }

    const n_groups: usize = @divFloor(input.len, 4);
    var multiple_groups = n_groups * 3;
    var i = input.len - 1;
    while (i > 0) : (i -= 1) {
        if (input[i] == '=') {
            multiple_groups -= 1;
        } else {
            break;
        }
    }

    return multiple_groups;
}

pub fn main() !void {
    var memory_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();
    const base64 = Base64.init();

    const text = "This is the original OG text!";
    const encoded_text = try base64.encode(allocator, text);
    std.debug.print("Encoded text: {s}\n", .{encoded_text});
    const decoded_text = try base64.decode(allocator, encoded_text);
    std.debug.print("Decoded text: {s}\n", .{decoded_text});
}
