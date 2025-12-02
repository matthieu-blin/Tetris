package Tetris
import "core:fmt"
import "core:time"

import rl "vendor:raylib"

main :: proc() {

	fmt.printfln("%d %d", all_polyomino[.line_4].cell[.angle_0][0])
	init_window(640, 480, "Tetris")
	defer destroy_window()

	init_texture()

	game := init_game(20, 20)

	previous := time.tick_now()
	now := previous
	for (!window_should_close()) {
		now = time.tick_now()
		delta := time.duration_seconds(time.tick_diff(previous, now))
		previous = now
		game_update(&game, delta)
		render(game)
	}
}
