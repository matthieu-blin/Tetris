package Tetris

board :: struct {
	num_rows: i32,
	num_cols: i32,
	cells:    [dynamic]i32,
}


init_board :: proc(_rows: i32, _cols: i32) -> (b: board) {
	b.num_rows = _rows
	b.num_cols = _cols
	x: []i32
	resize(&b.cells, b.num_rows * b.num_cols)
	return b
}

cell :: proc(b: board, x, y: i32) -> i32 {
	return b.cells[x + y * b.num_rows]
}
