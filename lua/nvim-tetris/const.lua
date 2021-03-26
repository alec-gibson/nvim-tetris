local _0_0 = nil
do
  local name_0_ = "nvim-tetris.const"
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
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tetris.const"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local rows = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 24
    _0_0["rows"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["rows"] = v_0_
  rows = v_0_
end
local columns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 10
    _0_0["columns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["columns"] = v_0_
  columns = v_0_
end
local screen_rows = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 20
    _0_0["screen_rows"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["screen_rows"] = v_0_
  screen_rows = v_0_
end
local screen_cols = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 10
    _0_0["screen_cols"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["screen_cols"] = v_0_
  screen_cols = v_0_
end
local max_level = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 18
    _0_0["max_level"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["max_level"] = v_0_
  max_level = v_0_
end
local frame_delay = nil
do
  local v_0_ = nil
  do
    local v_0_0 = math.floor((1000 / 60))
    _0_0["frame_delay"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["frame_delay"] = v_0_
  frame_delay = v_0_
end
local lock_delay = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 10
    _0_0["lock_delay"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["lock_delay"] = v_0_
  lock_delay = v_0_
end
local entry_delay = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 10
    _0_0["entry_delay"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["entry_delay"] = v_0_
  entry_delay = v_0_
end
local lines_per_level = nil
do
  local v_0_ = nil
  do
    local v_0_0 = 10
    _0_0["lines_per_level"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["lines_per_level"] = v_0_
  lines_per_level = v_0_
end
local game_states = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {appearing = 0, falling = 1, gameover = 5, intro = 3, locking = 2, paused = 4}
    _0_0["game_states"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["game_states"] = v_0_
  game_states = v_0_
end
local colours = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {TetrisBackground = {ctermfg = "Black", guifg = "Black"}, TetrisHeader = {ctermfg = "DarkGray", guifg = "DarkGray"}, TetrisIPiece = {ctermfg = "Cyan", guifg = "Cyan"}, TetrisJPiece = {ctermfg = "Blue", guifg = "Blue"}, TetrisLPiece = {ctermfg = "Brown", guifg = "Orange"}, TetrisOPiece = {ctermfg = "Yellow", guifg = "Yellow"}, TetrisSPiece = {ctermfg = "Green", guifg = "Green"}, TetrisShadow = {ctermfg = "LightGray", guifg = "LightGray"}, TetrisTPiece = {ctermfg = "DarkMagenta", guifg = "Purple"}, TetrisZPiece = {ctermfg = "Red", guifg = "Red"}}
    _0_0["colours"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["colours"] = v_0_
  colours = v_0_
end
local wallkick_offsets = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {I = {{{-1, 0}, {0, 0}, {0, 0}, {0, 1}, {0, -2}}, {{-1, 1}, {1, 1}, {-2, 1}, {1, 0}, {-2, 0}}, {{0, 1}, {0, 1}, {0, 1}, {0, -1}, {0, 2}}, [0] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 0}, {2, 0}}}, O = {{{0, -1}}, {{-1, -1}}, {{-1, 0}}, [0] = {{0, 0}}}, normal = {{{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, [0] = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}}}
    _0_0["wallkick_offsets"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["wallkick_offsets"] = v_0_
  wallkick_offsets = v_0_
end
local piece_types = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {{colour = "TetrisIPiece", name = "I", square_offsets = {{-1, 0}, {0, 0}, {1, 0}, {2, 0}}, wallkick_offsets = wallkick_offsets.I}, {colour = "TetrisJPiece", name = "J", square_offsets = {{-1, 1}, {-1, 0}, {0, 0}, {1, 0}}, wallkick_offsets = wallkick_offsets.normal}, {colour = "TetrisLPiece", name = "L", square_offsets = {{-1, 0}, {0, 0}, {1, 0}, {1, 1}}, wallkick_offsets = wallkick_offsets.normal}, {colour = "TetrisOPiece", name = "O", square_offsets = {{0, 0}, {1, 0}, {1, 1}, {0, 1}}, wallkick_offsets = wallkick_offsets.O}, {colour = "TetrisSPiece", name = "S", square_offsets = {{-1, 0}, {0, 0}, {0, 1}, {1, 1}}, wallkick_offsets = wallkick_offsets.normal}, {colour = "TetrisTPiece", name = "T", square_offsets = {{-1, 0}, {0, 0}, {0, 1}, {1, 0}}, wallkick_offsets = wallkick_offsets.normal}, {colour = "TetrisZPiece", name = "Z", square_offsets = {{-1, 1}, {0, 0}, {0, 1}, {1, 0}}, wallkick_offsets = wallkick_offsets.normal}}
    _0_0["piece_types"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["piece_types"] = v_0_
  piece_types = v_0_
end
local gravity = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {25, 20, 16, 13, 10, 8, 6, 7, 6, 5, 4, 4, 3, 3, 2, 2, 1, 1, [0] = 30}
    _0_0["gravity"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["gravity"] = v_0_
  gravity = v_0_
end
return nil