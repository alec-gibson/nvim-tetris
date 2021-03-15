(module nvim-tetris.util
  {require {const nvim-tetris.const
            a nvim-tetris.aniseed.core
            v nvim-tetris.aniseed.view}})

(defn- unique [tbl]
  (let [vals {}]
    (each [_ val (ipairs tbl)]
      (tset vals val true))
    (a.keys vals)))

(defn- sort_descending [tbl]
  (table.sort tbl (fn [a b] (> a b)))
  tbl)

; [x y], [x y] -> [x y]
(defn- add_pairs [p1 p2]
  (let [[x1 y1] p1
        [x2 y2] p2]
    [(+ x1 x2) (+ y1 y2)]))

(defn- apply_rotation [piece rotation]
  (let [{:square_offsets offsets} piece
        mod (% rotation 4)]
    (icollect [_ offset (ipairs offsets)]
              (let [[x y] offset]
                (if (= 0 mod)
                  offset
                  (= 1 mod)
                  [y (- 0 x)]
                  (= 2 mod)
                  [(- 0 x) (- 0 y)]
                  [(- 0 y) x])))))

(defn- out_of_game_bounds? [row col]
  (or (< row 1) (< col 1) (> row const.rows) (> col const.columns))) 

(defn- out_of_screen_bounds? [row col]
  (or (< row 1) (< col 1) (> row const.screen_rows) (> col const.screen_cols))) 

(defn- square_collides_or_out_of_bounds? [row col occupied_squares]
  (or (out_of_game_bounds? row col)
    (. (. occupied_squares row) col)))

(defn- square_collides_or_below_screen? [row col occupied_squares]
  (or (< row 1)
    (. (. occupied_squares row) col)))

; [x y] {:square_offsets [[x y]] :colour ""} int -> [{:coords [x y] :colour ""}]
(defn get_piece_squares [pivot piece rotation]
  (icollect [_ offset (ipairs (apply_rotation piece rotation))]
            {:coords (add_pairs pivot offset) :colour piece.colour}))
; (get_piece_squares [5 15] (. const.piece_types 1) 0)

; nil -> int
(defn get_gravity [level]
  (if (> level const.max_level)
    0
    (. const.gravity level)))

(defn get_shadow_offset [piece_squares occupied_squares]
  (var vert_dist const.rows)
  (each [_ square (ipairs piece_squares)]
    (let [{:coords [col row]} square]
      (for [shadow_row row 0 -1]
        (if (square_collides_or_below_screen? shadow_row col occupied_squares)
          (let [diff (a.dec (- row shadow_row))]
            (if (< diff vert_dist)
              (set vert_dist diff))
            (lua "break")))
        )))
  vert_dist)

(defn get_shadow_squares [piece_squares vert_dist]
  (a.map (fn [square]
           (let [{:coords [col row] : colour} square]
             {:coords [col (- row vert_dist)] :colour "TetrisShadow"})) piece_squares))

(defn piece_collides_or_out_of_bounds? [piece_squares occupied_squares]
  (a.reduce (fn [collides square]
              (let [{:coords [col row]} square]
                (or collides
                    (square_collides_or_out_of_bounds? row col occupied_squares)
                    ))) false piece_squares))

(defn get_random_piece []
  (. const.piece_types (math.ceil (a.rand (a.count const.piece_types)))))

(defn row_full? [row occupied_squares]
  (a.reduce (fn [is_clear val] (and is_clear val)) true (. occupied_squares row)))

; must return a list of rows from greatest to least
(defn get_square_rows [piece_squares]
  (sort_descending
    (unique
      (a.map
        (fn [square]
          (let [{:coords [col row]} square] row))
        piece_squares))))

(defn squares_in_bounds [squares]
  (a.filter (fn [square]
              (let [{:coords [col row]} square]
                (not ( out_of_screen_bounds? row col))))
            squares))

(defn- get_trial_offsets [old_offsets new_offsets]
  (let [trial_offsets []]
    (for [i 1 (a.count old_offsets)]
      (let [[old_col old_row] (. old_offsets i)
            [new_col new_row] (. new_offsets i)]
        (table.insert trial_offsets [(- old_col new_col) (- old_row new_row)])))
    trial_offsets))

(defn get_rotation_offset [pivot piece old_rotation new_rotation occupied_squares]
  (var rotation_offset nil)
  (let [old_offsets (. piece.wallkick_offsets (% old_rotation 4))
        new_offsets (. piece.wallkick_offsets (% new_rotation 4))
        trial_offsets (get_trial_offsets old_offsets new_offsets)]
    (each [_ offset (ipairs trial_offsets)]
      (let [[d_x d_y] offset
            [x y] pivot
            new_pivot [(+ x d_x) (+ y d_y)]]
        (when (not (piece_collides_or_out_of_bounds? (get_piece_squares new_pivot piece new_rotation) occupied_squares))
          (set rotation_offset offset)
          (lua "break"))))
    rotation_offset))
