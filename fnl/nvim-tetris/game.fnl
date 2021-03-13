(module nvim-tetris.game
  {require {const nvim-tetris.const
            util nvim-tetris.util
            v aniseed.view
            tetris_io nvim-tetris.io
            fennel fennel
            a aniseed.core}})

; ------------ ALIASES -------------

(def- states const.game_states)
(def- api vim.api)

; -------- CONSTS AND VARS ---------

(def- occupied_squares {}) ; 2D table of bools indicating squares occupied by locked pieces (for collision detection)
(var piece {}) ; current piece being controlled by the player
(var piece_pivot [5 20]) ; current piece pivot location (column, row)
(var shadow_offset 0)
(var piece_rotation 0)
(var game_state states.intro)
(var timer nil)
(var remaining_appearing_frames 0)
(var falling_delay_frames 0)
(var locking_delay_frames 0)

;; FOR LEVEL PROGRESSION
(var level 0) ; TODO
(var lines_cleared 0) ; TODO

;; FOR SAVING PIECES
(var next_piece 1) ; TODO
(var saved_piece 1) ; TODO

; --------- HELPER FUNCS -----------

(defn- remove_row [row]
  (for [r row (a.dec const.rows)]
    (tset occupied_squares r (. occupied_squares (a.inc r))))
  (for [c 1 const.columns]
    (tset (. occupied_squares const.rows) c false))
  (tetris_io.remove_row row))

(defn- check_for_cleared_rows [piece_squares]
  (let [rows (util.get_square_rows piece_squares)]
    (each [_ row (ipairs rows)]
      (if (util.row_full? row occupied_squares)
        (remove_row row)))))

(defn- lock_piece []
  (let [piece_squares (util.get_piece_squares piece_pivot piece piece_rotation)]
    (tetris_io.clear_piece_ns)
    (tetris_io.clear_shadow_ns)
    (tetris_io.draw_locked_squares piece_squares)
    (each [_ square (ipairs piece_squares)]
      (let [{:coords [col row]} square]
        (tset (. occupied_squares row) col true)))
    (check_for_cleared_rows piece_squares)))

(defn- reset_falling_delay []
  (set falling_delay_frames (util.get_gravity level)))

; use when pausing the game
(defn- stop_timer []
  (timer:stop))

; use when quitting the game
(defn- close_timer []
  (timer:close))

; ----------- MOVEMENT -------------

(defn move_left []
  (let [[col row] piece_pivot
        new_pivot [(a.dec col) row]]
    (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot))))

(defn move_right []
  (let [[col row] piece_pivot
        new_pivot [(a.inc col) row]]
    (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot))))

; TODO: wallkick
(defn rotate_left []
  (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares piece_pivot piece (a.dec piece_rotation)) occupied_squares))
    (set piece_rotation (a.dec piece_rotation))))

; TODO: wallkick
(defn rotate_right []
  (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares piece_pivot piece (a.inc piece_rotation)) occupied_squares))
    (set piece_rotation (a.inc piece_rotation))))

(defn soft_drop []
  (let [[col row] piece_pivot
        new_pivot [col (a.dec row)]]
    (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot))))

(defn hard_drop []
  (let [[col row] piece_pivot
        new_pivot [col (- row shadow_offset)]]
    (if (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot))))

; ---------- INIT STATES -----------

(defn- do_game_over []
  (print "GAME OVER")
  (close_timer))

(defn- init_appearing []
  (set remaining_appearing_frames const.entry_delay)
  (set piece (util.get_random_piece))
  (set piece_pivot [5 20])
  (set piece_rotation 0)
  (when (util.piece_collides_or_out_of_bounds? (util.get_piece_squares piece_pivot piece piece_rotation) occupied_squares)
    (do_game_over))
  (set game_state states.appearing))

; (util.piece_collides_or_out_of_bounds? (util.get_piece_squares [5 20] (. const.piece_types 1) 0) occupied_squares)
; (v.serialise occupied_squares)

(defn- init_falling []
  (reset_falling_delay)
  (set game_state states.falling))

(defn- init_locking []
  (set locking_delay_frames const.lock_delay)
  (set game_state states.locking))

; ---------- FRAME LOGIC -----------

; logic for a single frame when game is in the "appearing" state
(defn- do_appearing_frame []
  (if (> remaining_appearing_frames 0)
    (set remaining_appearing_frames (a.dec remaining_appearing_frames))
    (init_falling)))

; logic for a single frame when game is in the "falling" state
(defn- do_falling_frame []
  (if (> falling_delay_frames 0)
    (set falling_delay_frames (a.dec falling_delay_frames))
    (let [[col row] piece_pivot
          new_pivot [col (a.dec row)]
          new_squares (util.get_piece_squares new_pivot piece piece_rotation)]
      (if (not (util.piece_collides_or_out_of_bounds? new_squares occupied_squares))
        (do
          (set piece_pivot new_pivot)
          (reset_falling_delay))
        (init_locking)))))

; logic for a single frame when game is in the "locking" state
(defn- do_locking_frame []
  (if (> locking_delay_frames 0)
    (set locking_delay_frames (a.dec locking_delay_frames))
    (do
      (lock_piece)
      (init_appearing))))

; logic for a single frame when game is in the "intro" state
(defn- do_intro_frame []
  (comment "TODO")
  (init_appearing))

; logic for a single frame when game is in the "paused" state
(defn- do_paused_frame []
  (comment "TODO"))

; logic for a single frame when game is in the "gameover" state
(defn- do_gameover_frame []
  (comment "TODO"))

; keep current piece in its own namespace, so its easy to clear
; clear highlights before moving and re-highlighting
; don't need to redraw locked pieces, they move when rows are inserted above
(defn- draw_all_pieces []
  (let [piece_squares (util.get_piece_squares piece_pivot piece piece_rotation)
        vert_dist (util.get_shadow_offset piece_squares occupied_squares)
        shadow_squares (util.get_shadow_squares piece_squares vert_dist)]
    (set shadow_offset vert_dist)
    (tetris_io.clear_piece_ns) ; clear the namespace for the current piece's highlights
    (tetris_io.clear_shadow_ns) ; clear the namespace for the current shadow's highlights
    (tetris_io.draw_shadow_squares shadow_squares) ; draw shadow
    (tetris_io.draw_piece_squares piece_squares))) ; draw current piece

; the logic to be executed on every game frame
(defn- do_frame []
  (match game_state
    states.appearing (do_appearing_frame)
    states.falling (do_falling_frame)
    states.locking (do_locking_frame)
    states.intro (do_intro_frame)
    states.paused (do_paused_frame)
    states.gameover (do_gameover_frame))
  (draw_all_pieces))

; ---------- INIT FUNCTIONS ------------

; starts the main game loop
(defn- start_timer []
  (timer:start const.frame_delay const.frame_delay (vim.schedule_wrap do_frame)))

; treat the row below, and the columns to the left and right of the board
; as if they are occupied by squares (for collision detection)
(defn- init_occupied_squares []
  (for [i 1 const.rows]
    (tset occupied_squares i {})
    (for [j 1 const.columns]
      (tset (. occupied_squares i) j false))))

; luv docs: https://github.com/luvit/luv/blob/master/docs.md
; Create a timer handle (implementation detail: uv_timer_t).
(defn- init_timer [] 
  (set timer (vim.loop.new_timer)))

; ---------- MAIN FUNCTION -------------

(defn start []
  (tetris_io.init_window)
  (init_occupied_squares)
  (init_timer)
  (tetris_io.set_game_maps)
  (start_timer))

; (start)
; (close_timer)
; (stop_timer)
