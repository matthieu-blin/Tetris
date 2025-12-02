package Tetris

import "core:fmt"
import rl "vendor:raylib"

input_config_p1 := [action]rl.KeyboardKey {
	.left         = rl.KeyboardKey.J,
	.right        = rl.KeyboardKey.L,
	.down         = rl.KeyboardKey.K,
	.rotate_left  = rl.KeyboardKey.H,
	.rotate_right = rl.KeyboardKey.M,
	.ok           = rl.KeyboardKey.O,
	.cancel       = rl.KeyboardKey.U,
	.none         = rl.KeyboardKey.KEY_NULL,
}

input_state :: enum {
	none,
	pressed,
	released, //just released
}

init_input :: proc() {

}


handle_input :: proc(actions: ^[action]input_state) -> bool {
	got_input := false
	for key, action in input_config_p1 {
		if rl.IsKeyDown(key) {
			actions[action] = .pressed
			got_input = true
		}
		if rl.IsKeyReleased(key) {
			actions[action] = .released
			got_input = true
		}
	}
	return got_input
}
