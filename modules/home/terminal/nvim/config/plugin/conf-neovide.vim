set guifont=FiraCode\ Nerd\ Font:h16
if !exists("g:neovide")
	finish
endif

" Animations

let g:neovide_cursor_animation_length=0.01
let g:neovide_cursor_trail_length=0.8

let g:neovide_scroll_animation_length = 0.2

" Keys

let g:neovide_input_macos_option_key_is_meta = v:true

" Appearance

let g:neovide_transparency = 0.75
let g:neovide_window_blurred = v:true
let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0

let g:terminal_color_0 = '#000000'  " black
let g:terminal_color_1 = '#cc0403'  " red
let g:terminal_color_2 = '#19cb00'  " green
let g:terminal_color_3 = '#cecb00'  " yellow
let g:terminal_color_4 = '#0d73cc'  " blue
let g:terminal_color_5 = '#8e44ad'  " magenta
let g:terminal_color_6 = '#16a085'  " cyan
let g:terminal_color_7 = '#dddddd'  " white

