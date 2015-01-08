breed [foragers forager]
breed [markers marker]

foragers-own [energy memory target? target]

patches-own [penergy oldstate countdown whichfood]

globals [density foodenergy foodcolor cumpop]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  set density [0.01 0.005 0.001]
  set foodenergy [10 20 100] 
  set foodcolor [green red blue] 
  
  let iter 0
  let counter 0
  while [iter < 3]
  [
    set counter 0
    while [counter < (item iter density * (world-width * world-height))] [
      ask one-of patches 
      [
        if pcolor = black [
          set pcolor item iter foodcolor 
          set counter counter + 1 
          set whichfood iter + 1]
      ]
    ]
    set iter iter + 1
  ] 
  
  set-default-shape foragers "dot"
  create-foragers number [
    set size 2
    set color white
    set target? false
    set target nobody
    setxy random-xcor random-ycor
    set energy 50  
    set memory []
  ]
end

to go
  if not any? foragers [ stop ]
  step
  eat
  regrowth
  demographics
  if ticks >= 5000 [set cumpop cumpop + count foragers]
  if ticks = 10000 [stop]
  tick
end

to regrowth
    ask patches with [countdown > 0]
    [
      set countdown countdown - 1
      if countdown = 0 [set pcolor item (whichfood - 1) foodcolor]
    ]  
end

to step
  ask foragers [
  ;  show memory
    ifelse target? and targeton? [
    ;  show "BB"
    ;  show target
      face target
      fd 1
      if distance target < 0.5 [set target? false set memory remove target memory ask target [die]]
    ][
      ifelse changedirectionwhenhungry [
        if energy < THusememory [
          rt random 360
        ]
        if random-float 1 > probcont [
          rt random 45
          lt random 45
        ]
      ][
        if random-float 1 > probcont [
          rt random 45
          lt random 45
        ]
      ]
      fd 1
    ]
    set energy energy - metabolism
    if energy < THusememory [
      let sizememory length memory
      if sizememory > 0 [
        let i 0
        let mindistance 100
        while [i < sizememory]
        [
          let dist distance item i memory
          if dist < mindistance [
            set mindistance dist 
            set target? true 
            set target item i memory
          ]
          set i i + 1
        ]
        face target
     ]
    ]
  ]
end
    
to eat       ;;gain energy by eating food
  ask foragers [
    if pcolor != black [
      let iter 0
      while [iter < 3]
      [
        if pcolor = item iter foodcolor
        [ 
          set pcolor black
          set whichfood 0
          set energy energy + item iter foodenergy 
          if targeton? [
            if item iter foodenergy > thresholdmemory [
              let marked self
              hatch 1 [
                set breed markers 
                set marked self
              ] 
              set memory lput marked memory
            ]
          ]
          ifelse random-float 1 < pmove [ 
            ask one-of patches with [whichfood = 0]
            [
              set countdown countdownmax 
              set whichfood (iter + 1)
            ]
          ][
             set countdown countdownmax set whichfood (iter + 1)
          ]
        ]
        set iter iter + 1
      ]
    ]
  ]
end

to demographics    ;;die if you run out of energy
  ask foragers [
    if ( energy < 0 ) [ die ]
  ]
  ask foragers [
    if (energy > birth-threshold)
    [
      set energy (energy / 2)
      hatch 1 [set memory [] set target? false set target nobody]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
223
10
611
419
-1
-1
3.78
1
10
1
1
1
0
1
1
1
0
99
0
99
1
1
1
ticks
30.0

BUTTON
5
10
60
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
5
48
60
81
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
5
237
176
270
pmove
pmove
0.0
1.0
1
0.01
1
NIL
HORIZONTAL

SLIDER
6
89
175
122
number
number
0.0
1000.0
100
1.0
1
NIL
HORIZONTAL

PLOT
618
181
914
347
Population
Time
Pop
0.0
100.0
0.0
111.0
true
false
"" ""
PENS
"agents" 1.0 0 -13345367 true "" "plot count foragers"

PLOT
619
351
915
516
Histogram
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [energy] of foragers"

BUTTON
64
48
120
81
go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
163
175
196
birth-threshold
birth-threshold
0
100
100
1
1
NIL
HORIZONTAL

SLIDER
6
126
175
159
metabolism
metabolism
0.1
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
6
200
175
233
probcont
probcont
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
5
274
176
307
countdownmax
countdownmax
0
100
50
1
1
NIL
HORIZONTAL

PLOT
617
11
914
176
Food
NIL
NIL
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"1" 1.0 0 -13840069 true "" "plot count patches with [pcolor = green] / 100"
"2" 1.0 0 -2674135 true "" "plot count patches with [pcolor = red] / 50"
"3" 1.0 0 -13345367 true "" "plot count patches with [pcolor = blue] / 10"

SLIDER
5
311
176
344
thresholdmemory
thresholdmemory
0
100
99
1
1
NIL
HORIZONTAL

SLIDER
5
348
176
381
THusememory
THusememory
0
100
90
1
1
NIL
HORIZONTAL

SWITCH
63
10
177
43
targeton?
targeton?
0
1
-1000

SWITCH
5
388
217
421
changedirectionwhenhungry
changedirectionwhenhungry
1
1
-1000

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Circle -7500403 true true 76 150 148
Polygon -7500403 true true 176 164 222 113 238 56 230 0 193 38 176 91
Polygon -7500403 true true 124 164 78 113 62 56 70 0 107 38 124 91

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100001"/>
    <metric>cumpop / 5000</metric>
    <enumeratedValueSet variable="metabolism">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="countdownmax">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probcont">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pmove">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="birth-threshold">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="thresholdmemory">
      <value value="99"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="THusememory">
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
      <value value="80"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="changedirectionwhenhungry">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="targeton?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
