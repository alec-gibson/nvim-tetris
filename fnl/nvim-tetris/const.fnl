(module nvim-tetris.const)

(def rows 24) ; only 20 drawn inside the game border
(def columns 10)
(def screen_rows 20)
(def screen_cols 10)
(def max_level 28) ; after level 28, all levels are same speed
(def frame_delay (math.floor (/ 1000 60)))
(def soft_drop_speed 1) ; drop one gridcell per frame when holding down
(def lock_delay 30) ; in frames. My game will support move reset - successfully moving or rotating resets the lock delay
(def entry_delay 30) ; in frames. Time between previous piece locking and new piece starting to fall

(def game_states {"appearing" 0
                  "falling" 1
                  "locking" 2
                  "intro" 3
                  "paused" 4
                  "gameover" 5})

(def colours {:TetrisBackground "#111111"
              :TetrisIPiece "Cyan"
              :TetrisJPiece "Blue"
              :TetrisLPiece "Orange"
              :TetrisOPiece "Yellow"
              :TetrisSPiece "Green"
              :TetrisTPiece "Purple"
              :TetrisZPiece "Red"
              :TetrisShadow "LightGray"})

; following "How Guideline SRS Really Works" from https://harddrop.com/wiki/SRS
; How wallkicking works: say we're changing an I piece from rotation state 0 to 1
; - try shifting by wallkick_offsets.I.0[1] - wallkick_offsets.I.1[1]
; - if that puts you inside another piece, try shifting by wallkick_offsets.I.0[2] - wallkick_offsets.I.1[2]
; - keep trying until you find one that doesn't put you inside another piece
; - if no wallkick works, the rotation fails
(def wallkick_offsets {:normal {0 [[0 0] [0 0] [0 0] [0 0] [0 0]]
                                1 [[0 0] [1 0] [1 -1] [0 2] [1 2]]
                                2 [[0 0] [0 0] [0 0] [0 0] [0 0]]
                                3 [[0 0] [-1 0] [-1 -1] [0 2] [-1 2]]}
                       :I {0 [[0 0] [-1 0] [2 0] [-1 0] [2 0]]
                           1 [[-1 0] [0 0] [0 0] [0 1] [0 -2]]
                           2 [[-1 1] [1 1] [-2 1] [1 0] [-2 0]]
                           3 [[0 1] [0 1] [0 1] [0 -1] [0 2]]}
                       :O {0 [[0 0]]
                           1 [[0 -1]]
                           2 [[-1 -1]]
                           3 [[-1 0]]}})

; list of pieces in their initial positions / orientations
; following "How Guideline SRS Really Works" from https://harddrop.com/wiki/SRS
; piece pivot always starts off at [5 21]
(def piece_types [{:name "I"
                   :colour "TetrisIPiece"
                   :square_offsets [[-1 0] [0 0] [1 0] [2 0]]
                   :wallkick_offsets wallkick_offsets.I}
                  {:name "J"
                   :colour "TetrisJPiece"
                   :square_offsets [[-1 1] [-1 0] [0 0] [1 0]]
                   :wallkick_offsets wallkick_offsets.normal}
                  {:name "L"
                   :colour "TetrisLPiece"
                   :square_offsets [[-1 0] [0 0] [1 0] [1 1]]
                   :wallkick_offsets wallkick_offsets.normal}
                  {:name "O"
                   :colour "TetrisOPiece"
                   :square_offsets [[0 0] [1 0] [1 1] [0 1]]
                   :wallkick_offsets wallkick_offsets.O}
                  {:name "S"
                   :colour "TetrisSPiece"
                   :square_offsets [[-1 0] [0 0] [0 1] [1 1]]
                   :wallkick_offsets wallkick_offsets.normal}
                  {:name "T"
                   :colour "TetrisTPiece"
                   :square_offsets [[-1 0] [0 0] [0 1] [1 0]]
                   :wallkick_offsets wallkick_offsets.normal}
                  {:name "Z"
                   :colour "TetrisZPiece"
                   :square_offsets [[-1 1] [0 0] [0 1] [1 0]]
                   :wallkick_offsets wallkick_offsets.normal}])

; level -> frames taken to drop one gridcell
; if level > 28, 1 frame is taken to drop one gridcell
; (values stolen from NES tetris)
; https://harddrop.com/wiki/Tetris_(NES,_Nintendo)
(def gravity {0 48
              1 43
              2 38
              3 33
              4 28
              5 23
              6 18
              7 13
              8 8
              9 6
              10 5
              11 5
              12 5
              13 4
              14 4
              15 4
              16 3
              17 3
              18 3
              19 2
              20 2
              21 2
              22 2
              23 2
              24 2
              25 2
              26 2
              27 2
              28 2})
