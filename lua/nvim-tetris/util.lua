local _0_0 = nil
do
  local name_0_ = "nvim-tetris.util"
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
    return {require("nvim-tetris.aniseed.core"), require("nvim-tetris.const"), require("nvim-tetris.aniseed.view")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "nvim-tetris.aniseed.core", const = "nvim-tetris.const", v = "nvim-tetris.aniseed.view"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local const = _local_0_[2]
local v = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tetris.util"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local unique = nil
do
  local v_0_ = nil
  local function unique0(tbl)
    local vals = {}
    for _, val in ipairs(tbl) do
      vals[val] = true
    end
    return a.keys(vals)
  end
  v_0_ = unique0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["unique"] = v_0_
  unique = v_0_
end
local sort_descending = nil
do
  local v_0_ = nil
  local function sort_descending0(tbl)
    local function _2_(a0, b)
      return (a0 > b)
    end
    table.sort(tbl, _2_)
    return tbl
  end
  v_0_ = sort_descending0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["sort_descending"] = v_0_
  sort_descending = v_0_
end
local add_pairs = nil
do
  local v_0_ = nil
  local function add_pairs0(p1, p2)
    local _let_0_ = p1
    local x1 = _let_0_[1]
    local y1 = _let_0_[2]
    local _let_1_ = p2
    local x2 = _let_1_[1]
    local y2 = _let_1_[2]
    return {(x1 + x2), (y1 + y2)}
  end
  v_0_ = add_pairs0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["add_pairs"] = v_0_
  add_pairs = v_0_
end
local apply_rotation = nil
do
  local v_0_ = nil
  local function apply_rotation0(piece, rotation)
    local _let_0_ = piece
    local offsets = _let_0_["square_offsets"]
    local mod = (rotation % 4)
    local tbl_0_ = {}
    for _, offset in ipairs(offsets) do
      local _2_
      do
        local _let_1_ = offset
        local x = _let_1_[1]
        local y = _let_1_[2]
        if (0 == mod) then
          _2_ = offset
        elseif (1 == mod) then
          _2_ = {y, (0 - x)}
        elseif (2 == mod) then
          _2_ = {(0 - x), (0 - y)}
        else
          _2_ = {(0 - y), x}
        end
      end
      tbl_0_[(#tbl_0_ + 1)] = _2_
    end
    return tbl_0_
  end
  v_0_ = apply_rotation0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["apply_rotation"] = v_0_
  apply_rotation = v_0_
end
local out_of_game_bounds_3f = nil
do
  local v_0_ = nil
  local function out_of_game_bounds_3f0(row, col)
    return ((row < 1) or (col < 1) or (row > const.rows) or (col > const.columns))
  end
  v_0_ = out_of_game_bounds_3f0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["out_of_game_bounds?"] = v_0_
  out_of_game_bounds_3f = v_0_
end
local out_of_screen_bounds_3f = nil
do
  local v_0_ = nil
  local function out_of_screen_bounds_3f0(row, col)
    return ((row < 1) or (col < 1) or (row > const.screen_rows) or (col > const.screen_cols))
  end
  v_0_ = out_of_screen_bounds_3f0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["out_of_screen_bounds?"] = v_0_
  out_of_screen_bounds_3f = v_0_
end
local square_collides_or_out_of_bounds_3f = nil
do
  local v_0_ = nil
  local function square_collides_or_out_of_bounds_3f0(row, col, occupied_squares)
    return (out_of_game_bounds_3f(row, col) or occupied_squares[row][col])
  end
  v_0_ = square_collides_or_out_of_bounds_3f0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["square_collides_or_out_of_bounds?"] = v_0_
  square_collides_or_out_of_bounds_3f = v_0_
end
local square_collides_or_below_screen_3f = nil
do
  local v_0_ = nil
  local function square_collides_or_below_screen_3f0(row, col, occupied_squares)
    return ((row < 1) or occupied_squares[row][col])
  end
  v_0_ = square_collides_or_below_screen_3f0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["square_collides_or_below_screen?"] = v_0_
  square_collides_or_below_screen_3f = v_0_
end
local get_piece_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_piece_squares0(pivot, piece, rotation)
      local tbl_0_ = {}
      for _, offset in ipairs(apply_rotation(piece, rotation)) do
        tbl_0_[(#tbl_0_ + 1)] = {colour = piece.colour, coords = add_pairs(pivot, offset)}
      end
      return tbl_0_
    end
    v_0_0 = get_piece_squares0
    _0_0["get_piece_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_piece_squares"] = v_0_
  get_piece_squares = v_0_
end
local get_gravity = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_gravity0(level)
      if (level > const.max_level) then
        return 0
      else
        return const.gravity[level]
      end
    end
    v_0_0 = get_gravity0
    _0_0["get_gravity"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_gravity"] = v_0_
  get_gravity = v_0_
end
local get_shadow_offset = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_shadow_offset0(piece_squares, occupied_squares)
      local vert_dist = const.rows
      for _, square in ipairs(piece_squares) do
        local _let_0_ = square
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        for shadow_row = row, 0, -1 do
          if square_collides_or_below_screen_3f(shadow_row, col, occupied_squares) then
            local diff = a.dec((row - shadow_row))
            if (diff < vert_dist) then
              vert_dist = diff
            end
            break
          end
        end
      end
      return vert_dist
    end
    v_0_0 = get_shadow_offset0
    _0_0["get_shadow_offset"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_shadow_offset"] = v_0_
  get_shadow_offset = v_0_
end
local get_shadow_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_shadow_squares0(piece_squares, vert_dist)
      local function _2_(square)
        local _let_0_ = square
        local colour = _let_0_["colour"]
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        return {colour = "TetrisShadow", coords = {col, (row - vert_dist)}}
      end
      return a.map(_2_, piece_squares)
    end
    v_0_0 = get_shadow_squares0
    _0_0["get_shadow_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_shadow_squares"] = v_0_
  get_shadow_squares = v_0_
end
local piece_collides_or_out_of_bounds_3f = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function piece_collides_or_out_of_bounds_3f0(piece_squares, occupied_squares)
      local function _2_(collides, square)
        local _let_0_ = square
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        return (collides or square_collides_or_out_of_bounds_3f(row, col, occupied_squares))
      end
      return a.reduce(_2_, false, piece_squares)
    end
    v_0_0 = piece_collides_or_out_of_bounds_3f0
    _0_0["piece_collides_or_out_of_bounds?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["piece_collides_or_out_of_bounds?"] = v_0_
  piece_collides_or_out_of_bounds_3f = v_0_
end
local get_random_piece = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_random_piece0()
      return const.piece_types[math.ceil(a.rand(a.count(const.piece_types)))]
    end
    v_0_0 = get_random_piece0
    _0_0["get_random_piece"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_random_piece"] = v_0_
  get_random_piece = v_0_
end
local row_full_3f = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function row_full_3f0(row, occupied_squares)
      local function _2_(is_clear, val)
        return (is_clear and val)
      end
      return a.reduce(_2_, true, occupied_squares[row])
    end
    v_0_0 = row_full_3f0
    _0_0["row_full?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["row_full?"] = v_0_
  row_full_3f = v_0_
end
local get_square_rows = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_square_rows0(piece_squares)
      local function _2_(square)
        local _let_0_ = square
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        return row
      end
      return sort_descending(unique(a.map(_2_, piece_squares)))
    end
    v_0_0 = get_square_rows0
    _0_0["get_square_rows"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_square_rows"] = v_0_
  get_square_rows = v_0_
end
local squares_in_bounds = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function squares_in_bounds0(squares)
      local function _2_(square)
        local _let_0_ = square
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        return not out_of_screen_bounds_3f(row, col)
      end
      return a.filter(_2_, squares)
    end
    v_0_0 = squares_in_bounds0
    _0_0["squares_in_bounds"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["squares_in_bounds"] = v_0_
  squares_in_bounds = v_0_
end
local get_trial_offsets = nil
do
  local v_0_ = nil
  local function get_trial_offsets0(old_offsets, new_offsets)
    local trial_offsets = {}
    for i = 1, a.count(old_offsets) do
      local _let_0_ = old_offsets[i]
      local old_col = _let_0_[1]
      local old_row = _let_0_[2]
      local _let_1_ = new_offsets[i]
      local new_col = _let_1_[1]
      local new_row = _let_1_[2]
      table.insert(trial_offsets, {(old_col - new_col), (old_row - new_row)})
    end
    return trial_offsets
  end
  v_0_ = get_trial_offsets0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_trial_offsets"] = v_0_
  get_trial_offsets = v_0_
end
local get_rotation_offset = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_rotation_offset0(pivot, piece, old_rotation, new_rotation, occupied_squares)
      local rotation_offset = nil
      local old_offsets = piece.wallkick_offsets[(old_rotation % 4)]
      local new_offsets = piece.wallkick_offsets[(new_rotation % 4)]
      local trial_offsets = get_trial_offsets(old_offsets, new_offsets)
      for _, offset in ipairs(trial_offsets) do
        local _let_0_ = offset
        local d_x = _let_0_[1]
        local d_y = _let_0_[2]
        local _let_1_ = pivot
        local x = _let_1_[1]
        local y = _let_1_[2]
        local new_pivot = {(x + d_x), (y + d_y)}
        if not piece_collides_or_out_of_bounds_3f(get_piece_squares(new_pivot, piece, new_rotation), occupied_squares) then
          rotation_offset = offset
          break
        end
      end
      return rotation_offset
    end
    v_0_0 = get_rotation_offset0
    _0_0["get_rotation_offset"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["get_rotation_offset"] = v_0_
  get_rotation_offset = v_0_
end
return nil