package Tetris

import rl "vendor:raylib"

game: struct {
	b: board,
}
main :: proc() {

	init_window(640, 480, "Tetris")
	defer destroy_window()

	b := init_board(10, 10)
	init_texture()

	b.cells[0] = .cube
	b.cells[1] = .cube
	b.cells[3] = .cube
	b.cells[4] = .cube
	b.cells[5] = .cube
	b.cells[6] = .cube
	b.cells[10] = .cube
	b.cells[15] = .cube
	b.cells[20] = .cube
	b.cells[25] = .cube
	b.cells[35] = .cube
	b.cells[45] = .cube
	b.cells[55] = .cube
	b.cells[65] = .cube
	b.cells[75] = .cube
	b.cells[85] = .cube
	b.cells[95] = .cube


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.DARKPURPLE)

		draw_board(b)

		rl.EndDrawing()
	}
}
