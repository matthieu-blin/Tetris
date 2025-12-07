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
	.left         = rl.KeyboardKey.A,
	.right        = rl.KeyboardKey.D,
	.down         = rl.KeyboardKey.S,
	.rotate_left  = rl.KeyboardKey.Q,
	.rotate_right = rl.KeyboardKey.E,
	.ok           = rl.KeyboardKey.O,
	.cancel       = rl.KeyboardKey.U,
	.none         = rl.KeyboardKey.KEY_NULL,
}

input_config_p2 := [action]rl.KeyboardKey {
	.left         = rl.KeyboardKey.LEFT,
	.right        = rl.KeyboardKey.RIGHT,
	.down         = rl.KeyboardKey.DOWN,
	.rotate_left  = rl.KeyboardKey.RIGHT_CONTROL,
	.rotate_right = rl.KeyboardKey.KP_0,
	.ok           = rl.KeyboardKey.O,
	.cancel       = rl.KeyboardKey.U,
	.none         = rl.KeyboardKey.KEY_NULL,
}

init_input :: proc() {

}


handle_input :: proc(actions: ^[action]f64, actionsp2: ^[action]f64, dt: f64) {
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
	for key, action in input_config_p2 {
		if rl.IsKeyDown(key) {
			if (actionsp2[action] < 0) {
				actionsp2[action] = 0
			} else {
				actionsp2[action] += dt
			}
		} else {
			actionsp2^[action] = -1
		}
	}
}
