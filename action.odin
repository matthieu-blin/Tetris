package Tetris

action :: enum {
	none = 0,
	left = 1,
	right,
	down,
	rotate_left,
	rotate_right,
	ok,
	cancel,
}

//action duration
actions_p1: [action]f64
actions_p2: [action]f64
