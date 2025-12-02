package Tetris

cell_type :: enum {
	none,
	cube,
}

polyomino_shape :: enum {
	line_4,
	square_4,
	right_4,
	left_4,
	left_right_4,
	right_left_4,
	branch_4,
}

angle :: enum {
	angle_0,
	angle_90,
	angle_180,
	angle_270,
}

polyomino :: struct {
	shape: polyomino_shape,
	//fixme : wanna make a [?] here and setup on construction
	cell:  [angle][4][2]i32,
}

piece :: struct {
	polyomino:     polyomino,
	position:      [2]i32,
	next_position: [2]i32,
	rotation:      angle,
	next_rotation: angle,
	type:          cell_type,
}

all_polyomino := #partial [polyomino_shape]polyomino {
	.line_4 = {
		.line_4,
		{
			.angle_0 = {{-2, 0}, {-1, 0}, {0, 0}, {1, 0}},
			.angle_90 = {{0, 1}, {0, 0}, {0, -1}, {0, -2}},
			.angle_180 = {{-2, -1}, {-1, -1}, {0, -1}, {1, -1}},
			.angle_270 = {{-1, 1}, {-1, 0}, {-1, -1}, {-1, -2}},
		},
	},
}

random_polyomino :: proc() -> polyomino {
	return all_polyomino[.line_4]
}
