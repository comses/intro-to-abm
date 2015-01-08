turtles-own
[
  threshold
  payoff
  decision
  lifetime
  avgpayoff
  drawn?
  typea ; type agent. 0 conditional cooperation; 1 egoist 2 altruist
]


to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  let teller 0
  set-default-shape turtles "dot"
  ask patches [set pcolor white]
  crt nragents [
    set color green - 3 * threshold
    set threshold random-float 1
    set size 3
    set payoff 0
    set avgpayoff 0
    set lifetime 0
    setxy random-xcor random-ycor
    ifelse random-float 1 < fractionegoists [set typea 1][
        ifelse random-float 1 < fractionaltruists [set typea 2][set typea 0]] 
  ]
  ask n-of nrseeds turtles [set decision 1]
end

to go
  playgames

  ask turtles [fd 1 set lifetime lifetime + 1 set avgpayoff payoff / lifetime]
  if colorcode = "threshold" [ask turtles [set color green - 3 * threshold]]
  if colorcode = "decision" [ask turtles [set color blue - 3 * decision]]
  if colorcode = "type" [ask turtles [if typea = 0 [set color blue] if typea = 1 [set color red] if typea = 2 [set color green]]]
  ask turtles [
;    set size avgpayoff * 0.2 
  ]
  if evolution [reproduction]
  tick
end

to playgames
  ask turtles
  [
    let otheragents other turtles in-radius dist
    let numberofagents count other turtles in-radius dist
    if numberofagents > 0 [
       let meandecision mean [decision] of otheragents
       if typea = 0 [ifelse meandecision >= threshold [set decision 1][set decision 0]]
       if typea = 1 [set decision 0]
       if typea = 2 [set decision 1]
       
    ]
  ]
  ask turtles 
  [
    let otheragents other turtles in-radius dist
    let numberofagents count other turtles in-radius dist
    if numberofagents > 0 [
      let meandecision mean [decision] of otheragents
      set payoff payoff + 1 - decision + 0.6 * (meandecision * numberofagents + decision)
      ifelse meandecision > threshold [
        face one-of other turtles in-radius dist
      ][
        face one-of other turtles in-radius dist
        set heading heading + 180
      ]
    ]
  ]  
end

to reproduction 
  let agent min-one-of turtles [avgpayoff]
  ask agent [
    set threshold random-float 1
    set payoff 0
    set decision 0
    set lifetime 0
    set avgpayoff 0
    let frego count turtles with [typea = 1] / 1000
    let fralt count turtles with [typea = 2] / 1000
    setxy random-xcor random-ycor
    ifelse random-float 1 < frego [set typea 1][
    ifelse random-float 1 < fralt [set typea 2][set typea 0]] 
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
189
12
651
495
-1
-1
4.48
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
100
0
100
1
1
1
ticks
30.0

BUTTON
11
10
82
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
11
48
78
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
11
86
183
119
nragents
nragents
2
1000
1000
1
1
NIL
HORIZONTAL

SLIDER
11
123
183
156
dist
dist
0
20
2
1
1
NIL
HORIZONTAL

PLOT
657
423
902
621
Histogram threshold
NIL
NIL
0.0
1.0
0.0
1.0
true
false
"set-histogram-num-bars 21" ""
PENS
"marco" 1.0 1 -16777216 true "" "histogram [threshold] of turtles"

CHOOSER
12
334
150
379
colorcode
colorcode
"threshold" "decision" "type"
1

PLOT
657
218
902
420
collective action
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [decision = 1]"

SWITCH
12
283
123
316
evolution
evolution
0
1
-1000

BUTTON
84
48
147
81
NIL
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
11
160
183
193
nrseeds
nrseeds
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
11
197
183
230
fractionegoists
fractionegoists
0
1
0.33
0.01
1
NIL
HORIZONTAL

SLIDER
11
234
183
267
fractionaltruists
fractionaltruists
0
1
0.33
0.01
1
NIL
HORIZONTAL

PLOT
657
12
901
215
types
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"conditional" 1.0 0 -13345367 true "" "plot count turtles with [typea = 0]"
"egoist" 1.0 0 -2674135 true "" "plot count turtles with [typea = 1]"
"altruists" 1.0 0 -13840069 true "" "plot count turtles with [typea = 2]"

@#$#@#$#@
This is a Netlogo implementation of the model described in Janssen, M.A. (2008), Evolution of Cooperation in a One-Shot Prisoner�s Dilemma Based on Recognition of Trustworthy and Untrustworthy Agents, Journal of Economic Behavior and Organization 65: 458-471

The original model was implemented in 2002 in Java. Janssen (2008) includes one error in the table of default parameter values. In the original Java model I used absolute values for alpha and beta between 0 and 4. In the paper I scaled it to values between 0 and 1, relative to the difference between the payoff of S and T. I forgot to adjust the mutation rates of alpha and beta from 0.1 to 0.025.

The results of Janssen (2008) are replicated with this Netlogo version.

The replication is performed by Marco A. Janssen, Arizona State University, March 2008.  
Copyright (C) 2008 M.A. Janssen

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.  
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.  
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
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
NetLogo 5.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count turtles with [decision = 1]</metric>
    <enumeratedValueSet variable="dist">
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolution">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="colorcode">
      <value value="&quot;decision&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nragents">
      <value value="1000"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

@#$#@#$#@
0
@#$#@#$#@
