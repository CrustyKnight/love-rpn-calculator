;;; {{{
(local fira-code (if
                  (love.filesystem.getInfo "fonts/fira-code.ttf") (love.graphics.newFont "fonts/fira-code.ttf")))
(love.graphics.setFont fira-code 20)
(local fira-code-height (+ (fira-code:getHeight) 3))
(local fira-code-width  (fira-code:getWidth "W"))
(love.window.setMode (fira-code:getWidth "┌─────────────────────────────┬─────────┐") (* fira-code-height 17))
;;; }}}

(fn psxy [msg x y]
  (love.graphics.print msg (* fira-code-width x) (* fira-code-height y)))

(fn draw-borders []
  (love.graphics.clear)
  (for [i 1 13] (psxy "│" 0 i))
  (for [i 1 13] (psxy "│" 30 i))
  (for [i 1 13] (psxy "│" 40 i))
  (psxy "┌─────────────────────────────┬─────────┐" 0 0)
  (psxy "├─────────────────────────────┼─────────┤" 0 14)
  (psxy "│                             │         │" 0 15)
  (psxy "└─────────────────────────────┴─────────┘" 0 16))

(var buffer [])

(var stack [])
(fn push [s val] (table.insert s val))
(fn pop  [s]     (table.remove s))

(var mode {})
(var modes {})
(fn set-mode [m]
  (set mode (. modes m)))
(tset modes :home {
                   :sym   (fn [] nil)
                   :num   (fn [] nil)
                   :enter (fn [self] (let [str (. buffer 1)]
                                   (if (= str "a") (set-mode :num)
                                       (= str "e") (love.event.quit)
                                       (= str " ") (push stack self.entry-number) ;push entry-number onto stack and set it to 0
                                       (= str "s") nil)) ;set-mode :sym
                            )
                   :draw  (fn [self]
                            (draw-borders)
                            (psxy (table.concat buffer) 31 15)
                            (psxy (string.format "%d" self.entry-number) 2 15))
                   :entry-number 0})

(tset modes :num {
                  :enter           (fn [self]
                                     (tset modes.home :entry-number
                                           (self.add-digit (self:parse-digit-key buffer) modes.home.entry-number))
                                     (set-mode :home))
                  :add-digit       (fn [digit number] (tonumber (.. (tostring number) (tostring digit))))
                  :parse-digit-key (fn [self b]
                                     (accumulate [num 0
                                                  i s (ipairs b)]
                                       (self.add-digit (if (= s "a") 7
                                                           (= s "o") 5
                                                           (= s "e") 3
                                                           (= s "u") 1
                                                           (= s "i") 0
                                                           (= s "d") 9
                                                           (= s "h") 2
                                                           (= s "t") 4
                                                           (= s "n") 6
                                                           (= s "s") 8
                                                           "")
                                                       num)))
                  :draw            (fn [] (psxy "number mode" 10 10))})

(set-mode :home)

(fn love.draw [love_draw_args]
  (mode:draw))

(fn love.update [dt]
  (when (= (. buffer (length buffer)) " ")
    (mode:enter)
    (set buffer {})))

(local key-table {
                  "a" :a
                  "s" :o
                  "d" :e
                  "f" :u
                  "g" :i
                  "h" :d
                  "j" :h
                  "k" :t
                  "l" :n
                  ";" :s
                  })

(fn love.keyreleased [key scancode]
  (table.insert buffer (if
                        (= key "space") " "
                        (= key "backspace")
                        (do (table.remove buffer) nil)
                        (. key-table scancode))))
