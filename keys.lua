local M = {}

local E = require 'emacs.editing'
local I = require 'emacs.interactive'

function nothing() end

function M.enable()
  -- Incremental search keymap (you need recent version of textadept)
  keys.find_incremental['cs'] = ui.find.find_incremental_next
  keys.find_incremental['\n'] = function() ui.command_entry.finish_mode(nothing) end

  keys.filter_through['\n'] =
    { ui.command_entry.finish_mode, textadept.editing.filter_through }

  -- Emacs-like key bindings
  -- do not bind 'cl' (used by other modes), 'ct cl' will redraw
  -- do not bind 'c ' (used for auto completion), set mark is 'cr'

  keys['ca'] = buffer.vc_home
  keys['ce'] = buffer.line_end
  keys['m<'] = function() E.save_mark(buffer.document_start) end
  keys['m>'] = function() E.save_mark(buffer.document_end) end

  keys['cf'] = I.repeatable(buffer.char_right)
  keys['cb'] = I.repeatable(buffer.char_left)
  keys['mf'] = I.repeatable(buffer.word_right)
  keys['mb'] = I.repeatable(buffer.word_left)

  keys['cd'] = I.repeatable(buffer.clear)
  keys['md'] = E.move_cut(I.repeatable(buffer.word_right))
  keys['cmh'] = E.move_cut(I.repeatable(buffer.del_word_left)) -- not working

  keys['ck'] = E.move_cut(E.line_end)
  keys['m^'] = textadept.editing.join_lines

  keys['cn'] = I.repeatable(buffer.line_down)
  keys['cp'] = I.repeatable(buffer.line_up)

  keys['cs'] = ui.find.find_incremental

  keys['cv'] = buffer.page_down
  keys['mv'] = buffer.page_up

  keys['cu'] = I.numeric_prefix

  keys['cr'] = E.set_mark
  keys['cw'] = E.with_region(E.cut)
  keys['mw'] = E.with_region(E.copy)
  keys['cy'] = buffer.paste

  keys['m '] = E.just_one_space
  keys['m|'] = {ui.command_entry.enter_mode, 'filter_through'}

  keys['c_'] = I.repeatable(buffer.undo)

  -- Custom key bindings can go here
  keys['ct'] = {
    b = textadept.run.run,
    f = ui.find.focus,
    cg = function() I.wrap(buffer.goto_line, I.PROMPT('Goto line:')) end,
    cl = buffer.vertical_centre_caret,
  }

  -- Emacs ctl-x key map
  keys['cx'] = {
    b = I.switch_buffer,
    k = I.pick_buffer('Kill Buffer:', io.close_buffer),
    r = io.reload_file,
    u = buffer.undo,
    cc = quit,
    cf = io.open_file,
    cr = io.open_recent_file,
    cs = io.save_file, 
    cw = io.save_file_as,
    cx = E.exchange_caret_and_mark,
  }

end

return M
