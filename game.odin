package Tetris
import "core:fmt"

game_state :: enum {
	intro,
	game,
	won,
	gameover,
}
game :: struct {
	board:                board,
	current_polyomino:    piece,
	next_polyomino:       polyomino,
	current_polyomino_p2: piece,
	next_polyomino_p2:    polyomino,
	nb_line:              i32,
	time_left:            f64,
	state:                game_state,
}

init_game :: proc(w, h: i32) -> (g: game) {
	g.board = init_board(w, h)
	g.nb_line = 12
	g.time_left = 5
	g.state = .intro
	game_next_piece(&g)
	game_next_piece_p2(&g)
	init_input()
	return g
}

game_next_piece :: proc(g: ^game) {
	p: piece = {
		polyomino     = random_polyomino(),
		position      = {g.board.num_cols / 4, g.board.num_rows - 1},
		next_position = {g.board.num_cols / 4, g.board.num_rows - 1},
	}
	g.current_polyomino = p
	g.next_polyomino = random_polyomino()
	game_update_current_polyomino(g)
}

game_next_piece_p2 :: proc(g: ^game) {
	p2: piece = {
		polyomino     = random_polyomino(),
		position      = {g.board.num_cols * 3 / 4, g.board.num_rows - 1},
		next_position = {g.board.num_cols * 3 / 4, g.board.num_rows - 1},
	}
	g.current_polyomino_p2 = p2
	g.next_polyomino_p2 = random_polyomino()
	game_update_current_polyomino_p2(g)
}

game_handle_input :: proc(g: ^game, dt: f64) -> bool {
	handled := false
	handle_input(&actions_p1, &actions_p2, dt)

	for a in action {
		if (actions_p1[a] < 0 || actions_p1[a] > 0 && actions_p1[a] < input_config_delay[a]) {
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
				(i32(g.current_polyomino.rotation) - 1) < 0 ? cap(angle) - 1 : (i32(g.current_polyomino.rotation) - 1),
			)
		}
	}
	for a in action {
		if (actions_p2[a] < 0 || actions_p2[a] > 0 && actions_p2[a] < input_config_delay[a]) {
			continue
		}
		handled = true
		#partial switch a {
		case .left:
			g.current_polyomino_p2.next_position.x = g.current_polyomino_p2.position.x - 1
		case .right:
			g.current_polyomino_p2.next_position.x = g.current_polyomino_p2.position.x + 1
		case .down:
			g.current_polyomino_p2.next_position.y = g.current_polyomino_p2.position.y - 1
		case .cancel:
			g.current_polyomino_p2.next_position.y = g.current_polyomino_p2.position.y + 1
		case .rotate_left:
			g.current_polyomino_p2.next_rotation = angle(
				(i32(g.current_polyomino_p2.rotation) + 1) % cap(angle),
			)
		case .rotate_right:
			g.current_polyomino_p2.next_rotation = angle(
				(i32(g.current_polyomino_p2.rotation) - 1) < 0 ? cap(angle) - 1 : (i32(g.current_polyomino_p2.rotation) - 1),
			)
		}
	}
	return handled
}

tick_rate := f64(1.2)
time_since_last_tick := f64(0)

game_update :: proc(g: ^game, dt: f64) {
	g.time_left -= dt
	if (g.state == .intro) {
		if (g.time_left <= 0) {
			g.state = .game
			g.time_left = 7 * 60
		}
	}

	if (g.state == .game) {
		if (game_handle_input(g, dt)) {
			game_update_current_polyomino(g)
			game_update_current_polyomino_p2(g)
		}
		time_since_last_tick -= dt
		if (time_since_last_tick < 0) {
			g.current_polyomino.next_position.y = g.current_polyomino.position.y - 1
			check_line := false
			if (game_update_current_polyomino(g)) {
				check_line = true
				game_next_piece(g)
			}

			g.current_polyomino_p2.next_position.y = g.current_polyomino_p2.position.y - 1
			if (game_update_current_polyomino_p2(g)) {
				game_next_piece_p2(g)
			}
			if check_line {
				g.nb_line -= check_and_remove_full_rows(g.board)
				if (g.nb_line <= 0) {
					g.nb_line = 0
					g.state = .won
				}
			}

			time_since_last_tick = tick_rate
		}
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
game_update_current_polyomino_p2 :: proc(g: ^game) -> (rollback: bool) {
	if g.current_polyomino_p2.position == g.current_polyomino_p2.next_position &&
	   g.current_polyomino_p2.rotation == g.current_polyomino_p2.next_rotation {
		return
	}

	//unstamp
	unstamp_piece(g.board, g.current_polyomino_p2)
	if (can_stamp_piece_next(g.board, g.current_polyomino_p2)) {
		g.current_polyomino_p2.position = g.current_polyomino_p2.next_position
		g.current_polyomino_p2.rotation = g.current_polyomino_p2.next_rotation
	} else {
		g.current_polyomino_p2.next_position = g.current_polyomino_p2.position
		g.current_polyomino_p2.next_rotation = g.current_polyomino_p2.rotation
		rollback = true
	}
	//stamp
	stamp_piece(g.board, g.current_polyomino_p2)
	return

}
