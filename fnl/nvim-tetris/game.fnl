(module nvim-tetris.game
  {require {const nvim-tetris.const
            util nvim-tetris.util
            v nvim-tetris.aniseed.view
            tetris_io nvim-tetris.io
            luv luv
            a nvim-tetris.aniseed.core}})

; ------------ ALIASES -------------

(def- states const.game_states)
(def- api vim.api)

; -------- CONSTS AND VARS ---------

(var occupied_squares nil) ; 2D table of bools indicating squares occupied by locked pieces (for collision detection)
(var piece nil) ; current piece being controlled by the player
(var piece_pivot nil) ; current piece pivot location (column, row)
(var shadow_offset nil)
(var piece_rotation nil)
(var game_state nil)
(var timer nil)
(var remaining_appearing_frames nil)
(var falling_delay_frames nil)
(var locking_delay_frames nil)

;; FOR LEVEL PROGRESSION
(var level nil)
(var lines_cleared nil)

;; FOR SAVING PIECES
(var upcoming_pieces nil)
(var next_piece nil) ; TODO
(var held_piece nil) ; TODO
(var can_hold? true)

; --------- HELPER FUNCS -----------

(defn- remove_row [row]
  (for [r row (a.dec const.rows)]
    (for [c 1 const.columns]
      (tset (. occupied_squares r) c (. (. occupied_squares (a.inc r)) c))))
  (for [c 1 const.columns]
    (tset (. occupied_squares const.rows) c false))
  (tetris_io.remove_row row))

(defn- check_for_cleared_rows [piece_squares]
  (let [rows (util.get_square_rows piece_squares)]
    (each [_ row (ipairs rows)]
      (when (util.row_full? row occupied_squares)
        (remove_row row)
        (set lines_cleared (a.inc lines_cleared))
        (when (= 0 (% lines_cleared const.lines_per_level))
          (set level (a.inc level)))))))

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

; insert repeats_per_block copies of each piece to upcoming_pieces
; then shuffle upcoming_pieces using fisher-yates
(defn- generate_upcoming_pieces []
  (set upcoming_pieces [])
  (let [num_piece_types (a.count const.piece_types)]
    ; generate pieces
    (for [i 1 num_piece_types]
      (for [j 1 const.repeats_per_block]
        (table.insert upcoming_pieces i)))
    ; shuffle
    (for [i (* num_piece_types const.repeats_per_block) 2 -1]
      (let [j (math.ceil (math.random (- i 1)))]
        (let [i_val (. upcoming_pieces i)
              j_val (. upcoming_pieces j)]
          (tset upcoming_pieces i j_val)
          (tset upcoming_pieces j i_val))))))

(defn- get_next_piece []
  (set next_piece (. const.piece_types (table.remove upcoming_pieces)))
  (if (= 0 (a.count upcoming_pieces))
    (generate_upcoming_pieces)))

(defn- draw_next_and_held []
  (let [next_squares (util.get_piece_squares const.next_pivot next_piece const.next_rotation)]
    (tetris_io.clear_next_ns)
    (tetris_io.draw_next_squares next_squares))
  (when (not (a.nil? held_piece))
    (let [held_squares (util.get_piece_squares const.held_pivot held_piece const.held_rotation)]
      (tetris_io.clear_held_ns)
      (tetris_io.draw_held_squares held_squares))))

; ---------- INIT STATES -----------

(defn stop_game []
  (when (not (timer:is_closing))
          (close_timer)))

(defn- do_game_over []
  (print "Game over at level" level)
  (stop_game))

(defn- init_appearing []
  (set remaining_appearing_frames const.entry_delay)
  (set piece next_piece)
  (set piece_pivot [5 20])
  (set piece_rotation 0)
  (get_next_piece)
  (draw_next_and_held)
  (when (util.piece_collides_or_out_of_bounds? (util.get_piece_squares piece_pivot piece piece_rotation) occupied_squares)
    (do_game_over))
  (set game_state states.appearing))

(defn- init_falling []
  (reset_falling_delay)
  (set game_state states.falling))

(defn- init_locking []
  (set locking_delay_frames const.lock_delay)
  (set game_state states.locking))

; ----------- MOVEMENT -------------

(defn move_left []
  (let [[col row] piece_pivot
        new_pivot [(a.dec col) row]]
    (when (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot)
      (when (= game_state states.locking)
          (init_falling)))))

(defn move_right []
  (let [[col row] piece_pivot
        new_pivot [(a.inc col) row]]
    (when (not (util.piece_collides_or_out_of_bounds? (util.get_piece_squares new_pivot piece piece_rotation) occupied_squares))
      (set piece_pivot new_pivot)
      (when (= game_state states.locking)
          (init_falling)))))

(defn- apply_rotation [new_rotation]
  (let [rotation_offset (util.get_rotation_offset piece_pivot piece piece_rotation new_rotation occupied_squares)]
    (when (not (a.nil? rotation_offset))
      (let [[d_x d_y] rotation_offset
            [x y] piece_pivot
            new_pivot [(+ x d_x) (+ y d_y)]]
        (set piece_pivot new_pivot)
        (set piece_rotation new_rotation)
        (when (= game_state states.locking)
          (init_falling))))))

(defn rotate_right []
  (apply_rotation (a.inc piece_rotation)))

(defn rotate_left []
  (apply_rotation (a.dec piece_rotation)))

(defn hold_piece []
  (when can_hold?
    (when (not (a.nil? held_piece))
      (table.insert upcoming_pieces next_piece.idx)
      (set next_piece held_piece))
    (set held_piece piece)
    (set can_hold? false)
    (init_appearing)))

(defn pause_game []
  (comment "TODO"))

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
      (set can_hold? true)
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
  (print "Level:" level)
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

(defn- init_globals []
  (set occupied_squares {})
  (set piece {})
  (set piece_pivot [5 20])
  (set shadow_offset 0)
  (set piece_rotation 0)
  (set game_state states.intro)
  (set timer nil)
  (set remaining_appearing_frames 0)
  (set falling_delay_frames 0)
  (set locking_delay_frames 0)
  (set level 0)
  (set lines_cleared 0)
  (set upcoming_pieces [])
  (set next_piece 1)
  (set held_piece nil))

(defn- init_game []
  (init_globals)
  (init_occupied_squares)
  (math.randomseed (os.time))
  (generate_upcoming_pieces)
  (get_next_piece)
  (init_timer)
  (start_timer))

; ---------- MAIN FUNCTION -------------

(defn start []
  (tetris_io.init_window)
  (tetris_io.set_game_maps)
  (tetris_io.prepare_game_cleanup)
  (init_game))
