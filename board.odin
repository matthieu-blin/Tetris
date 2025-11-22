package Tetris

default_board_width: f32 = 0.5
default_board_height: f32 = 0.9

board :: struct {
	num_rows: i32,
	num_cols: i32,
	width:    f32,
	height:   f32,
	cells:    [dynamic]cell_type,
	cellsize: [2]f32,
}

init_board :: proc(_rows: i32, _cols: i32) -> (b: board) {
	b.num_rows = _rows
	b.num_cols = _cols
	b.width = default_board_width
	b.height = default_board_height
	b.cellsize = {b.width / f32(b.num_cols + 1), b.height / f32(b.num_rows + 1)}
	resize(&b.cells, b.num_rows * b.num_cols)
	return b
}

cell :: proc(b: board, x, y: i32) -> cell_type {
	return b.cells[x + y * b.num_rows]
}
