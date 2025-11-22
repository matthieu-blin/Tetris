package Tetris

import rl "vendor:raylib"

game: struct {
	b: board,
}
main :: proc() {

	rl.InitWindow(640, 480, "Tetris")
	defer rl.CloseWindow()

	b := init_board(10, 5)
	init_texture()

	b.cells[3] = .cube
	b.cells[43] = .cube


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.DARKPURPLE)

		draw_board(b)

		rl.EndDrawing()
	}
}
