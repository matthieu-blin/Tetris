package Tetris
import "core:fmt"

game :: struct {
	board:             board,
	current_polyomino: piece,
	next_polyomino:    polyomino,
}

init_game :: proc(w, h: i32) -> (g: game) {
	g.board = init_board(w, h)
	g.current_polyomino.polyomino = random_polyomino()
	g.next_polyomino = random_polyomino()

	g.current_polyomino.position = {5, 5}

	init_input()
	return g
}

game_handle_input :: proc(g: ^game) {
	actions = {}
	if !handle_input(&actions) {
		return
	}

	for a in action {
		if (!actions[a]) {
			continue
		}
		#partial switch a {
		case .left:
			g.current_polyomino.position += {-1, 0}
		case .right:
			g.current_polyomino.position += {1, 0}
		case .rotate_left:
			g.current_polyomino.rotation = rotation(
				(i32(g.current_polyomino.rotation) + 1) % cap(rotation),
			)
		case .rotate_right:
			g.current_polyomino.rotation = rotation(
				(i32(g.current_polyomino.rotation) - 1) % cap(rotation),
			)
		}
	}
}

tick_rate := f64(0.2)
time_since_last_tick := f64(0)

game_update :: proc(g: ^game, dt: f64) {
	time_since_last_tick -= dt
	if (time_since_last_tick < 0) {
		//pre update
		unstamp_piece(g.board, g.current_polyomino)

		//update
		game_handle_input(g)

		//post update
		stamp_piece(g.board, g.current_polyomino)

		time_since_last_tick = tick_rate
	}
}
