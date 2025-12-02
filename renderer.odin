package Tetris

import fmt "core:fmt"
import m "core:math"
import rl "vendor:raylib"

cubeT: rl.Texture2D
window_size: [2]f32 //float for compute


init_window :: proc(width_in_pixel: i32, height_in_pixel: i32, title: cstring) {
	window_size = {f32(width_in_pixel), f32(height_in_pixel)}
	rl.InitWindow(width_in_pixel, height_in_pixel, title)
	rl.SetTargetFPS(60)
}

destroy_window :: proc() {
	rl.CloseWindow()
}

window_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}
init_texture :: proc() {
	cubeT = rl.LoadTexture("assets/classic/cube.png")
}

//compute cell edge
// cells are just square, want to show entire board
// pick max board edge
celledge :: proc(b: board) -> f32 {
	board_size_in_pixel := b.size * window_size
	return board_size_in_pixel[0] / f32(b.num_cols)
}

//return offset in pixel for board
align_board :: proc(b: board) -> (board_position: [2]f32) {
	offset_in_pixel := b.offset * window_size
	board_size_in_pixel := b.size * window_size
	//align bottom - center
	board_position.x = offset_in_pixel.x - (board_size_in_pixel.x) / f32(2)
	board_position.y = board_size_in_pixel.y - offset_in_pixel.y
	return
}

draw_board :: proc(b: board) {
	index := 0
	cell_edge_in_pixel := celledge(b)
	board_position := align_board(b)
	scale := cell_edge_in_pixel / f32(cubeT.width)
	for y: i32 = 0; y < b.num_rows; y += 1 {
		for x: i32 = 0; x < b.num_cols; x += 1 {
			pos: [2]f32 = {f32(x) * cell_edge_in_pixel, -f32(y) * cell_edge_in_pixel}
			pos += board_position
			defer index += 1
			switch b.cells[index] {
			case .none:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.BLUE)
			case .cube:
				{
					rl.DrawTextureEx(cubeT, pos, 0, scale, rl.RED)
				}
			}
		}
	}
}


render :: proc(g: game) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.DARKPURPLE)

	draw_board(g.board)

	rl.EndDrawing()
}
