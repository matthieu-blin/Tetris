package Tetris

import rl "vendor:raylib"

main :: proc() {

	init_window(640, 480, "Tetris")
	defer destroy_window()

	init_texture()

	game := init_game(10, 10)

	for (!window_should_close()) {
		render(game)
	}
}
