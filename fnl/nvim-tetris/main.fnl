(module nvim-tetris.main
  {require {game nvim-tetris.game
            const nvim-tetris.const}})

(defn init []
  (game.start))
