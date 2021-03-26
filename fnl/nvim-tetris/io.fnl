(module nvim-tetris.io
  {require {a nvim-tetris.aniseed.core
            v nvim-tetris.aniseed.view
            const nvim-tetris.const
            util nvim-tetris.util}})

(def- api vim.api)
(def- piece_ns_name "piece_ns")
(def- shadow_ns_name "shadow_ns")
(def- locked_ns_name "locked_ns")
(var buf nil)
(var win nil)
(var piece_ns nil) ; namespace for piece highlights
(var shadow_ns nil) ; namespace for shadow highlights
(var locked_ns nil) ; namespace for locked highlights

(def- square_width 2) ; number of columns in a board square
(def- square_height 1) ; number of rows in a board square
(def- square_bytes_per_char 3)
(def- header_height 1)
(def- win_char_width (* const.screen_cols square_width)) ; window width in chars
(def- win_char_height (+ (* const.screen_rows square_height) header_height)) ; window height in chars

(defn remove_row [row]
  (let [buf_row (a.inc (- const.screen_rows row))
        top_row 1]
    (api.nvim_buf_set_lines buf buf_row (a.inc buf_row) false [])
    (api.nvim_buf_set_lines buf top_row top_row false [(string.rep "██" const.screen_cols)])
    (api.nvim_buf_add_highlight buf -1 "TetrisBackground" top_row 0 -1)))

; draw the play board to the screen
; relevant api functions:
;   - nvim_buf_set_lines for setting entire lines
;   - nvim_buf_set_text for setting segments of lines
; NOTE: nvim_buf_add_highlight is byte indexed
;   - need to convert from columns to bytes before calling it
; [{:coords [col row] :colour "string"}] -> nil
(defn draw_squares [squares ns]
  (let [filtered_squares (util.squares_in_bounds squares)]
    (each [i square (ipairs filtered_squares)]
      (let [{:coords [col row] : colour} square
            x (a.dec col)
            y (+ (- const.screen_rows row) header_height)
            start_col (* x 2)
            start_hl (* start_col 3)
            end_hl (+ start_hl (* square_width square_bytes_per_char))]
        (api.nvim_buf_add_highlight buf ns colour y start_hl end_hl)))))

(defn draw_piece_squares [squares]
  (draw_squares squares piece_ns))

(defn draw_shadow_squares [squares]
  (draw_squares squares shadow_ns))

(defn draw_locked_squares [squares]
  (draw_squares squares locked_ns))

(defn clear_ns [ns]
  (api.nvim_buf_clear_namespace buf ns 0 -1))

(defn clear_piece_ns []
  (clear_ns piece_ns))

(defn clear_shadow_ns []
  (clear_ns shadow_ns))

(defn clear_locked_ns []
  (clear_ns locked_ns))

; Just a helper for centering a string horizontally in a buffer
(defn- center [str]
  (let [width (api.nvim_win_get_width 0)
        shift (- (math.floor (/ width 2)) (math.floor (/ (string.len str) 2)))]
    (.. (string.rep " " shift) str)))

; Sets all the tetris highlights based on the `colours` array in const.fnl
(defn- init_highlights []
  (each [group colours (pairs const.colours)]
    (api.nvim_command (.. "hi " group " guifg=" colours.guifg " ctermfg=" colours.ctermfg))))

; create the initial buffer and window for drawing the game in
(defn init_window []
  (set buf (api.nvim_create_buf false true))
  (api.nvim_buf_set_option buf "bufhidden" "wipe")
  (api.nvim_buf_set_option buf "filetype" "tetris")
  (api.nvim_buf_set_name buf "tetris")
  (let [width (api.nvim_get_option "columns")
      height (api.nvim_get_option "lines")
      col (math.ceil (/ (- width win_char_width) 2))
      row (math.ceil (a.dec (/ (- height win_char_height) 2)))
      border_opts {:style "minimal"
                   :relative "editor"
                   :width win_char_width
                   :height win_char_height
                   :row (a.dec row)
                   :col (a.dec col)}
      opts {:style "minimal"
            :relative "editor"
            :width win_char_width
            :height win_char_height
            : row
            : col}]
    (set win (api.nvim_open_win buf true opts))
    (api.nvim_buf_set_lines buf 0 -1 false [(center "Tetris")])
    (for [i 1 const.screen_rows]
      (api.nvim_buf_set_lines buf i i false [(string.rep "██" const.screen_cols)])
      (api.nvim_buf_add_highlight buf -1 "TetrisBackground" i 0 -1))
    (api.nvim_buf_add_highlight buf -1 "TetrisHeader" 0 0 -1))
  (set piece_ns (api.nvim_create_namespace piece_ns_name))
  (set shadow_ns (api.nvim_create_namespace shadow_ns_name))
  (set locked_ns (api.nvim_create_namespace locked_ns_name))
  (init_highlights))

(defn set_game_maps []
  (let [mappings {"<Left>" "move_left()"
                  "<Right>" "move_right()"
                  "<Up>" "rotate()"
                  "<Down>" "soft_drop()"
                  "<Space>" "hard_drop()"}]
    (each [k v (pairs mappings)]
      (api.nvim_buf_set_keymap buf "n" k (.. ":lua require\"nvim-tetris.game\"." v "<cr>") {:nowait true
                                                                                            :noremap true
                                                                                            :silent true}))
    (let [other_chars ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"]]
      (each [k v (ipairs other_chars)]
        (api.nvim_buf_set_keymap buf "n" v "" {:nowait true :noremap true :silent true})
        (api.nvim_buf_set_keymap buf "n" (string.upper v) "" {:nowait true :noremap true :silent true})
        (api.nvim_buf_set_keymap buf "n" (.. "<c-" v ">") "" {:nowait true :noremap true :silent true})))))

(defn prepare_game_cleanup []
  (api.nvim_command "autocmd BufWipeout tetris lua require(\"nvim-tetris.game\").stop_game()"))

; (defn- draw_some_squares []
;   (init_window)
;   (global squares [{:coords [10 4]
;                     :colour "TetrisIPiece"}
;                    {:coords [1 9]
;                     :colour "TetrisJPiece"}
;                    {:coords [2 4]
;                     :colour "TetrisLPiece"}
;                    {:coords [5 19]
;                     :colour "TetrisOPiece"}
;                    {:coords [4 20]
;                     :colour "TetrisSPiece"}
;                    {:coords [6 6]
;                     :colour "TetrisTPiece"}
;                    {:coords [9 1]
;                     :colour "TetrisZPiece"}])
;   (draw_squares squares))
; (draw_some_squares)
