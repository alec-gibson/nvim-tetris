local _0_0 = nil
do
  local name_0_ = "nvim-tetris.game"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("nvim-tetris.aniseed.core"), require("nvim-tetris.const"), require("luv"), require("nvim-tetris.io"), require("nvim-tetris.util"), require("nvim-tetris.aniseed.view")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "nvim-tetris.aniseed.core", const = "nvim-tetris.const", luv = "luv", tetris_io = "nvim-tetris.io", util = "nvim-tetris.util", v = "nvim-tetris.aniseed.view"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local const = _local_0_[2]
local luv = _local_0_[3]
local tetris_io = _local_0_[4]
local util = _local_0_[5]
local v = _local_0_[6]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tetris.game"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local states = nil
do
  local v_0_ = const.game_states
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["states"] = v_0_
  states = v_0_
end
local api = nil
do
  local v_0_ = vim.api
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["api"] = v_0_
  api = v_0_
end
local occupied_squares = nil
local piece = nil
local piece_pivot = nil
local shadow_offset = nil
local piece_rotation = nil
local game_state = nil
local timer = nil
local remaining_appearing_frames = nil
local falling_delay_frames = nil
local locking_delay_frames = nil
local level = nil
local lines_cleared = nil
local next_piece = nil
local saved_piece = nil
local remove_row = nil
do
  local v_0_ = nil
  local function remove_row0(row)
    for r = row, a.dec(const.rows) do
      for c = 1, const.columns do
        occupied_squares[r][c] = occupied_squares[a.inc(r)][c]
      end
    end
    for c = 1, const.columns do
      occupied_squares[const.rows][c] = false
    end
    return tetris_io.remove_row(row)
  end
  v_0_ = remove_row0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["remove_row"] = v_0_
  remove_row = v_0_
end
local check_for_cleared_rows = nil
do
  local v_0_ = nil
  local function check_for_cleared_rows0(piece_squares)
    local rows = util.get_square_rows(piece_squares)
    for _, row in ipairs(rows) do
      if util["row_full?"](row, occupied_squares) then
        remove_row(row)
        lines_cleared = a.inc(lines_cleared)
        if (0 == (lines_cleared % const.lines_per_level)) then
          level = a.inc(level)
        end
      end
    end
    return nil
  end
  v_0_ = check_for_cleared_rows0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["check_for_cleared_rows"] = v_0_
  check_for_cleared_rows = v_0_
end
local lock_piece = nil
do
  local v_0_ = nil
  local function lock_piece0()
    local piece_squares = util.get_piece_squares(piece_pivot, piece, piece_rotation)
    tetris_io.clear_piece_ns()
    tetris_io.clear_shadow_ns()
    tetris_io.draw_locked_squares(piece_squares)
    for _, square in ipairs(piece_squares) do
      local _let_0_ = square
      local _let_1_ = _let_0_["coords"]
      local col = _let_1_[1]
      local row = _let_1_[2]
      occupied_squares[row][col] = true
    end
    return check_for_cleared_rows(piece_squares)
  end
  v_0_ = lock_piece0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["lock_piece"] = v_0_
  lock_piece = v_0_
end
local reset_falling_delay = nil
do
  local v_0_ = nil
  local function reset_falling_delay0()
    falling_delay_frames = util.get_gravity(level)
    return nil
  end
  v_0_ = reset_falling_delay0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["reset_falling_delay"] = v_0_
  reset_falling_delay = v_0_
end
local stop_timer = nil
do
  local v_0_ = nil
  local function stop_timer0()
    return timer:stop()
  end
  v_0_ = stop_timer0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["stop_timer"] = v_0_
  stop_timer = v_0_
end
local close_timer = nil
do
  local v_0_ = nil
  local function close_timer0()
    return timer:close()
  end
  v_0_ = close_timer0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["close_timer"] = v_0_
  close_timer = v_0_
