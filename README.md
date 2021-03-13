# nvim-tetris
Bringing emacs' greatest feature to neovim - Tetris! This plugin is written in [Fennel](https://fennel-lang.org/) using Olical's project [Aniseed](https://github.com/Olical/aniseed) for creating the project structure, and as a library of helper functions and macros.

## Next Steps
- DONE: Add logic for gameover
- Add logic for wall kicks
		* Fix bug where you can get a piece locked off the ground by rotating during locking
- Add logic for score and progressing levels
- Add UI border showing current level, current score, next piece, saved piece
- Add logic to save the next piece
- Add pause screen (with options to resume game, start new game or quit)
- Add game over screen (with options to play again or quit)
- Add intro screen which shows controls
