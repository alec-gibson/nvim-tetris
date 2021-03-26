local _0_0 = nil
do
  local name_0_ = "nvim-tetris.io"
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
    return {require("nvim-tetris.aniseed.core"), require("nvim-tetris.const"), require("nvim-tetris.util"), require("nvim-tetris.aniseed.view")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "nvim-tetris.aniseed.core", const = "nvim-tetris.const", util = "nvim-tetris.util", v = "nvim-tetris.aniseed.view"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local const = _local_0_[2]
local util = _local_0_[3]
local v = _local_0_[4]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tetris.io"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local api = nil
do
  local v_0_ = vim.api
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["api"] = v_0_
  api = v_0_
end
local piece_ns_name = nil
do
  local v_0_ = "piece_ns"
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["piece_ns_name"] = v_0_
  piece_ns_name = v_0_
end
local shadow_ns_name = nil
do
  local v_0_ = "shadow_ns"
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["shadow_ns_name"] = v_0_
  shadow_ns_name = v_0_
end
local locked_ns_name = nil
do
  local v_0_ = "locked_ns"
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["locked_ns_name"] = v_0_
  locked_ns_name = v_0_
end
local buf = nil
local win = nil
local piece_ns = nil
local shadow_ns = nil
local locked_ns = nil
local square_width = nil
do
  local v_0_ = 2
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["square_width"] = v_0_
  square_width = v_0_
end
local square_height = nil
do
  local v_0_ = 1
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["square_height"] = v_0_
  square_height = v_0_
end
local square_bytes_per_char = nil
do
  local v_0_ = 3
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["square_bytes_per_char"] = v_0_
  square_bytes_per_char = v_0_
end
local header_height = nil
do
  local v_0_ = 1
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["header_height"] = v_0_
  header_height = v_0_
end
local win_char_width = nil
do
  local v_0_ = (const.screen_cols * square_width)
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["win_char_width"] = v_0_
  win_char_width = v_0_
end
local win_char_height = nil
do
  local v_0_ = ((const.screen_rows * square_height) + header_height)
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["win_char_height"] = v_0_
  win_char_height = v_0_
end
local remove_row = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function remove_row0(row)
      local buf_row = a.inc((const.screen_rows - row))
      local top_row = 1
      api.nvim_buf_set_lines(buf, buf_row, a.inc(buf_row), false, {})
      api.nvim_buf_set_lines(buf, top_row, top_row, false, {string.rep("\226\150\136\226\150\136", const.screen_cols)})
      return api.nvim_buf_add_highlight(buf, -1, "TetrisBackground", top_row, 0, -1)
    end
    v_0_0 = remove_row0
    _0_0["remove_row"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["remove_row"] = v_0_
  remove_row = v_0_
end
local draw_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function draw_squares0(squares, ns)
      local filtered_squares = util.squares_in_bounds(squares)
      for i, square in ipairs(filtered_squares) do
        local _let_0_ = square
        local colour = _let_0_["colour"]
        local _let_1_ = _let_0_["coords"]
        local col = _let_1_[1]
        local row = _let_1_[2]
        local x = a.dec(col)
        local y = ((const.screen_rows - row) + header_height)
        local start_col = (x * 2)
        local start_hl = (start_col * 3)
        local end_hl = (start_hl + (square_width * square_bytes_per_char))
        api.nvim_buf_add_highlight(buf, ns, colour, y, start_hl, end_hl)
      end
      return nil
    end
    v_0_0 = draw_squares0
    _0_0["draw_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["draw_squares"] = v_0_
  draw_squares = v_0_
end
local draw_piece_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function draw_piece_squares0(squares)
      return draw_squares(squares, piece_ns)
    end
    v_0_0 = draw_piece_squares0
    _0_0["draw_piece_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["draw_piece_squares"] = v_0_
  draw_piece_squares = v_0_
end
local draw_shadow_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function draw_shadow_squares0(squares)
      return draw_squares(squares, shadow_ns)
    end
    v_0_0 = draw_shadow_squares0
    _0_0["draw_shadow_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["draw_shadow_squares"] = v_0_
  draw_shadow_squares = v_0_
end
local draw_locked_squares = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function draw_locked_squares0(squares)
      return draw_squares(squares, locked_ns)
    end
    v_0_0 = draw_locked_squares0
    _0_0["draw_locked_squares"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["draw_locked_squares"] = v_0_
  draw_locked_squares = v_0_
end
local clear_ns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function clear_ns0(ns)
      return api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
    v_0_0 = clear_ns0
    _0_0["clear_ns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["clear_ns"] = v_0_
  clear_ns = v_0_
end
local clear_piece_ns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function clear_piece_ns0()
      return clear_ns(piece_ns)
    end
    v_0_0 = clear_piece_ns0
    _0_0["clear_piece_ns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["clear_piece_ns"] = v_0_
  clear_piece_ns = v_0_
end
local clear_shadow_ns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function clear_shadow_ns0()
      return clear_ns(shadow_ns)
    end
    v_0_0 = clear_shadow_ns0
    _0_0["clear_shadow_ns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["clear_shadow_ns"] = v_0_
  clear_shadow_ns = v_0_
end
local clear_locked_ns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function clear_locked_ns0()
      return clear_ns(locked_ns)
    end
    v_0_0 = clear_locked_ns0
    _0_0["clear_locked_ns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["clear_locked_ns"] = v_0_
  clear_locked_ns = v_0_
end
local center = nil
do
  local v_0_ = nil
  local function center0(str)
    local width = api.nvim_win_get_width(0)
    local shift = (math.floor((width / 2)) - math.floor((string.len(str) / 2)))
    return (string.rep(" ", shift) .. str)
  end
  v_0_ = center0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["center"] = v_0_
  center = v_0_
end
local init_highlights = nil
do
  local v_0_ = nil
  local function init_highlights0()
    for group, colours in pairs(const.colours) do
      api.nvim_command(("hi " .. group .. " guifg=" .. colours.guifg .. " ctermfg=" .. colours.ctermfg))
    end
    return nil
  end
  v_0_ = init_highlights0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_highlights"] = v_0_
  init_highlights = v_0_
end
local init_window = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function init_window0()
      buf = api.nvim_create_buf(false, true)
      api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      api.nvim_buf_set_option(buf, "filetype", "tetris")
      api.nvim_buf_set_name(buf, "tetris")
      do
        local width = api.nvim_get_option("columns")
        local height = api.nvim_get_option("lines")
        local col = math.ceil(((width - win_char_width) / 2))
        local row = math.ceil(a.dec(((height - win_char_height) / 2)))
        local border_opts = {col = a.dec(col), height = win_char_height, relative = "editor", row = a.dec(row), style = "minimal", width = win_char_width}
        local opts = {col = col, height = win_char_height, relative = "editor", row = row, style = "minimal", width = win_char_width}
        win = api.nvim_open_win(buf, true, opts)
        api.nvim_buf_set_lines(buf, 0, -1, false, {center("Tetris")})
        for i = 1, const.screen_rows do
          api.nvim_buf_set_lines(buf, i, i, false, {string.rep("\226\150\136\226\150\136", const.screen_cols)})
          api.nvim_buf_add_highlight(buf, -1, "TetrisBackground", i, 0, -1)
        end
        api.nvim_buf_add_highlight(buf, -1, "TetrisHeader", 0, 0, -1)
      end
      piece_ns = api.nvim_create_namespace(piece_ns_name)
      shadow_ns = api.nvim_create_namespace(shadow_ns_name)
      locked_ns = api.nvim_create_namespace(locked_ns_name)
      return init_highlights()
    end
    v_0_0 = init_window0
    _0_0["init_window"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["init_window"] = v_0_
  init_window = v_0_
end
local set_game_maps = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function set_game_maps0()
      local mappings = {["<Down>"] = "soft_drop()", ["<Left>"] = "move_left()", ["<Right>"] = "move_right()", ["<Space>"] = "hard_drop()", ["<Up>"] = "rotate()"}
      for k, v0 in pairs(mappings) do
        api.nvim_buf_set_keymap(buf, "n", k, (":lua require\"nvim-tetris.game\"." .. v0 .. "<cr>"), {noremap = true, nowait = true, silent = true})
      end
      local other_chars = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
      for k, v0 in ipairs(other_chars) do
        api.nvim_buf_set_keymap(buf, "n", v0, "", {noremap = true, nowait = true, silent = true})
        api.nvim_buf_set_keymap(buf, "n", string.upper(v0), "", {noremap = true, nowait = true, silent = true})
        api.nvim_buf_set_keymap(buf, "n", ("<c-" .. v0 .. ">"), "", {noremap = true, nowait = true, silent = true})
      end
      return nil
    end
    v_0_0 = set_game_maps0
    _0_0["set_game_maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["set_game_maps"] = v_0_
  set_game_maps = v_0_
end
local prepare_game_cleanup = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function prepare_game_cleanup0()
      return api.nvim_command("autocmd BufWipeout tetris lua require(\"nvim-tetris.game\").stop_game()")
    end
    v_0_0 = prepare_game_cleanup0
    _0_0["prepare_game_cleanup"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["prepare_game_cleanup"] = v_0_
  prepare_game_cleanup = v_0_
end
return nil