(local repl (require "lib.stdio"))

(set _G.particles {})
(set _G.hue 0)

(fn HSV [h s v]
  (if (<= s 0)
    (values v v v)
   (let [h (* h 6)
         c (* v s)
         x (* c (- 1 (math.abs (- (% h 2) 1))))
         m (- v c)]
    (if
       (< h 1) (values (+ m c)
                       (+ m x)
                       (+ m 0))
       (< h 2) (values (+ m x)
                       (+ m c)
                       (+ m 0))
       (< h 3) (values (+ m 0)
                       (+ m c)
                       (+ m x))
       (< h 4) (values (+ m 0)
                       (+ m x)
                       (+ m c))
       (< h 5) (values (+ x m)
                       (+ m 0)
                       (+ m c))
       (values (+ m c)
               (+ m 0)
               (+ m x))))))


(fn love.load []
  (set _G.particles
    (let [canvas (love.graphics.newCanvas 2 2)
          particles (love.graphics.newParticleSystem canvas 1000000)]
        (love.graphics.setCanvas canvas)
        (love.graphics.setColor 1 1 1 1)
        (love.graphics.rectangle :fill
                                  0 0
                                  2 2)
        (love.graphics.setCanvas)
        (particles:setParticleLifetime 1 3)
        (particles:setEmissionRate 20)
        (particles:setLinearAcceleration -20 -20 20 20)
        (particles:setSizeVariation .5)
        (particles:setColors
          0.95 0.857 0.551 1
          0.65 1.0 0.897 1
          0.933 0.558 0.799 1
          0.98 0.735 0.637 1
          0.873 0.643 0.96 1
          0.500 0.91 0.731 1
          0.94 0.583 0.686 1)
        particles))


  (repl.start)) ; this is important for the REPL to work

(fn love.mousepressed [x y button istouch presses]
  (let [ps _G.particles]
    (ps:setEmissionRate 200)
    (ps:setLinearAcceleration -100 -100 100 100)))

(fn love.mousereleased [x y button istouch presses]
  (let [ps _G.particles]
    (ps:setEmissionRate 20)
    (ps:setLinearAcceleration -20 -20 20 20)))

(fn love.update [dt]
  (set _G.hue (% (+ _G.hue (* dt))))
  (let [ps _G.particles
         [r g b] [(HSV _G.hue 1 1)]]
     (ps:setPosition (love.mouse.getPosition))
     (ps:update dt)))

(fn love.draw []
  (love.graphics.draw 
    _G.particles))
