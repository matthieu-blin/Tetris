package Tetris

menu_actions: [action]input_action = {}

button :: struct {
	text:   string,
	size:   [2]f32,
	offset: [2]f32, //only first button offset is valid for button group
}

main_menu := []button {
	{"classic", {0.5, 0.05}, {0.5, 0.5}},
	{"7/12 duo", {0.5, 0.05}, {0.5, 0.5}},
	{"theme", {0.5, 0.05}, {0.5, 0.5}},
}

main_menu_selected := 0
