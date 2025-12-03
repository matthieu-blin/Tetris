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
actions: [action]f64
