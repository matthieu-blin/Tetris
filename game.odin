package Tetris
import "core:fmt"

game_state :: enum {
	intro,
	game,
	won,
	gameover,
}

piece_handler :: struct {
	actions: [action]f64,
	piece:   piece,
	frozen:  bool,
}

player :: struct {
	start_position: [2]i32,
	piece_handler:  ^piece_handler,
	next:           ^polyomino,
	config:         input_config_keyboard,
}

game :: struct {
	board:          board,
	piece_handlers: [dynamic]^piece_handler,
	players:        [dynamic]^player,
	nb_line:        i32,
	time_left:      f64,
	state:          game_state,
}

init_game :: proc(w, h: i32) -> (g: game) {
	g.board = init_board(w, h)
	g.nb_line = 12
	g.time_left = 0
	g.state = .intro
	init_input()
	init_player(&g, {g.board.num_cols / 4, g.board.num_rows - 1}, input_config_p1)
	init_player(&g, {g.board.num_cols * 3 / 4, g.board.num_rows - 1}, input_config_p2)
	return g
}

init_player :: proc(g: ^game, start_position: [2]i32, config: input_config_keyboard) {
	new_player := new(player)
	new_player.start_position = start_position
	new_player.config = config
	new_player.piece_handler = new(piece_handler)
	next_piece(g, new_player)
	append(&g.players, new_player)
	append(&g.piece_handlers, new_player.piece_handler)
}

next_piece :: proc(g: ^game, p: ^player) {
	new_piece: piece = {
		polyomino     = p.next == nil ? random_polyomino() : p.next,
		position      = p.start_position,
		next_position = p.start_position,
	}
	p.piece_handler.piece = new_piece
	p.piece_handler.frozen = false
	p.next = random_polyomino()
}


game_handle_input :: proc(g: ^game, dt: f64) -> bool {
	handled := false
	for &p in g.players {
		handle_input(&p.piece_handler.actions, p.config, dt)
	}

	for &ph in g.piece_handlers {
		for a in action {
			if (ph.actions[a] < 0 || ph.actions[a] > 0 && ph.actions[a] < input_config_delay[a]) {
				continue
			}
			handled = true
			#partial switch a {
			case .left:
				ph.piece.next_position.x = ph.piece.position.x - 1
			case .right:
				ph.piece.next_position.x = ph.piece.position.x + 1
			case .down:
				ph.piece.next_position.y = ph.piece.position.y - 1
			case .cancel:
				ph.piece.next_position.y = ph.piece.position.y + 1
			case .rotate_left:
				ph.piece.next_rotation = angle((i32(ph.piece.rotation) + 1) % cap(angle))
			case .rotate_right:
				ph.piece.next_rotation = angle(
					(i32(ph.piece.rotation) - 1) < 0 ? cap(angle) - 1 : (i32(ph.piece.rotation) - 1),
				)
			}
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
		//update input
		any_input := game_handle_input(g, dt)

		//update affected pieces
		if any_input {
			for &ph in g.piece_handlers {
				//cant freeze on input
				game_update_polyomino(g, ph)
			}
		}

		//falling piece
		time_since_last_tick -= dt
		if (time_since_last_tick < 0) {
			got_frozen := false
			for &ph in g.piece_handlers {
				//move down every piece
				ph.piece.next_position.y = ph.piece.next_position.y - 1
				//update frozen state
				got_frozen |= game_update_polyomino(g, ph, true)
			}
			//check for line only if one piece got frozen
			if got_frozen {
				g.nb_line -= check_and_remove_full_rows(g.board)

				//compute next piece for player frozen piece handler
				for &p in g.players {
					if p.piece_handler.frozen {
						next_piece(g, p)
					}
				}

				//victory check
				if (g.nb_line <= 0) {
					g.nb_line = 0
					g.state = .won
				}


			}
			time_since_last_tick = tick_rate
		}
	}
}

//try to move piece to next pos/rotation
//fixme : kick
//if freeze is set and the piece can't move, will mark it as frozen
game_update_polyomino :: proc(g: ^game, ph: ^piece_handler, freeze := false) -> (froze: bool) {
	p := &ph.piece
	//nothing to do
	if p.position == p.next_position && p.rotation == p.next_rotation {
		return
	}

	//unstamp
	unstamp_piece(g.board, p)
	result, frost_bite := can_stamp_piece_next(g.board, p)
	if result {
		p.position = p.next_position
		p.rotation = p.next_rotation
	} else {
		p.next_position = p.position
		p.next_rotation = p.rotation
		if freeze {
			ph.frozen = frost_bite
			froze = true
		}
	}
	//stamp
	stamp_piece(g.board, p, ph.frozen)
	return

}
