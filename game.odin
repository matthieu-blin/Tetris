package Tetris

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
	stamp_piece(g.board, g.current_polyomino)
	return g
}
