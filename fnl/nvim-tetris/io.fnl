(module nvim-tetris.io
  {require {a nvim-tetris.aniseed.core
            v nvim-tetris.aniseed.view
            const nvim-tetris.const
            util nvim-tetris.util}})

(def- api vim.api)
(def- piece_ns_name "piece_ns")
(def- shadow_ns_name "shadow_ns")
(def- locked_ns_name "locked_ns")
(def- next_ns_name "next_ns")
(def- held_ns_name "held_ns")
(var buf nil)
(var win nil)
(var piece_ns nil) ; namespace for piece highlights
(var shadow_ns nil) ; namespace for shadow highlights
(var locked_ns nil) ; namespace for locked highlights
(var next_ns nil) ; namespace for next piece highlights
(var held_ns nil) ; namespace for held piece highlights

(def- square_width 2) ; number of columns in a board square
(def- square_height 1) ; number of rows in a board square
(def- square_bytes_per_char 3)
(def- header_height 1)
(def- win_char_width (* const.screen_cols square_width)) ; window width in chars
(def- win_char_height (+ (* const.screen_rows square_height) header_height)) ; window height in chars
(def- sidebar_char_width (* const.sidebar_width square_width))
(def- sidebar_byte_width (* sidebar_char_width square_bytes_per_char))
(def- board_char_width (* const.columns square_width))
(def- board_byte_width (* board_char_width square_bytes_per_char))

; setup row `row` with the colours for the game background and sidebar
(defn- init_row [row]
  (api.nvim_buf_set_lines buf row row false [(string.rep "██" const.screen_cols)])
  (api.nvim_buf_add_highlight buf -1 "TetrisSidebar" row 0 sidebar_byte_width)
  (api.nvim_buf_add_highlight buf -1 "TetrisBackground" row sidebar_byte_width (+ sidebar_byte_width board_byte_width))
  (api.nvim_buf_add_highlight buf -1 "TetrisSidebar" row (+ sidebar_byte_width board_byte_width) -1))

; Sets all the tetris highlights based on the `colours` array in const.fnl
(defn- init_highlights []
  (each [group colours (pairs const.colours)]
    (api.nvim_command (.. "hi " group " guifg=" colours.guifg " ctermfg=" colours.ctermfg))))


(defn remove_row [row]
  (let [buf_row (a.inc (- const.screen_rows row))]
    (api.nvim_buf_set_lines buf buf_row (a.inc buf_row) false [])
    (init_row 1)))

; NOTE: nvim_buf_add_highlight is byte indexed
;   - need to convert from columns to bytes before calling it
; [{:coords [col row] :colour "string"}] -> nil
(defn draw_squares [squares ns]
  (each [i square (ipairs squares)]
    (let [{:coords [col row] : colour} square
          x (+ const.sidebar_width (a.dec col))
          y (+ (- const.screen_rows row) header_height)
          start_col (* x 2)
          start_hl (* start_col 3)
          end_hl (+ start_hl (* square_width square_bytes_per_char))]
      (api.nvim_buf_add_highlight buf ns colour y start_hl end_hl))))

(defn draw_piece_squares [squares]
  (draw_squares (util.squares_in_bounds squares) piece_ns))

(defn draw_shadow_squares [squares]
  (draw_squares (util.squares_in_bounds squares) shadow_ns))

(defn draw_locked_squares [squares]
  (draw_squares (util.squares_in_bounds squares) locked_ns))

(defn draw_next_squares [squares]
  (draw_squares squares next_ns))

(defn draw_held_squares [squares]
  (draw_squares squares held_ns))

(defn clear_ns [ns]
  (api.nvim_buf_clear_namespace buf ns 0 -1))

(defn clear_piece_ns []
  (clear_ns piece_ns))

(defn clear_shadow_ns []
  (clear_ns shadow_ns))

(defn clear_locked_ns []
  (clear_ns locked_ns))

(defn clear_next_ns []
  (clear_ns next_ns))

(defn clear_held_ns []
  (clear_ns held_ns))

; Returns a copy of `str` centered in the window
(defn- center [str]
  (let [width (api.nvim_win_get_width 0)
        before (- (math.floor (/ width 2)) (math.floor (/ (string.len str) 2)))
        after (- width (+ before (string.len str)))]
    (.. (string.rep " " before) str (string.rep " " after))))

; Returns a copy of `body` with `str` at the start
(defn- str_start [str body]
  (.. str (string.sub body (a.inc (string.len str)))))

; Returns a copy of `body` with `str` at the end
(defn- str_end [str body]
  (.. (string.sub body 1 (- (string.len body) (string.len str))) str))

(defn- create_header []
  (str_start "    Held" (str_end "Next    " (center "Tetris"))))

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
    (api.nvim_buf_set_lines buf 0 -1 false [(create_header)])
    (for [i 1 const.screen_rows]
      (init_row i))
    (api.nvim_buf_add_highlight buf -1 "TetrisHeader" 0 0 -1))
  (set piece_ns (api.nvim_create_namespace piece_ns_name))
  (set shadow_ns (api.nvim_create_namespace shadow_ns_name))
  (set locked_ns (api.nvim_create_namespace locked_ns_name))
  (set next_ns (api.nvim_create_namespace next_ns_name))
  (set held_ns (api.nvim_create_namespace held_ns_name))
  (init_highlights))

(defn set_game_maps []
  (let [mappings {"<Left>" "move_left()"
                  "<Right>" "move_right()"
                  "<Up>" "rotate_right()"
                  "z" "rotate_left()"
                  "c" "hold_piece()"
                  "p" "pause_game()"
                  "<Down>" "soft_drop()"
                  "<Space>" "hard_drop()"}]
    (each [k v (pairs mappings)]
      (api.nvim_buf_set_keymap buf "n" k (.. ":lua require\"nvim-tetris.game\"." v "<cr>") {:nowait true
                                                                                            :noremap true
                                                                                            :silent true}))
    (let [other_chars ["a" "b" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "q" "r" "s" "t" "u" "v" "w" "x" "y"]]
      (each [k v (ipairs other_chars)]
        (api.nvim_buf_set_keymap buf "n" v "" {:nowait true :noremap true :silent true})
        (api.nvim_buf_set_keymap buf "n" (string.upper v) "" {:nowait true :noremap true :silent true})
        (api.nvim_buf_set_keymap buf "n" (.. "<c-" v ">") "" {:nowait true :noremap true :silent true})))))

(defn prepare_game_cleanup []
  (api.nvim_command "autocmd BufWipeout tetris lua require(\"nvim-tetris.game\").stop_game()"))
