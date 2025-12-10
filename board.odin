package Tetris

import "core:fmt"
import sl "core:slice"

default_size: [2]f32 = {0.6, 0.6}
default_offset: [2]f32 = {0.5, -0.3}

board :: struct {
	num_rows: i32,
	num_cols: i32,
	size:     [2]f32,
	offset:   [2]f32,
	cells:    [dynamic]struct {
		frozen: bool,
		type:   cell_type,
	},
}

init_board :: proc(_rows: i32, _cols: i32) -> (b: board) {
	b.num_rows = _rows
	b.num_cols = _cols
	b.size = default_size
	b.offset = default_offset
	resize(&b.cells, b.num_rows * b.num_cols)
	return b
}

stamp_piece :: proc(b: board, p: ^piece, freeze: bool = false) {
	for pos in p.polyomino.cell[p.rotation] {
		p2 := p.position + pos
		if p2[0] >= 0 && p2[0] < b.num_cols && p2[1] >= 0 && p2[1] < b.num_rows {
			b.cells[p2[0] + p2[1] * b.num_cols].type = p.polyomino.type
			b.cells[p2[0] + p2[1] * b.num_cols].frozen = freeze
		}
	}
}

unstamp_piece :: proc(b: board, p: ^piece) {
	for pos in p.polyomino.cell[p.rotation] {
		p2 := p.position + pos
		if p2[0] >= 0 && p2[0] < b.num_cols && p2[1] >= 0 && p2[1] < b.num_rows {
			b.cells[p2[0] + p2[1] * b.num_cols].type = .none
		}
	}
}

//result true if next movement do not overlap another not empty cell
//frost_bite if overlap include frozen cell
can_stamp_piece_next :: proc(b: board, p: ^piece) -> (result, frost_bite: bool) {

	result = true
	frost_bite = false
	for pos in p.polyomino.cell[p.next_rotation] {
		p2 := p.next_position + pos
		//bound check
		index := p2[0] + p2[1] * b.num_cols
		//bound check
		if index < 0 || index >= i32(len(b.cells)) {
			result = false
			frost_bite = index < 0
			continue
		}
		if p2[0] < 0 || p2[0] >= b.num_cols || p2[1] < 0 || p2[1] >= b.num_rows {
			result = false
			frost_bite = p2[1] < 0
			continue
		}

		//cell check
		if b.cells[index].type != .none {
			result = false
			frost_bite = b.cells[index].frozen
			if frost_bite {
				//early return if blocking cell is frozen
				return
			}
			//if not, must check other cell in case of frozen cell
		}
	}
	return
}

//could pass piece to check only specifics lines
check_and_remove_full_rows :: proc(b: board) -> (nline: i32) {
	nline = 0
	for x: i32 = b.num_rows - 1; x >= 0; x -= 1 {
		no_line := false
		for y: i32 = 0; y < b.num_cols; y += 1 {
			if (b.cells[x * b.num_cols + y].type == .none) {
				no_line = true
				break
			}
		}
		if !no_line {
			nline += 1
			//copy all array content above
			sliceA := b.cells[(x + 1) * b.num_cols:]
			sliceB := b.cells[(x) * b.num_cols:]
			copy(sliceB, sliceA)
		}
	}
	return
}
