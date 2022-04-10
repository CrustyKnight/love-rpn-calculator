local fira_code
if love.filesystem.getInfo("fonts/fira-code.ttf") then
  fira_code = love.graphics.newFont("fonts/fira-code.ttf")
else
  fira_code = nil
end
love.graphics.setFont(fira_code, 20)
local fira_code_height = (fira_code:getHeight() + 3)
local fira_code_width = fira_code:getWidth("W")
love.window.setMode(fira_code:getWidth("\226\148\140\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\172\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\144"), (fira_code_height * 17))
local function psxy(msg, x, y)
  return love.graphics.print(msg, (fira_code_width * x), (fira_code_height * y))
end
local function draw_borders()
  love.graphics.clear()
  for i = 1, 13 do
    psxy("\226\148\130", 0, i)
  end
  for i = 1, 13 do
    psxy("\226\148\130", 30, i)
  end
  for i = 1, 13 do
    psxy("\226\148\130", 40, i)
  end
  psxy("\226\148\140\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\172\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\144", 0, 0)
  psxy("\226\148\156\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\188\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\164", 0, 14)
  psxy("\226\148\130                             \226\148\130         \226\148\130", 0, 15)
  return psxy("\226\148\148\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\180\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\152", 0, 16)
end
local buffer = {}
local stack = {}
local function push(s, val)
  return table.insert(s, val)
end
local function pop(s)
  return table.remove(s)
end
local mode = {}
local modes = {}
local function set_mode(m)
  mode = modes[m]
  return nil
end
local function _2_()
  return nil
end
local function _3_()
  return nil
end
local function _4_(self)
  local str = buffer[1]
  if (str == "a") then
    return set_mode("num")
  elseif (str == "e") then
    return love.event.quit()
  elseif (str == " ") then
    return push(stack, self["entry-number"])
  elseif (str == "s") then
    return nil
  else
    return nil
  end
end
local function _6_(self)
  draw_borders()
  psxy(table.concat(buffer), 31, 15)
  return psxy(string.format("%d", self["entry-number"]), 2, 15)
end
modes["home"] = {sym = _2_, num = _3_, enter = _4_, draw = _6_, ["entry-number"] = 0}
local function _7_(self)
  modes.home["entry-number"] = self["add-digit"](self["parse-digit-key"](self, buffer), modes.home["entry-number"])
  return set_mode("home")
end
local function _8_(digit, number)
  return tonumber((tostring(number) .. tostring(digit)))
end
local function _9_(self, b)
  local num = 0
  for i, s in ipairs(b) do
    local _10_
    if (s == "a") then
      _10_ = 7
    elseif (s == "o") then
      _10_ = 5
    elseif (s == "e") then
      _10_ = 3
    elseif (s == "u") then
      _10_ = 1
    elseif (s == "i") then
      _10_ = 0
    elseif (s == "d") then
      _10_ = 9
    elseif (s == "h") then
      _10_ = 2
    elseif (s == "t") then
      _10_ = 4
    elseif (s == "n") then
      _10_ = 6
    elseif (s == "s") then
      _10_ = 8
    else
      _10_ = ""
    end
    num = self["add-digit"](_10_, num)
  end
  return num
end
local function _12_()
  return psxy("number mode", 10, 10)
end
modes["num"] = {enter = _7_, ["add-digit"] = _8_, ["parse-digit-key"] = _9_, draw = _12_}
set_mode("home")
love.draw = function(love_draw_args)
  return mode:draw()
end
love.update = function(dt)
  if (buffer[#buffer] == " ") then
    mode:enter()
    buffer = {}
    return nil
  else
    return nil
  end
end
love.keyreleased = function(key, scancode)
  local function _14_()
    if (key == "space") then
      return " "
    elseif (key == "backspace") then
      table.remove(buffer)
      return nil
    else
      return key
    end
  end
  return table.insert(buffer, _14_())
end
return love.keyreleased
