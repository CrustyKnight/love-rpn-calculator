;;; {{{
(local fira-code (if
                  (love.filesystem.getInfo "fonts/fira-code.ttf") (love.graphics.newFont "fonts/fira-code.ttf")))
(love.graphics.setFont fira-code 20)
(local fira-code-height (+ (fira-code:getHeight) 3))
(local fira-code-width  (fira-code:getWidth "W"))
(love.window.setMode (fira-code:getWidth "┌─────────────────────────────┬─────────┬─────────┐") (* fira-code-height 17))
;;; }}}

(var buffer [])

(var stacks [])
(tset stacks 1 [])
(tset stacks 2 [])
(var stack-num 1)
(var stack     (. stacks 1))
(var alt-stack (. stacks 2))

(fn stack-swap []
  (local s1 stack)
  (local s2 alt-stack)
  (set stack s2)
  (set alt-stack s1)
  (set stack-num (if (= stack-num 1) 2 (= stack-num 2) 1)))

(fn push [s val] (table.insert s val))
(fn pop  [s]     (table.remove s))

(fn psxy [msg x y]
  (love.graphics.print msg (* fira-code-width x) (* fira-code-height y)))

(fn draw-borders []
  (love.graphics.clear)
  (for [i 1 13] (psxy "│" 0 i))
  (for [i 1 13] (psxy "│" 30 i))
  (for [i 1 13] (psxy "│" 40 i))
  (for [i 1 13] (psxy "│" 50 i))
  (psxy "┌─────────────────────────────┬─────────┬─────────┐" 0 0)
  (psxy "├─────────────────────────────┼─────────┼─────────┤" 0 14)
  (psxy "│                             │         │         │" 0 15)
  (psxy "└─────────────────────────────┴─────────┴─────────┘" 0 16))

(fn draw-number-stack-right-align [s area]
  (let [{: x : y : w : h} area
        start (+ 1 (- (length s) h))]
    (for [i start (length s)]
      (psxy (if (. s i)
                (string.format (.. "%" w "g") (. s i))
                (string.format (.. "%" w "s") "nil" ))
                x (+ y (- i start))))))

(fn draw-basic []
  (draw-borders)
  (draw-number-stack-right-align (. stacks 1) {:x 31 :y 1 :w 8 :h 13})
  (draw-number-stack-right-align (. stacks 2) {:x 41 :y 1 :w 8 :h 13}))

(var mode {})
(var modes {})
(fn set-mode [m]
  (set mode (. modes m)))
(tset modes :home {
                   :enter (fn [self] (let [str (. buffer 1)]
                                   (if (= str "i") (set-mode :num)
                                       (= str "e") (love.event.quit)
                                       (= str " ") (do (push stack self.entry-number) (tset self :entry-number 0));push entry-number onto stack and set it to 0
                                       (= str "d") (tset self :entry-number 0)
                                       (= str "u") (pop stack)
                                       (= str "a") (stack-swap)
                                       (= str "o") (push alt-stack (pop stack))
                                       (= str "n") (push stack (pop alt-stack))
                                       (= str "s") (do (tset modes.sym :level 0) (set-mode :sym)))))
                   :draw  (fn [self]
                            (draw-basic)
                            ;; draw help
                            (psxy "[i] number entry" 3 3)
                            (psxy "[d] clear number entry" 3 4)
                            (psxy "[e] quit" 3 5)
                            (psxy "[s] symbol entry" 3 6)
                            (psxy "[ ] push number onto stack" 3 7)
                            (psxy "[u] pop number off stack" 3 8)
                            (psxy "[a] swap active stack" 3 9)
                            (psxy "[o] number to alt-stack" 3 10)
                            (psxy "[n] number from alt-stack" 3 11)
                            (psxy (string.format "%d" self.entry-number) 2 15)
                            (psxy (.. ":" (table.concat buffer)) (+ 21 (* 10 stack-num)) 15))
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
                                                           (= s "i") 9
                                                           (= s "d") 0
                                                           (= s "h") 2
                                                           (= s "t") 4
                                                           (= s "n") 6
                                                           (= s "s") 8
                                                           "")
                                                       num)))
                  :draw            (fn []
                                     (draw-basic)
                                     ;; draw help
                                     (psxy "[7] [5] [3] [1] [9]" 3 3)
                                     (psxy "[a] [o] [e] [u] [i]" 3 4)
                                     (psxy "[0] [2] [4] [6] [8]" 3 7)
                                     (psxy "[d] [h] [t] [n] [s]" 3 8)
                                     (psxy (.. ":" (table.concat buffer)) (+ 21 (* 10 stack-num)) 15))})

; default entry is in degrees, not radians.
; There is a function to convert from radians to degrees.
; Just use that
; I personally will probably be using degrees more often then radians, so thats
; the default
(fn math-factorial [n]
  (if
   (<= n 0) 1
   (* n (math-factorial (- n 1)))))
