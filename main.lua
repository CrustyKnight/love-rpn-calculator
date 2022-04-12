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
local buffer = {}
local stack = {}
local function push(s, val)
  return table.insert(s, val)
end
local function pop(s)
  return table.remove(s)
end
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
local function draw_number_stack_right_align(s, area)
  local _let_2_ = area
  local x = _let_2_["x"]
  local y = _let_2_["y"]
  local w = _let_2_["w"]
  local h = _let_2_["h"]
  local start = (1 + (#s - h))
  for i = start, #s do
    local _3_
    if s[i] then
      _3_ = string.format(("%" .. w .. "g"), s[i])
    else
      _3_ = string.format(("%" .. w .. "s"), "nil")
    end
    psxy(_3_, x, (y + (i - start)))
  end
  return nil
end
local function draw_basic()
  draw_borders()
  return draw_number_stack_right_align(stack, {x = 31, y = 1, w = 8, h = 13})
end
local mode = {}
local modes = {}
local function set_mode(m)
  mode = modes[m]
  return nil
end
local function _5_(self)
  local str = buffer[1]
  if (str == "a") then
    return set_mode("num")
  elseif (str == "e") then
    return love.event.quit()
  elseif (str == " ") then
    push(stack, self["entry-number"])
    do end (self)["entry-number"] = 0
    return nil
  elseif (str == "d") then
    self["entry-number"] = 0
    return nil
  elseif (str == "s") then
    modes.sym["level"] = 0
    return set_mode("sym")
  else
    return nil
  end
end
local function _7_(self)
  draw_basic()
  psxy("[a] number entry", 3, 3)
  psxy("[d] clear number entry", 3, 4)
  psxy("[e] quit", 3, 5)
  psxy("[s] symbol entry", 3, 6)
  psxy("[ ] push number onto stack", 3, 7)
  psxy(string.format("%d", self["entry-number"]), 2, 15)
  return psxy(table.concat(buffer), 31, 15)
end
modes["home"] = {enter = _5_, draw = _7_, ["entry-number"] = 0}
local function _8_(self)
  modes.home["entry-number"] = self["add-digit"](self["parse-digit-key"](self, buffer), modes.home["entry-number"])
  return set_mode("home")
end
local function _9_(digit, number)
  return tonumber((tostring(number) .. tostring(digit)))
end
local function _10_(self, b)
  local num = 0
  for i, s in ipairs(b) do
    local _11_
    if (s == "a") then
      _11_ = 7
    elseif (s == "o") then
      _11_ = 5
    elseif (s == "e") then
      _11_ = 3
    elseif (s == "u") then
      _11_ = 1
    elseif (s == "i") then
      _11_ = 9
    elseif (s == "d") then
      _11_ = 0
    elseif (s == "h") then
      _11_ = 2
    elseif (s == "t") then
      _11_ = 4
    elseif (s == "n") then
      _11_ = 6
    elseif (s == "s") then
      _11_ = 8
    else
      _11_ = ""
    end
    num = self["add-digit"](_11_, num)
  end
  return num
end
local function _13_()
  draw_basic()
  psxy("[7] [5] [3] [1] [9]", 3, 3)
  psxy("[a] [o] [e] [u] [i]", 3, 4)
  psxy("[0] [2] [4] [6] [8]", 3, 7)
  psxy("[d] [h] [t] [n] [s]", 3, 8)
  return psxy(table.concat(buffer), 31, 15)
end
modes["num"] = {enter = _8_, ["add-digit"] = _9_, ["parse-digit-key"] = _10_, draw = _13_}
local math_factorial
local function _14_(n)
  if (n <= 0) then
    return 1
  else
    return (n * __fnl_global__math_2dfactorial((n - 1)))
  end
end
math_factorial = _14_
local function _16_(self)
  do
    local lvl = self.level
    local str = buffer[1]
    if (lvl == 0) then
      if (str == "a") then
        self.functions.add(stack)
        set_mode("home")
      elseif (str == "o") then
        self.functions.sub(stack)
        set_mode("home")
      elseif (str == "e") then
        self.functions.mul(stack)
        set_mode("home")
      elseif (str == "u") then
        self.functions.div(stack)
        set_mode("home")
      elseif (str == "h") then
        self.functions.pow(stack)
        set_mode("home")
      elseif (str == "t") then
        self.functions.sqrt(stack)
        set_mode("home")
      elseif (str == "n") then
        self.functions.sqr(stack)
        set_mode("home")
      elseif (str == "s") then
        self.functions.inv(stack)
        set_mode("home")
      else
        self["level"] = 1
      end
    elseif (lvl == 1) then
      if (str == "a") then
        self.functions.sin(stack)
        set_mode("home")
      elseif (str == "o") then
        self.functions.cos(stack)
        set_mode("home")
      elseif (str == "e") then
        self.functions.tan(stack)
        set_mode("home")
      elseif (str == "u") then
        self.functions.asin(stack)
        set_mode("home")
      elseif (str == "h") then
        self.functions.atan(stack)
        set_mode("home")
      elseif (str == "t") then
        self.functions.acos(stack)
        set_mode("home")
      elseif (str == "n") then
        self.functions.rad(stack)
        set_mode("home")
      elseif (str == "s") then
        self.functions.deg(stack)
        set_mode("home")
      else
        self["level"] = 2
      end
    elseif (lvl == 2) then
      if (str == "a") then
        self.functions.log10(stack)
        set_mode("home")
      elseif (str == "o") then
        self.functions.TENxp(stack)
        set_mode("home")
      elseif (str == "e") then
        self.functions.ln(stack)
        set_mode("home")
      elseif (str == "u") then
        self.functions.exp(stack)
        set_mode("home")
      elseif (str == "h") then
        self.functions.fac(stack)
        set_mode("home")
      elseif (str == "t") then
        self.functions.pi(stack)
        set_mode("home")
      elseif (str == "n") then
        self.functions.e(stack)
        set_mode("home")
      elseif (str == "s") then
        self.functions._NIL(stack)
        set_mode("home")
      else
        self["level"] = 0
        set_mode("home")
      end
    else
    end
  end
  return nil
end
local function _21_(self)
  draw_basic()
  do
    local lvl = self.level
    local str = buffer[1]
    if (lvl == 0) then
      psxy("[a] add", 3, 3)
      psxy("[o] sub", 3, 4)
      psxy("[e] mul", 3, 5)
      psxy("[u] div", 3, 6)
      psxy("[h] pow", 3, 7)
      psxy("[t] sqrt", 3, 8)
      psxy("[n] sqr", 3, 9)
      psxy("[s] inv", 3, 10)
    elseif (lvl == 1) then
      psxy("[a] sin", 3, 3)
      psxy("[o] cos", 3, 4)
      psxy("[e] tan", 3, 5)
      psxy("[u] asin", 3, 6)
      psxy("[h] atan", 3, 7)
      psxy("[t] acos", 3, 8)
      psxy("[n] rad", 3, 9)
      psxy("[s] deg", 3, 10)
    elseif (lvl == 2) then
      psxy("[a] log10", 3, 3)
      psxy("[o] 10xp", 3, 4)
      psxy("[e] ln", 3, 5)
      psxy("[u] exp", 3, 6)
      psxy("[h] fac", 3, 7)
      psxy("[t] pi", 3, 8)
      psxy("[n] e", 3, 9)
      psxy("[s] _NIL", 3, 10)
    else
    end
  end
  psxy(table.concat(buffer), 31, 15)
  return nil
end
local function _23_(s)
  return push(s, (pop(s) + pop(s)))
end
local function _24_(s)
  local b = pop(s)
  local a = pop(s)
  return push(s, (a - b))
end
local function _25_(s)
  return push(s, (pop(s) * pop(s)))
end
local function _26_(s)
  local b = pop(s)
  local a = pop(s)
  return push(s, (a / b))
end
local function _27_(s)
  local b = pop(s)
  local a = pop(s)
  return push(s, math.pow(a, b))
end
local function _28_(s)
  return push(s, math.sqrt(pop(s)))
end
local function _29_(s)
  return push(s, math.pow(pop(s), 2))
end
local function _30_(s)
  return push(s, (1 / pop(s)))
end
local function _31_(s)
  return push(s, math.sin(math.rad(pop(s))))
end
local function _32_(s)
  return push(s, math.cos(math.rad(pop(s))))
end
local function _33_(s)
  return push(s, math.tan(math.rad(pop(s))))
end
local function _34_(s)
  return push(s, math.deg(math.asin(pop(s))))
end
local function _35_(s)
  return push(s, math.deg(math.atan(pop(s))))
end
local function _36_(s)
  return push(s, math.deg(math.acos(pop(s))))
end
local function _37_(s)
  return push(s, math.log10(pop(s)))
end
local function _38_(s)
  return push(s, math.pow(10, pop(s)))
end
local function _39_(s)
  return push(s, math.log(pop(s)))
end
local function _40_(s)
  return push(s, math.exp(pop(s)))
end
local function _41_(s)
  return push(s, math_factorial(pop(s)))
end
local function _42_(s)
  return push(s, math.rad(pop(s)))
end
local function _43_(s)
  return push(s, math.deg(pop(s)))
end
local function _44_(s)
  return push(s, math.pi)
end
local function _45_(s)
  return push(s, math.exp(1))
end
local function _46_(s)
  return nil
end
modes["sym"] = {enter = _16_, draw = _21_, functions = {add = _23_, sub = _24_, mul = _25_, div = _26_, pow = _27_, sqrt = _28_, sqr = _29_, inv = _30_, sin = _31_, cos = _32_, tan = _33_, asin = _34_, atan = _35_, acos = _36_, log10 = _37_, TENxp = _38_, ln = _39_, exp = _40_, fac = _41_, rad = _42_, deg = _43_, pi = _44_, e = _45_, _NIL = _46_}, level = 0}
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
local key_table = {a = "a", s = "o", d = "e", f = "u", g = "i", h = "d", j = "h", k = "t", l = "n", [";"] = "s"}
love.keyreleased = function(key, scancode)
  local function _48_()
    if (key == "space") then
      return " "
    elseif (key == "backspace") then
      table.remove(buffer)
      return nil
    else
      return key_table[scancode]
    end
  end
  return table.insert(buffer, _48_())
end
return love.keyreleased
