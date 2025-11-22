package Tetris

import rl "vendor:raylib"

window_width := 640
window_heigth := 480
cubeT: rl.Texture2D


init_texture :: proc() {
	cubeT = rl.LoadTexture("assets/classic/cube.png")
}


draw_board :: proc(b: board) {
	index := 0
	cellsize: [2]f32 = {f32(window_width) * b.cellsize[0], f32(window_heigth) * b.cellsize[1]}
	for y: i32 = 0; y < b.num_cols; y += 1 {
		for x: i32 = 0; x < b.num_rows; x += 1 {
			pos: [2]f32 = {f32(x) * cellsize[0], f32(y) * cellsize[1]}
			defer index += 1
			switch b.cells[index] {
			case .none:
			case .cube:
				rl.DrawTextureEx(cubeT, pos, 0, 1, rl.RED)
			}
		}
	}
}
