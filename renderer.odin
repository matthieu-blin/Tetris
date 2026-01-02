package Tetris

import fmt "core:fmt"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

cubeT: rl.Texture2D
emptyT: rl.Texture2D
window_size: [2]f32 //float for compute
font: rl.Font


init_renderer :: proc(width_in_pixel: i32, height_in_pixel: i32, title: cstring) {
	init_window(width_in_pixel, height_in_pixel, title)
	init_texture()
	font := rl.LoadFontEx("assets/monogram.ttf", 64, nil, 0)
}

init_window :: proc(width_in_pixel: i32, height_in_pixel: i32, title: cstring) {
	window_size = {f32(width_in_pixel), f32(height_in_pixel)}
	rl.InitWindow(width_in_pixel, height_in_pixel, title)
	rl.SetTargetFPS(60)
}

destroy_window :: proc() {
	rl.CloseWindow()
}

window_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}
init_texture :: proc() {
	emptyT = rl.LoadTexture("assets/classic/empty.png")
	cubeT = rl.LoadTexture("assets/classic/cube.png")
}

//compute cell edge
// cells are just square, want to show entire board
// pick max board edge
cell_edge :: proc(b: board) -> f32 {
	board_size_in_pixel := b.size * window_size
	if (board_size_in_pixel.x < board_size_in_pixel.y) {
		return board_size_in_pixel.x / f32(b.num_cols)
	}
	return board_size_in_pixel.y / f32(b.num_rows)
}

//return offset in pixel for board
align_board :: proc(b: board) -> (board_position: [2]f32) {
	offset_in_pixel := b.offset * window_size
	cell := cell_edge(b)
	//do not compute using b.size * window_size but using cell size
	board_size_in_pixel: [2]f32 = {cell * f32(b.num_cols), cell * f32(b.num_rows)}
	//align bottom - center
	board_position.x = offset_in_pixel.x - (board_size_in_pixel.x) / f32(2)
	board_position.y = board_size_in_pixel.y - offset_in_pixel.y
	return
}

box_to_pixel :: proc(size: [2]f32, offset: [2]f32) -> (pos: [2]f32, size_px: [2]f32) {
	size_in_pixel := size * window_size
	size_px.x = (size_in_pixel.x)
	size_px.y = (size_in_pixel.y)
	//align
	offset_in_pixel := offset * window_size
	//center
	pos.x = (offset_in_pixel.x - (size_in_pixel.x) / f32(2))
	pos.y = (offset_in_pixel.y - (size_in_pixel.y) / f32(2))
	return
}

draw_board :: proc(b: board) {
	index := 0
	cell_edge_in_pixel := cell_edge(b)
	board_position := align_board(b)
	scale := cell_edge_in_pixel / f32(cubeT.width)
	for y: i32 = 0; y < b.num_rows; y += 1 {
		for x: i32 = 0; x < b.num_cols; x += 1 {
			pos: [2]f32 = {f32(x) * cell_edge_in_pixel, -f32(y) * cell_edge_in_pixel}
			pos += board_position
			defer index += 1
			switch b.cells[index].type {
			case .none:
				rl.DrawTextureEx(emptyT, pos, 0, scale, rl.Color{255, 255, 255, 128})
			case .cube1:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.RED)
			case .cube2:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.ORANGE)
			case .cube3:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.YELLOW)
			case .cube4:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.GREEN)
			case .cube5:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.BLUE)
			case .cube6:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.PURPLE)
			case .cube7:
				rl.DrawTextureEx(cubeT, pos, 0, scale, rl.PINK)
			}
		}
	}
}


render :: proc(g: game) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)


	#partial switch g.state {

	case .intro:
		str: cstring = "7 / 12"
		str_size := rl.MeasureText(str, 100)
		rl.DrawTextEx(
			font,
			str,
			rl.Vector2{(window_size.x - f32(str_size)) / 2, window_size.y / 2 - 32},
			100,
			2,
			rl.WHITE,
		)

	case .menu:
		y_order := -len(main_menu) / 2
		index := 0
		for button in main_menu {
			color := rl.WHITE
			if index == main_menu_selected {
				color = rl.GREEN
			}
			pos, size := box_to_pixel(button.size, button.offset)
			str_size := rl.MeasureText(strings.unsafe_string_to_cstring(button.text), i32(size.y))
			str_pos_x := pos.x + (size.x - f32(str_size)) / f32(2)
			rl.DrawTextEx(
				font,
				strings.unsafe_string_to_cstring(button.text),
				rl.Vector2{str_pos_x, pos.y + f32(y_order) * (size.y + 2)},
				size.y,
				2,
				color,
			)
			rl.DrawRectangleLines(
				i32(pos.x),
				i32(pos.y + f32(y_order) * (size.y + 2)),
				i32(size.x),
				i32(size.y),
				color,
			)
			y_order += 1
			index += 1
		}


	case .game:
		draw_board(g.board)
		buf: [4]byte
		nb_line := g.nb_line
		nb_line_str := strconv.write_int(buf[:], i64(nb_line), 10)
		time_buf: [16]byte
		time := g.type == .classic ? -g.time_left : g.time_left
		builder := strings.builder_from_bytes(time_buf[:])
		mins := int(time / 60.0)
		seconds := int(time) % 6
		strings.write_int(&builder, mins)
		strings.write_byte(&builder, ':')

		if seconds < 10 {strings.write_int(&builder, 0)}
		strings.write_int(&builder, seconds)
		rl.DrawTextEx(
			font,
			strings.unsafe_string_to_cstring(nb_line_str),
			rl.Vector2{window_size.x * 3 / 4, 15},
			38,
			2,
			rl.WHITE,
		)
		rl.DrawTextEx(
			font,
			strings.to_cstring(&builder),
			rl.Vector2{window_size.x / 4, 15},
			38,
			2,
			rl.WHITE,
		)

	case .gameover:
		str: cstring = "GAME OVER"
		str_size := rl.MeasureText(str, 100)
		rl.DrawTextEx(
			font,
			str,
			rl.Vector2{(window_size.x - f32(str_size)) / 2, window_size.y / 2 - 32},
			100,
			2,
			rl.RED,
		)

	case .won:
		str: cstring = "Victory"
		str_size := rl.MeasureText(str, 100)
		rl.DrawTextEx(
			font,
			str,
			rl.Vector2{(window_size.x - f32(str_size)) / 2, window_size.y / 2 - 32},
			100,
			2,
			rl.PINK,
		)
		rl.LoadShader("assets/shader/particle.vs", "assets/shader/particle.fs")
	/*   
    float outlineSize = 2.0f;
    float outlineColor[4] = { 1.0f, 0.0f, 0.0f, 1.0f };     // Normalized RED color
    float textureSize[2] = { (float)texture.width, (float)texture.height };

    // Get shader locations
    int outlineSizeLoc = GetShaderLocation(shdrOutline, "outlineSize");
    int outlineColorLoc = GetShaderLocation(shdrOutline, "outlineColor");
    int textureSizeLoc = GetShaderLocation(shdrOutline, "textureSize");

    // Set shader values (they can be changed later)
    SetShaderValue(shdrOutline, outlineSizeLoc, &outlineSize, SHADER_UNIFORM_FLOAT);
    SetShaderValue(shdrOutline, outlineColorLoc, outlineColor, SHADER_UNIFORM_VEC4);
    SetShaderValue(shdrOutline, textureSizeLoc, textureSize, SHADER_UNIFORM_VEC2);
*/


	}
	rl.DrawFPS(0, 0)
	rl.EndDrawing()
}