end
local stop_game = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function stop_game0()
      if not timer:is_closing() then
        return close_timer()
      end
    end
    v_0_0 = stop_game0
    _0_0["stop_game"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["stop_game"] = v_0_
  stop_game = v_0_
end
local do_game_over = nil
do
  local v_0_ = nil
  local function do_game_over0()
    print("Game over at level", level)
    return stop_game()
  end
  v_0_ = do_game_over0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_game_over"] = v_0_
  do_game_over = v_0_
end
local init_appearing = nil
do
  local v_0_ = nil
  local function init_appearing0()
    remaining_appearing_frames = const.entry_delay
    piece = util.get_random_piece()
    piece_pivot = {5, 20}
    piece_rotation = 0
    if util["piece_collides_or_out_of_bounds?"](util.get_piece_squares(piece_pivot, piece, piece_rotation), occupied_squares) then
      do_game_over()
    end
    game_state = states.appearing
    return nil
  end
  v_0_ = init_appearing0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_appearing"] = v_0_
  init_appearing = v_0_
end
local init_falling = nil
do
  local v_0_ = nil
  local function init_falling0()
    reset_falling_delay()
    game_state = states.falling
    return nil
  end
  v_0_ = init_falling0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_falling"] = v_0_
  init_falling = v_0_
end
local init_locking = nil
do
  local v_0_ = nil
  local function init_locking0()
    locking_delay_frames = const.lock_delay
    game_state = states.locking
    return nil
  end
  v_0_ = init_locking0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_locking"] = v_0_
  init_locking = v_0_
end
local move_left = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function move_left0()
      local _let_0_ = piece_pivot
      local col = _let_0_[1]
      local row = _let_0_[2]
      local new_pivot = {a.dec(col), row}
      if not util["piece_collides_or_out_of_bounds?"](util.get_piece_squares(new_pivot, piece, piece_rotation), occupied_squares) then
        piece_pivot = new_pivot
        if (game_state == states.locking) then
          return init_falling()
        end
      end
    end
    v_0_0 = move_left0
    _0_0["move_left"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["move_left"] = v_0_
  move_left = v_0_
end
local move_right = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function move_right0()
      local _let_0_ = piece_pivot
      local col = _let_0_[1]
      local row = _let_0_[2]
      local new_pivot = {a.inc(col), row}
      if not util["piece_collides_or_out_of_bounds?"](util.get_piece_squares(new_pivot, piece, piece_rotation), occupied_squares) then
        piece_pivot = new_pivot
        if (game_state == states.locking) then
          return init_falling()
        end
      end
    end
    v_0_0 = move_right0
    _0_0["move_right"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["move_right"] = v_0_
  move_right = v_0_
end
local rotate = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function rotate0()
      local rotation_offset = util.get_rotation_offset(piece_pivot, piece, piece_rotation, a.inc(piece_rotation), occupied_squares)
      if not a["nil?"](rotation_offset) then
        local _let_0_ = rotation_offset
        local d_x = _let_0_[1]
        local d_y = _let_0_[2]
        local _let_1_ = piece_pivot
        local x = _let_1_[1]
        local y = _let_1_[2]
        local new_pivot = {(x + d_x), (y + d_y)}
        piece_pivot = new_pivot
        piece_rotation = a.inc(piece_rotation)
        if (game_state == states.locking) then
          return init_falling()
        end
      end
    end
    v_0_0 = rotate0
    _0_0["rotate"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["rotate"] = v_0_
  rotate = v_0_
end
local soft_drop = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function soft_drop0()
      local _let_0_ = piece_pivot
      local col = _let_0_[1]
      local row = _let_0_[2]
      local new_pivot = {col, a.dec(row)}
      if not util["piece_collides_or_out_of_bounds?"](util.get_piece_squares(new_pivot, piece, piece_rotation), occupied_squares) then
        piece_pivot = new_pivot
        return nil
      end
    end
    v_0_0 = soft_drop0
    _0_0["soft_drop"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["soft_drop"] = v_0_
  soft_drop = v_0_
end
local hard_drop = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function hard_drop0()
      local _let_0_ = piece_pivot
      local col = _let_0_[1]
      local row = _let_0_[2]
      local new_pivot = {col, (row - shadow_offset)}
      if not util["piece_collides_or_out_of_bounds?"](util.get_piece_squares(new_pivot, piece, piece_rotation), occupied_squares) then
        piece_pivot = new_pivot
        return nil
      end
    end
    v_0_0 = hard_drop0
    _0_0["hard_drop"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["hard_drop"] = v_0_
  hard_drop = v_0_
end
local do_appearing_frame = nil
do
  local v_0_ = nil
  local function do_appearing_frame0()
    if (remaining_appearing_frames > 0) then
      remaining_appearing_frames = a.dec(remaining_appearing_frames)
      return nil
    else
      return init_falling()
    end
  end
  v_0_ = do_appearing_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_appearing_frame"] = v_0_
  do_appearing_frame = v_0_
end
local do_falling_frame = nil
do
  local v_0_ = nil
  local function do_falling_frame0()
    if (falling_delay_frames > 0) then
      falling_delay_frames = a.dec(falling_delay_frames)
      return nil
    else
      local _let_0_ = piece_pivot
      local col = _let_0_[1]
      local row = _let_0_[2]
      local new_pivot = {col, a.dec(row)}
      local new_squares = util.get_piece_squares(new_pivot, piece, piece_rotation)
      if not util["piece_collides_or_out_of_bounds?"](new_squares, occupied_squares) then
        piece_pivot = new_pivot
        return reset_falling_delay()
      else
        return init_locking()
      end
    end
  end
  v_0_ = do_falling_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_falling_frame"] = v_0_
  do_falling_frame = v_0_
end
local do_locking_frame = nil
do
  local v_0_ = nil
  local function do_locking_frame0()
    if (locking_delay_frames > 0) then
      locking_delay_frames = a.dec(locking_delay_frames)
      return nil
    else
      lock_piece()
      return init_appearing()
    end
  end
  v_0_ = do_locking_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_locking_frame"] = v_0_
  do_locking_frame = v_0_
end
local do_intro_frame = nil
do
  local v_0_ = nil
  local function do_intro_frame0()
    -- TODO
    return init_appearing()
  end
  v_0_ = do_intro_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_intro_frame"] = v_0_
  do_intro_frame = v_0_
end
local do_paused_frame = nil
do
  local v_0_ = nil
  local function do_paused_frame0()
    -- TODO
    return nil
  end
  v_0_ = do_paused_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_paused_frame"] = v_0_
  do_paused_frame = v_0_
end
local do_gameover_frame = nil
do
  local v_0_ = nil
  local function do_gameover_frame0()
    -- TODO
    return nil
  end
  v_0_ = do_gameover_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_gameover_frame"] = v_0_
  do_gameover_frame = v_0_
end
local draw_all_pieces = nil
do
  local v_0_ = nil
  local function draw_all_pieces0()
    local piece_squares = util.get_piece_squares(piece_pivot, piece, piece_rotation)
    local vert_dist = util.get_shadow_offset(piece_squares, occupied_squares)
    local shadow_squares = util.get_shadow_squares(piece_squares, vert_dist)
    shadow_offset = vert_dist
    tetris_io.clear_piece_ns()
    tetris_io.clear_shadow_ns()
    tetris_io.draw_shadow_squares(shadow_squares)
    return tetris_io.draw_piece_squares(piece_squares)
  end
  v_0_ = draw_all_pieces0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["draw_all_pieces"] = v_0_
  draw_all_pieces = v_0_
end
local do_frame = nil
do
  local v_0_ = nil
  local function do_frame0()
    print("Level:", level)
    do
      local _2_0 = game_state
      if (_2_0 == states.appearing) then
        do_appearing_frame()
      elseif (_2_0 == states.falling) then
        do_falling_frame()
      elseif (_2_0 == states.locking) then
        do_locking_frame()
      elseif (_2_0 == states.intro) then
        do_intro_frame()
      elseif (_2_0 == states.paused) then
        do_paused_frame()
      elseif (_2_0 == states.gameover) then
        do_gameover_frame()
      end
    end
    return draw_all_pieces()
  end
  v_0_ = do_frame0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["do_frame"] = v_0_
  do_frame = v_0_
end
local start_timer = nil
do
  local v_0_ = nil
  local function start_timer0()
    return timer:start(const.frame_delay, const.frame_delay, vim.schedule_wrap(do_frame))
  end
  v_0_ = start_timer0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["start_timer"] = v_0_
  start_timer = v_0_
end
local init_occupied_squares = nil
do
  local v_0_ = nil
  local function init_occupied_squares0()
    for i = 1, const.rows do
      occupied_squares[i] = {}
      for j = 1, const.columns do
        occupied_squares[i][j] = false
      end
    end
    return nil
  end
  v_0_ = init_occupied_squares0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_occupied_squares"] = v_0_
  init_occupied_squares = v_0_
end
local init_timer = nil
do
  local v_0_ = nil
  local function init_timer0()
    timer = vim.loop.new_timer()
    return nil
  end
  v_0_ = init_timer0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_timer"] = v_0_
  init_timer = v_0_
end
local init_globals = nil
do
  local v_0_ = nil
  local function init_globals0()
    occupied_squares = {}
    piece = {}
    piece_pivot = {5, 20}
    shadow_offset = 0
    piece_rotation = 0
    game_state = states.intro
    timer = nil
    remaining_appearing_frames = 0
    falling_delay_frames = 0
    locking_delay_frames = 0
    level = 0
    lines_cleared = 0
    next_piece = 1
    saved_piece = 1
    return nil
  end
  v_0_ = init_globals0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_globals"] = v_0_
  init_globals = v_0_
end
local init_game = nil
do
  local v_0_ = nil
  local function init_game0()
    init_globals()
    init_occupied_squares()
    init_timer()
    return start_timer()
  end
  v_0_ = init_game0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_game"] = v_0_
  init_game = v_0_
end
local start = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function start0()
      tetris_io.init_window()
      tetris_io.set_game_maps()
      tetris_io.prepare_game_cleanup()
      return init_game()
    end
    v_0_0 = start0
    _0_0["start"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["start"] = v_0_
  start = v_0_
end
return nil