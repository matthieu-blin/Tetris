package Tetris
import "core:fmt"

import rl "vendor:raylib"

main :: proc() {

	fmt.printfln("%d %d", all_polyomino[.line_4].cell[.angle_0][0])
	init_window(640, 480, "Tetris")
	defer destroy_window()

	init_texture()

	game := init_game(10, 10)

	for (!window_should_close()) {
		game_handle_input(&game)
		render(game)
	}
}
