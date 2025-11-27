package Tetris

import "core:fmt"

default_size: [2]f32 = {0.5, 0.9}
default_offset: [2]f32 = {0.5, 0.05}

board :: struct {
	num_rows: i32,
	num_cols: i32,
	size:     [2]f32,
	offset:   [2]f32,
	cells:    [dynamic]cell_type,
}

init_board :: proc(_rows: i32, _cols: i32) -> (b: board) {
	b.num_rows = _rows
	b.num_cols = _cols
	b.size = default_size
	b.offset = default_offset
	resize(&b.cells, b.num_rows * b.num_cols)
	return b
}

cell :: proc(b: board, x, y: i32) -> cell_type {
	return b.cells[x + y * b.num_cols]
}

stamp_piece :: proc(b: board, p: piece) {
	for pos in p.polyomino.cell[p.rotation] {
		p2 := p.position + pos
		fmt.printfln(" %d %d", p2[0], p2[1])

		if p2[0] >= 0 && p2[0] < b.num_cols && p2[1] >= 1 && p2[1] < b.num_rows {
			b.cells[p2[0] + p2[1] * b.num_cols] = .cube
		}

	}

}
