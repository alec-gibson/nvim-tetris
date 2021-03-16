(module nvim-tetris.const)

(def rows 24) ; only 20 drawn inside the game border
(def columns 10)
(def screen_rows 20)
(def screen_cols 10)
(def max_level 28) ; after level 28, all levels are same speed
(def frame_delay (math.floor (/ 1000 60)))
(def lock_delay 10) ; in frames. My game will support move reset - successfully moving or rotating resets the lock delay
(def entry_delay 10) ; in frames. Time between previous piece locking and new piece starting to fall

(def game_states {"appearing" 0
                  "falling" 1
                  "locking" 2
                  "intro" 3
                  "paused" 4
                  "gameover" 5})

(def colours {:TetrisBackground "Black"
              :TetrisHeader "DarkGray"
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
(def gravity {0 47
              1 42
              2 37
              3 32
              4 27
              5 22
              6 17
              7 12
              8 7
              9 5
              10 4
              11 4
              12 4
              13 3
              14 3
              15 3
              16 2
              17 2
              18 2
              19 1
              20 1
              21 1
              22 1
              23 1
              24 1
              25 1
              26 1
              27 1
              28 1})
