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

	g.current_polyomino.next_position = {5, 5}

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
			g.current_polyomino.next_position = g.current_polyomino.position + {-1, 0}
		case .right:
			g.current_polyomino.next_position = g.current_polyomino.position + {1, 0}
		case .rotate_left:
			g.current_polyomino.next_rotation = angle(
				(i32(g.current_polyomino.rotation) + 1) % cap(angle),
			)
		case .rotate_right:
			g.current_polyomino.next_rotation = angle(
				(i32(g.current_polyomino.rotation) - 1) % cap(angle),
			)
		}
	}
}

tick_rate := f64(0.2)
time_since_last_tick := f64(0)

game_update :: proc(g: ^game, dt: f64) {
	game_handle_input(g)

	time_since_last_tick -= dt
	if (time_since_last_tick < 0) {

		game_update_current_polyomino(g)
		time_since_last_tick = tick_rate
	}
}

game_update_current_polyomino :: proc(g: ^game) {
	if g.current_polyomino.position == g.current_polyomino.next_position &&
	   g.current_polyomino.rotation == g.current_polyomino.next_rotation {
		return
	}

	if (can_stamp_piece_next(g.board, g.current_polyomino)) {
		//unstamp
		unstamp_piece(g.board, g.current_polyomino)
		//update
		g.current_polyomino.position = g.current_polyomino.next_position
		g.current_polyomino.rotation = g.current_polyomino.next_rotation
		//stamp
		stamp_piece(g.board, g.current_polyomino)
	} else {
		g.current_polyomino.next_position = g.current_polyomino.position
		g.current_polyomino.next_rotation = g.current_polyomino.rotation
	}

}
