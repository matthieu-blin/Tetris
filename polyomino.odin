package Tetris
import "core:fmt"
import "core:math/rand"

cell_type :: enum {
	none,
	cube1,
	cube2,
	cube3,
	cube4,
	cube5,
	cube6,
	cube7,
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
	type:  cell_type,
}

piece :: struct {
	polyomino:     ^polyomino,
	position:      [2]i32,
	next_position: [2]i32,
	rotation:      angle,
	next_rotation: angle,
}

all_polyomino := #partial [polyomino_shape]polyomino {
	.line_4       = {
		.line_4,
		{
			.angle_0 = {{-2, 0}, {-1, 0}, {0, 0}, {1, 0}},
			.angle_90 = {{0, 1}, {0, 0}, {0, -1}, {0, -2}},
			.angle_180 = {{-2, -1}, {-1, -1}, {0, -1}, {1, -1}},
			.angle_270 = {{-1, 1}, {-1, 0}, {-1, -1}, {-1, -2}},
		},
		.cube1,
	},
	.square_4     = {
		.square_4,
		{
			.angle_0 = {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
			.angle_90 = {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
			.angle_180 = {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
			.angle_270 = {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
		},
		.cube2,
	},
	.right_4      = {
		.right_4,
		{
			.angle_0 = {{-1, 0}, {0, 0}, {1, 0}, {1, -1}},
			.angle_90 = {{0, 0}, {0, -1}, {0, 1}, {1, 1}},
			.angle_180 = {{-1, 0}, {0, 0}, {1, 0}, {-1, 1}},
			.angle_270 = {{0, 0}, {0, -1}, {0, 1}, {-1, -1}},
		},
		.cube3,
	},
	.left_4       = {
		.left_4,
		{
			.angle_0 = {{-1, 0}, {0, 0}, {1, 0}, {-1, -1}},
			.angle_90 = {{0, 0}, {0, -1}, {0, 1}, {1, -1}},
			.angle_180 = {{-1, 0}, {0, 0}, {1, 0}, {1, 1}},
			.angle_270 = {{0, 0}, {0, -1}, {0, 1}, {-1, 1}},
		},
		.cube4,
	},
	.right_left_4 = {
		.right_left_4,
		{
			.angle_0 = {{-1, 0}, {0, 0}, {0, -1}, {1, -1}},
			.angle_90 = {{0, -1}, {0, 0}, {1, 0}, {1, 1}},
			.angle_180 = {{-1, 1}, {0, 1}, {0, 0}, {1, 0}},
			.angle_270 = {{-1, -1}, {-1, 0}, {0, 0}, {0, 1}},
		},
		.cube5,
	},
	.left_right_4 = {
		.left_right_4,
		{
			.angle_0 = {{-1, -1}, {0, 0}, {0, -1}, {1, 0}},
			.angle_90 = {{0, 1}, {0, 0}, {1, 0}, {1, -1}},
			.angle_180 = {{-1, 0}, {0, 1}, {0, 0}, {1, 1}},
			.angle_270 = {{-1, 1}, {-1, 0}, {0, 0}, {0, -1}},
		},
		.cube6,
	},
	.branch_4     = {
		.branch_4,
		{
			.angle_0 = {{-1, 0}, {0, 0}, {1, 0}, {0, -1}},
			.angle_90 = {{0, 1}, {0, 0}, {1, 0}, {0, -1}},
			.angle_180 = {{-1, 0}, {0, 0}, {1, 0}, {0, 1}},
			.angle_270 = {{-1, 0}, {0, 0}, {0, 1}, {0, -1}},
		},
		.cube7,
	},
}

random_polyomino :: proc() -> ^polyomino {
	shape := polyomino_shape(rand.int_max(len(all_polyomino)))
	return &all_polyomino[shape]
}
