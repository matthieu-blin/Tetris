package Tetris

import "core:fmt"
import rl "vendor:raylib"

input_action :: struct {
	duration:      f64,
	valid:         bool,
	trigger_count: i32,
}


//{delay before validation, delay before repeat, repeat step}
menu_input_config_delay := #partial [action][3]f64 {
	.down = {0.0, 0.3, 0.4},
	.up   = {0.0, 0.3, 0.4},
}
//{delay before validation, delay before repeat, repeat step}
input_config_delay := #partial [action][3]f64 {
	.left         = {0.0, 0.2, 1.05},
	.right        = {0.0, 0.2, 0.05},
	.down         = {0.0, 0.1, 0.05},
	.rotate_left  = {0.0, 0.2, 0.05},
	.rotate_right = {0.0, 0.2, 0.05},
	.cancel       = {0.0, 0.1, 0.05},
}


input_config_keyboard :: [action]rl.KeyboardKey

input_config_p1 := input_config_keyboard {
	.left         = rl.KeyboardKey.A,
	.right        = rl.KeyboardKey.D,
	.down         = rl.KeyboardKey.S,
	.up           = rl.KeyboardKey.W,
	.rotate_left  = rl.KeyboardKey.Q,
	.rotate_right = rl.KeyboardKey.E,
	.ok           = rl.KeyboardKey.O,
	.cancel       = rl.KeyboardKey.U,
	.none         = rl.KeyboardKey.KEY_NULL,
}

input_config_p2 := input_config_keyboard {
	.left         = rl.KeyboardKey.LEFT,
	.right        = rl.KeyboardKey.RIGHT,
	.down         = rl.KeyboardKey.DOWN,
	.up           = rl.KeyboardKey.UP,
	.rotate_left  = rl.KeyboardKey.RIGHT_CONTROL,
	.rotate_right = rl.KeyboardKey.KP_0,
	.ok           = rl.KeyboardKey.O,
	.cancel       = rl.KeyboardKey.U,
	.none         = rl.KeyboardKey.KEY_NULL,
}

init_input :: proc() {

}


handle_input :: proc(
	actions: ^[action]input_action,
	input_config: input_config_keyboard,
	input_delay: #sparse[action][3]f64,
	dt: f64,
) {
	got_input := false
	for key, action in input_config {
		actions[action].valid = false
		if rl.IsKeyDown(key) {
			if (actions[action].duration < 0) {
				actions[action].duration = 0
			} else {
				actions[action].duration += dt
			}
			//not triggered yet
			if actions[action].trigger_count == 0 &&
			   actions[action].duration >= input_delay[action][0] {
				actions[action].valid = true
				actions[action].trigger_count = 1
			}

			//already triggered : need to repeat ?
			if actions[action].trigger_count > 0 &&
			   input_delay[action][2] > 0 &&
			   actions[action].duration >= input_delay[action][1] {
				actions[action].duration = input_delay[action][1] - input_delay[action][2]
				actions[action].valid = true
				actions[action].trigger_count += 1
			}
		} else {
			actions[action].duration = -1
			actions[action].trigger_count = 0
		}
	}
}
