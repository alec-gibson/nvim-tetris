# nvim-tetris
Bringing emacs' greatest feature to neovim - Tetris!

This plugin is written in [Fennel](https://fennel-lang.org/) using Olical's project [Aniseed](https://github.com/Olical/aniseed) for creating the project structure, and as a library of helper functions and macros.

This plugin is IN PROGRESS, and is currently pretty far from being feature-complete.

## Next Steps
- Fully cleanup when closing the tetris buffer, so you can run `:Tetris` again
- Add UI border showing current level, current score, next piece, saved piece (and add logic for saving pieces)
- Add pause screen (with options to resume game, start new game or quit)
- Add game over screen (with options to play again or quit)
- Add intro screen which shows controls
- Add logic for score
- Stretch goals: multiple tetris buffers, music, online leaderboards, ...