(tset modes :sym {
                  :enter (fn [self]
                           ;; do symbol action, unless space only, then advance layer
                           ;; probably some recursion? no, that wont work with how input is processed.
                           (let [lvl self.level
                                 str (. buffer 1)]
                             (if (= lvl 0)
                                 (if (= str "a") (do (self.functions.add stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "o") (do (self.functions.sub stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "e") (do (self.functions.mul stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "u") (do (self.functions.div stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "h") (do (self.functions.pow stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "t") (do (self.functions.sqrt stack) (set-mode :home)) ;whatever function goes here.
                                     (= str "n") (do (self.functions.sqr stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "s") (do (self.functions.inv stack)  (set-mode :home)) ;whatever function goes here.
                                     (tset self :level 1))
                                 (= lvl 1)
                                 (if (= str "a") (do (self.functions.sin stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "o") (do (self.functions.cos stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "e") (do (self.functions.tan stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "u") (do (self.functions.asin stack) (set-mode :home)) ;whatever function goes here.
                                     (= str "h") (do (self.functions.atan stack) (set-mode :home)) ;whatever function goes here.
                                     (= str "t") (do (self.functions.acos stack) (set-mode :home)) ;whatever function goes here.
                                     (= str "n") (do (self.functions.rad stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "s") (do (self.functions.deg stack)  (set-mode :home)) ;whatever function goes here.
                                     (tset self :level 2))
                                 (= lvl 2)
                                 (if (= str "a") (do (self.functions.log10 stack) (set-mode :home)) ;whatever function goes here.
                                     (= str "o") (do (self.functions.TENxp stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "e") (do (self.functions.ln stack)    (set-mode :home)) ;whatever function goes here.
                                     (= str "u") (do (self.functions.exp stack)   (set-mode :home)) ;whatever function goes here.
                                     (= str "h") (do (self.functions.fac stack)   (set-mode :home)) ;whatever function goes here.
                                     (= str "t") (do (self.functions.pi stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "n") (do (self.functions.e stack)  (set-mode :home)) ;whatever function goes here.
                                     (= str "s") (do (self.functions._NIL stack)  (set-mode :home)) ;whatever function goes here.
                                     (do (tset self :level 0) (set-mode :home)))))
                           nil)
                  :draw  (fn [self] (draw-basic)
                           (let [lvl self.level
                                 str (. buffer 1)]
                             (if (= lvl 0)
                                 (do
                                   (psxy "[a] add"  3 3)
                                   (psxy "[o] sub"  3 4)
                                   (psxy "[e] mul"  3 5)
                                   (psxy "[u] div"  3 6)
                                   (psxy "[h] pow"  3 7)
                                   (psxy "[t] sqrt" 3 8)
                                   (psxy "[n] sqr"  3 9)
                                   (psxy "[s] inv"  3 10))
                                 (= lvl 1)
                                 (do
                                   (psxy "[a] sin"  3 3)
                                   (psxy "[o] cos"  3 4)
                                   (psxy "[e] tan"  3 5)
                                   (psxy "[u] asin" 3 6)
                                   (psxy "[h] atan" 3 7)
                                   (psxy "[t] acos" 3 8)
                                   (psxy "[n] rad"  3 9)
                                   (psxy "[s] deg"  3 10))
                                 (= lvl 2)
                                 (do
                                   (psxy "[a] log10" 3 3)
                                   (psxy "[o] 10xp"  3 4)
                                   (psxy "[e] ln"    3 5)
                                   (psxy "[u] exp"   3 6)
                                   (psxy "[h] fac"   3 7)
                                   (psxy "[t] pi"  3 8)
                                   (psxy "[n] e"  3 9)
                                   (psxy "[s] _NIL"  3 10))))
                           (psxy (.. ":" (table.concat buffer)) (+ (* 10 stack-num) 21) 15)
                           nil)
                  :functions {
                              :add   (fn [s] (push s (+ (pop s) (pop s))))
                              :sub   (fn [s] (let [b (pop s) a (pop s)] (push s (- a b))))
                              :mul   (fn [s] (push s (* (pop s) (pop s))))
                              :div   (fn [s] (let [b (pop s) a (pop s)] (push s (/ a b))))
                              :pow   (fn [s] (let [b (pop s) a (pop s)] (push s (math.pow a b))))
                              :sqrt  (fn [s] (push s (math.sqrt (pop s))))
                              :sqr   (fn [s] (push s (math.pow (pop s) 2)))
                              :inv   (fn [s] (push s (/ 1 (pop s))))
                              :sin   (fn [s] (push s (math.sin  (math.rad (pop s)))))
                              :cos   (fn [s] (push s (math.cos  (math.rad (pop s)))))
                              :tan   (fn [s] (push s (math.tan  (math.rad (pop s)))))
                              :asin  (fn [s] (push s (math.deg (math.asin (pop s)))))
                              :atan  (fn [s] (push s (math.deg (math.atan (pop s)))))
                              :acos  (fn [s] (push s (math.deg (math.acos (pop s)))))
                              :log10 (fn [s] (push s (math.log10 (pop s))))
                              :TENxp  (fn [s] (push s (math.pow 10 (pop s))))
                              :ln    (fn [s] (push s (math.log (pop s))))
                              :exp   (fn [s] (push s (math.exp (pop s))))
                              :fac   (fn [s] (push s (math-factorial (pop s))))
                              :rad   (fn [s] (push s (math.rad (pop s))))
                              :deg   (fn [s] (push s (math.deg (pop s))))
                              :pi    (fn [s] (push s math.pi))
                              :e     (fn [s] (push s (math.exp 1)))
                              :_NIL  (fn [s] nil)}
                  :level 0})

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
