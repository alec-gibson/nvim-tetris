(module nvim-tetris.main
  {require {game nvim-tetris.game
            const nvim-tetris.const}})

; TODO: call io.init_window and io.init_keys
(defn init []
  (game.start))

(init)
