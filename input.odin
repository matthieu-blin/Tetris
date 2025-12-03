package Tetris

import "core:fmt"
import rl "vendor:raylib"

input_config_delay := #partial [action]f64 {
	.left         = 0.2,
	.right        = 0.2,
	.down         = 0.1,
	.rotate_left  = 0.2,
	.rotate_right = 0.2,
	.cancel       = 0.1,
}

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

init_input :: proc() {

}


handle_input :: proc(actions: ^[action]f64, dt: f64) {
	got_input := false
	for key, action in input_config_p1 {
		if rl.IsKeyDown(key) {
			if (actions[action] < 0) {
				actions[action] = 0
			} else {
				actions[action] += dt
			}
		} else {
			actions^[action] = -1
		}
	}
}
