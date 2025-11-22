package Tetris

import rl "vendor:raylib"

main :: proc() {

	rl.InitWindow(640, 480, "Tetris")
	defer rl.CloseWindow()

	b := init_board(5, 10)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		rl.EndDrawing()
	}
}
