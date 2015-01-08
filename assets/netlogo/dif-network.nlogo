turtles-own
[
  node-clustering-coefficient
  distance-from-other-turtles   ;; list of distances of this node from other turtles
  nan ; number of adopted neighbors
]

links-own
[
  rewired?                    ;; keeps track of whether the link has been rewired or not
]

globals
[
  clustering-coefficient               ;; the clustering coefficient of the network; this is the
                                       ;; average of clustering coefficients of all turtles
  average-path-length                  ;; average path length of the network
  clustering-coefficient-of-lattice    ;; the clustering coefficient of the initial lattice
  average-path-length-of-lattice       ;; average path length of the initial lattice
  infinity                             ;; a very large number.
                                         ;; used to denote distance between two turtles which
                                         ;; don't have a connected or unconnected path between them
  highlight-string                     ;; message that appears on the node properties monitor
  number-rewired                       ;; number of edges that have been rewired. used for plots.
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to startup
  set highlight-string ""
end

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  set infinity 99999  ;; just an arbitrary choice for a large number
  set-default-shape turtles "circle"
  make-turtles

  ;; set up a variable to determine if we still have a connected network
  ;; (in most cases we will since it starts out fully connected)
  let success? false
  while [not success?] [
    ;; we need to find initial values for lattice
    wire-them
    ;;calculate average path length and clustering coefficient for the lattice
    set success? do-calculations
  ]

  ;; setting the values for the initial lattice
  set clustering-coefficient-of-lattice clustering-coefficient
  set average-path-length-of-lattice average-path-length
  set number-rewired 0
  set highlight-string ""
  rewire-all
  ask one-of turtles [set color red]
end

to go

ask turtles [
  let node1 self
  set nan count turtles with [link-neighbor? node1 and color = red]
]
ask turtles
[
  if nan >= threshold [ set color red] 
]

do-plotting
tick
end


to make-turtles
  crt num-nodes [ set color gray + 2 ]
  ;; arrange them in a circle in order by who number
  layout-circle (sort turtles) max-pxcor - 1
  ask turtles [set color white]
end

;;;;;;;;;;;;;;;;;;;;;;;
;;; Main Procedure ;;;
;;;;;;;;;;;;;;;;;;;;;;;

to rewire-all

  ;; make sure num-turtles is setup correctly; if not run setup first
  if count turtles != num-nodes [
    setup
  ]
  
   ;; set up a variable to see if the network is connected
  let success? false
  
  ;; if we end up with a disconnected network, we keep trying, because the APL distance
  ;; isn't meaningful for a disconnected network.
  while [not success?] [
    ;; kill the old lattice, reset neighbors, and create new lattice
    ask links [ die ]
    wire-them
    set number-rewired 0

    ask links [
      
      ;; whether to rewire it or not?
      if (random-float 1) < rewiring-probability
      [
        ;; "a" remains the same
        let node1 end1
        ;; if "a" is not connected to everybody
        if [ count link-neighbors ] of end1 < (count turtles - 1)
        [
          ;; find a node distinct from node1 and not already a neighbor of node1
          let node2 one-of turtles with [ (self != node1) and (not link-neighbor? node1) ]
          ;; wire the new edge
          ask node1 [ create-link-with node2 [ set color cyan  set rewired? true ] ]

          set number-rewired number-rewired + 1  ;; counter for number of rewirings
          set rewired? true
        ]
      ]
      ;; remove the old edge
      if (rewired?)
      [
        die
      ]
    ]

    ;; check to see if the new network is connected and calculate path length and clustering
    ;; coefficient at the same time
    set success? do-calculations
  ]

  ;; do the plotting
  do-plotting
end

to-report do-calculations

  ;; set up a variable so we can report if the network is disconnected
  let connected? true

  ;; find the path lengths in the network
  find-path-lengths

  ;; check whether network got disconnected and ignore those runs (should not happen often);
  ;; we only want to calculate average path length when we have one connected component
  if (sum [length remove infinity distance-from-other-turtles] of turtles )
      != (count turtles * count turtles)
  [
      ;; report that the network is not connected
      set connected? false
  ]
  set average-path-length (sum [sum remove infinity distance-from-other-turtles] of turtles)
                          / (sum [length remove infinity distance-from-other-turtles] of turtles )
  ;; find the clustering coefficient and add to the aggregate for all iterations
  find-clustering-coefficient

  ;; report whether the network is connected or not
  report connected?
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clustering computations ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report in-neighborhood? [ hood ]
  report ( member? end1 hood and member? end2 hood )
end


to find-clustering-coefficient
  ifelse not any? turtles with [count link-neighbors > 1]
  [
    ;; it is undefined
    ;; what should this be?
    set clustering-coefficient 0
  ]
  [
    let total 0
    ask turtles with [ count link-neighbors <= 1]
      [ set node-clustering-coefficient "undefined" ]
    ask turtles with [ count link-neighbors > 1]
    [
      let hood link-neighbors
      set node-clustering-coefficient (2 * count links with [ in-neighborhood? hood ] /
                                         ((count hood) * (count hood - 1)) )
      ;; find the sum for the value at turtles
      set total total + node-clustering-coefficient
    ]
    ;; take the average
    set clustering-coefficient total / count turtles with [count link-neighbors > 1]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Path length computations ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Implements the Floyd Warshall algorithm for All Pairs Shortest Paths
;; It is a dynamic programming algorithm which builds bigger solutions
;; from the solutions of smaller subproblems using memoization that
;; is storing the results.
;; It keeps finding incrementally if there is shorter path through
;; the kth node.
;; Since it iterates over all turtles through k,
;; so at the end we get the shortest possible path for each i and j.

to find-path-lengths
  ;; reset the distance list
  ask turtles
  [
    set distance-from-other-turtles []
  ]

  let i 0
  let j 0
  let k 0
  let node1 one-of turtles
  let node2 one-of turtles
  let node-count count turtles
  ;; initialize the distance lists
  while [i < node-count]
  [
    set j 0
    while [j < node-count]
    [
      set node1 turtle i
      set node2 turtle j
      ;; zero from a node to itself
      ifelse i = j
      [
        ask node1 [
          set distance-from-other-turtles lput 0 distance-from-other-turtles
        ]
      ]
      [
        ;; 1 from a node to it's neighbor
        ifelse [ link-neighbor? node1 ] of node2
        [
          ask node1 [
            set distance-from-other-turtles lput 1 distance-from-other-turtles
          ]
        ]
        ;; infinite to everyone else
        [
          ask node1 [
            set distance-from-other-turtles lput infinity distance-from-other-turtles
          ]
        ]
      ]
      set j j + 1
    ]
    set i i + 1
  ]
  set i 0
  set j 0
  let dummy 0
  while [k < node-count]
  [
    set i 0
    while [i < node-count]
    [
      set j 0
      while [j < node-count]
      [
        ;; alternate path length through kth node
        set dummy ( (item k [distance-from-other-turtles] of turtle i) +
                    (item j [distance-from-other-turtles] of turtle k))
        ;; is the alternate path shorter?
        if dummy < (item j [distance-from-other-turtles] of turtle i)
        [
          ask turtle i [
            set distance-from-other-turtles replace-item j distance-from-other-turtles dummy
          ]
        ]
        set j j + 1
      ]
      set i i + 1
    ]
    set k k + 1
  ]

end

;;;;;;;;;;;;;;;;;;;;;;;
;;; Edge Operations ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;; creates a new lattice
to wire-them
  ;; iterate over the turtles
  let n 0
  while [n < count turtles]
  [
    ;; make edges with the next two neighbors
    ;; this makes a lattice with average degree of 4
    make-edge turtle n
              turtle ((n + 1) mod count turtles)
    make-edge turtle n
              turtle ((n + 2) mod count turtles)
    set n n + 1
  ]
end

;; connects the two turtles
to make-edge [node1 node2]
  ask node1 [ create-link-with node2  [
    set rewired? false
  ] ]
end

;;;;;;;;;;;;;;;;
;;; Plotting ;;;
;;;;;;;;;;;;;;;;

to do-plotting
     set-current-plot "Diffusion"
     plot (count turtles with [color = red])
end
@#$#@#$#@
GRAPHICS-WINDOW
308
70
668
451
17
17
10.0
1
10
1
1
1
0
0
0
1
-17
17
-17
17
1
1
1
ticks
30.0

SLIDER
332
23
491
56
num-nodes
num-nodes
5
500
105
1
1
NIL
HORIZONTAL

SLIDER
12
310
283
343
rewiring-probability
rewiring-probability
0
1
0.16
0.001
1
NIL
HORIZONTAL

MONITOR
15
72
143
117
NIL
clustering-coefficient
3
1
11

MONITOR
147
72
275
117
NIL
average-path-length
3
1
11

PLOT
16
126
279
305
Diffusion
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"virus" 1.0 0 -2674135 true "" ""

BUTTON
20
21
86
54
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
157
21
220
54
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
495
23
667
56
threshold
threshold
0
5
1
1
1
NIL
HORIZONTAL

BUTTON
90
21
153
54
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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

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
setup
repeat 5 [rewire-one]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="vary-rewiring-probability" repetitions="5" runMetricsEveryStep="false">
    <go>rewire-all</go>
    <timeLimit steps="1"/>
    <exitCondition>rewiring-probability &gt; 1</exitCondition>
    <metric>average-path-length</metric>
    <metric>clustering-coefficient</metric>
    <steppedValueSet variable="rewiring-probability" first="0" step="0.025" last="1"/>
  </experiment>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>count turtles with [color = red] + count turtles with [color = green]</metric>
    <enumeratedValueSet variable="num-nodes">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rewiring-probability">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.05"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectedperiod">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vac-rate">
      <value value="0"/>
      <value value="0.0050"/>
      <value value="0.01"/>
      <value value="0.015"/>
      <value value="0.02"/>
      <value value="0.025"/>
      <value value="0.03"/>
      <value value="0.035"/>
      <value value="0.04"/>
      <value value="0.045"/>
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectionrate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="latentperiod">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [color = red] + count turtles with [color = green]</metric>
    <enumeratedValueSet variable="latentperiod">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectionrate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-nodes">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rewiring-probability">
      <value value="0"/>
      <value value="0.0010"/>
      <value value="0.01"/>
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vac-rate">
      <value value="0.05"/>
      <value value="0.06"/>
      <value value="0.07"/>
      <value value="0.08"/>
      <value value="0.09"/>
      <value value="0.1"/>
      <value value="0.11"/>
      <value value="0.12"/>
      <value value="0.13"/>
      <value value="0.14"/>
      <value value="0.15"/>
      <value value="0.16"/>
      <value value="0.17"/>
      <value value="0.18"/>
      <value value="0.19"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectedperiod">
      <value value="4"/>
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
