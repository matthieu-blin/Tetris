package Tetris
import "core:fmt"

game :: struct {
	board:             board,
	current_polyomino: piece,
	next_polyomino:    polyomino,
}

init_game :: proc(w, h: i32) -> (g: game) {
	g.board = init_board(w, h)
	game_next_piece(&g)
	init_input()
	return g
}

game_next_piece :: proc(g: ^game) {
	p: piece = {
		polyomino     = random_polyomino(),
		position = {g.board.num_cols / 2, g.board.num_rows - 1},
		next_position = {g.board.num_cols / 2, g.board.num_rows - 1},
	}
	g.current_polyomino = p
	g.next_polyomino = random_polyomino()
	game_update_current_polyomino(g)
}

game_handle_input :: proc(g: ^game, dt: f64) -> bool {
	handled := false
	handle_input(&actions, dt)

	for a in action {
		if (actions[a] < 0 || actions[a] > 0 && actions[a] < input_config_delay[a]) {
			continue
		}
		handled = true
		#partial switch a {
		case .left:
			g.current_polyomino.next_position.x = g.current_polyomino.position.x - 1
		case .right:
			g.current_polyomino.next_position.x = g.current_polyomino.position.x + 1
		case .down:
			g.current_polyomino.next_position.y = g.current_polyomino.position.y - 1
		case .cancel:
			g.current_polyomino.next_position.y = g.current_polyomino.position.y + 1
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
	return handled
}

tick_rate := f64(1.2)
time_since_last_tick := f64(0)

game_update :: proc(g: ^game, dt: f64) {
	if (game_handle_input(g, dt)) {
		game_update_current_polyomino(g)
	}
	time_since_last_tick -= dt
	if (time_since_last_tick < 0) {
		g.current_polyomino.next_position.y = g.current_polyomino.position.y - 1
		if (game_update_current_polyomino(g)) {
			game_next_piece(g)
		}

		time_since_last_tick = tick_rate
	}
}

game_update_current_polyomino :: proc(g: ^game) -> (rollback: bool) {
	if g.current_polyomino.position == g.current_polyomino.next_position &&
	   g.current_polyomino.rotation == g.current_polyomino.next_rotation {
		return
	}

	//unstamp
	unstamp_piece(g.board, g.current_polyomino)
	if (can_stamp_piece_next(g.board, g.current_polyomino)) {
		g.current_polyomino.position = g.current_polyomino.next_position
		g.current_polyomino.rotation = g.current_polyomino.next_rotation
	} else {
		g.current_polyomino.next_position = g.current_polyomino.position
		g.current_polyomino.next_rotation = g.current_polyomino.rotation
		rollback = true
	}
	//stamp
	stamp_piece(g.board, g.current_polyomino)
	return

}
