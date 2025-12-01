package Tetris

import rl "vendor:raylib"

input_config_p1 := #partial #sparse[rl.KeyboardKey]action {
	rl.KeyboardKey.J = .left,
	rl.KeyboardKey.L = .right,
	rl.KeyboardKey.K = .down,
	rl.KeyboardKey.H = .rotate_left,
	rl.KeyboardKey.M = .rotate_right,
	rl.KeyboardKey.O = .ok,
	rl.KeyboardKey.U = .cancel,
}


init_input :: proc() {
}

handle_input :: proc() -> (a: action) {
	pressed := rl.GetKeyPressed()
	a = input_config_p1[pressed]
	return a
}
