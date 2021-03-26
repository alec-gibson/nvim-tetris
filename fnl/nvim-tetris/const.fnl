(module nvim-tetris.const)

(def rows 24) ; only 20 drawn inside the game border
(def columns 10)
(def screen_rows 20)
(def screen_cols 10)
(def max_level 18) ; after level 18, all levels are same speed
(def frame_delay (math.floor (/ 1000 60)))
(def lock_delay 10) ; in frames. My game will support move reset - successfully moving or rotating resets the lock delay
(def entry_delay 10) ; in frames. Time between previous piece locking and new piece starting to fall
(def lines_per_level 10)

(def game_states {"appearing" 0
                  "falling" 1
                  "locking" 2
                  "intro" 3
                  "paused" 4
                  "gameover" 5})

(def colours {:TetrisBackground {:guifg "Black" :ctermfg "Black"}
              :TetrisHeader {:guifg "DarkGray" :ctermfg "DarkGray"}
              :TetrisIPiece {:guifg "Cyan" :ctermfg "DarkCyan"}
              :TetrisJPiece {:guifg "Blue" :ctermfg "DarkBlue"}
              :TetrisLPiece {:guifg "Orange" :ctermfg "Brown"}
              :TetrisOPiece {:guifg "Yellow" :ctermfg "Yellow"}
              :TetrisSPiece {:guifg "Green" :ctermfg "DarkGreen"}
              :TetrisTPiece {:guifg "Purple" :ctermfg "DarkMagenta"}
              :TetrisZPiece {:guifg "Red" :ctermfg "DarkRed"}
              :TetrisShadow {:guifg "LightGray" :ctermfg "LightGray"}})

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
; if level > max_level, 1 frame is taken to drop one gridcell
(def gravity {0 30
              1 25
              2 20
              3 16
              4 13
              5 10
              6 8
              7 6
              8 7
              9 6
              10 5
              11 4
              12 4
              13 3
              14 3
              15 2
              16 2
              17 1
              18 1})
