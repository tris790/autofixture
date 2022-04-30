const std = @import("std");

const Worker = struct {
    number: u32 = 0,
};

const Processor = struct {
    x: u32,
    y: u32 = 0,
    name: []const u8 = "",
    worker: Worker = undefined,

    fn process(_: Processor, p: u8) u16 {
        std.log.info("Processing: {}\n", .{p});
        return 1;
    }
};

pub fn getOutputFromType(comptime T: type) T {
    return switch (T) {
        []const u8 => "hello",
        u32 => 5,
        else => fixture(T, .{}),
    };
}

pub fn fixture(comptime T: type, args: anytype) T {
    var dummy: T = args;
    const fields = @typeInfo(T).Struct.fields;
    inline for (fields) |field| {
        if (field.default_value) |_| {
            const field_type = field.field_type;
            const output = getOutputFromType(field_type);
            @field(dummy, field.name) = output;
        }
    }
    return dummy;
}

pub fn main() anyerror!void {
    const myFixture = fixture(Processor, .{ .x = 2 });
    _ = myFixture.process(9);
    std.debug.print("output: {}", .{myFixture});
}
