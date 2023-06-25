pub extern fn basisu_encoder_init() void;

pub fn init() void {
    basisu_encoder_init();
}

test "basic functionality" {
    init();
}
