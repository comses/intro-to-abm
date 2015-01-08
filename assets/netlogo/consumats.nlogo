globals [
  chosen gini avgutil
  totrep totim totsc totdel
] 
breed [products product]
breed [agents agent] ;; decision makers
products-own [product-number attribute nrticks] ;; each product has a different quality 
agents-own [
  share
  preference 
  utility 
  repertoire 
  repertoirelist
  productlist 
  choice-num
  choice 
  normative
  payoff-choice
  prev-payoff 
  prev-product-numb 
  prev-attribute ;; decision-makers variables
  typeofchoice
  uncertainty]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  let numb 1
  let help 0
  set totrep 0
  set totim 0
  set totsc 0
  set totdel 0
  create-products nrproducts ;; putting productes
  [
    set hidden? true
    set product-number numb
    set attribute random-float 1
    setxy 0 0
    set numb numb + 1
    set nrticks 0
   ]
  
  ;; make the initial network of two turtles and an edge
  setup-nodes
  setup-spatially-clustered-network
  let teller 0
  ask agents ;; 100 decision makers
  [
    set teller 0
    ifelse heterobeta [set normative random-float 1][set normative beta]
    set repertoire []
    set prev-product-numb 1 + random nrinitproducts
    set choice-num prev-product-numb
    let dummy-choice-num choice-num
    set choice one-of products with [product-number = dummy-choice-num]
    set utility []
    set productlist []
    set share []
    while [teller < nrproducts] 
    [  
      set repertoire lput 0 repertoire
      set repertoirelist []
      set repertoirelist lput (choice-num - 1) repertoirelist
      set share lput 1 share
      set utility lput 0 utility
      set productlist lput (teller + 1) productlist
      set teller teller + 1]
 ;   let prefagent preference
;    ask link-neighbors [set preference 0.8 * preference + 0.2 * prefagent] 
  ]
  set chosen []
  if fullknowledge [
    ask agents [
      set teller 0
      while [teller < nrproducts]
      [
        if count link-neighbors > 0 [set share replace-item teller share ((count link-neighbors with [(teller + 1) = choice-num])/ count link-neighbors)]
        
        set help (1 - abs (preference - [attribute] of turtle teller)) * normative + (1 - normative) * item teller share 
        set repertoire replace-item teller repertoire help
        set repertoirelist lput teller repertoirelist
        set teller teller + 1
      ]
    ]
  ]
end

to setup-nodes
  crt nragents
  [
    set breed agents
    set preference random-float 1
    setxy random-xcor random-ycor
    set size 0.06
    set shape "dot"
  ]
end

to setup-spatially-clustered-network
  let num-links (average-node-degree * nragents) / 2
  while [ count links < num-links ]
  [
    ask one-of agents
    [
      ask other agents with [not link-neighbor? myself]
      [
        if random-float 1 < ( average-node-degree / ( 2 * pi * D ^ 2 ) ) * e ^ ( -1 * nragents * (distance myself) ^ 2 / (2 * D ^ 2) ) 
        [
          create-link-with myself
        ]
      ]
    ]
  ]
end

to go
  make-decision ;; agents make decisions
  ask agents [
    set prev-product-numb choice-num
    set prev-payoff payoff-choice ;;save it for social learner next round
    set prev-attribute [attribute] of choice
    set color 7 + choice-num * 10
  ] 
  ask agents [
    if random-float 1 < advertisement2 [if not member? 1 repertoirelist [set repertoirelist lput 1 repertoirelist]]
    ]
  tick
  do-plot ;; plot numbers of majority and minority
  calgini
  let teller 0
  set chosen []
  
end

to make-decision ;; strategy should be written here
  
   ask agents [
      let teller 0
      while [teller < nrproducts]
      [
        if member? teller repertoirelist [
          if count link-neighbors > 0 [set share replace-item teller share ((count link-neighbors with [(teller + 1) = choice-num])/ count link-neighbors)]
          let help (1 - abs (preference - [attribute] of turtle teller)) * normative + (1 - normative) * item teller share 
          set repertoire replace-item teller repertoire help
        ]
        set teller teller + 1
      ]
    ]
  
  ask agents [
    set utility replace-item (choice-num - 1) utility ((1 - abs (preference - [attribute] of choice)) * normative + (1 - normative) * item (choice-num - 1) share) ;; get the quality of the product]
    set uncertainty (1 - normative) * (1 - item (choice-num - 1) share)
  ]
  
  ask agents [
    ifelse random-float 1 < probbuying [
      ifelse sum repertoire != 0 [
        ifelse item (choice-num - 1) utility >= utilitymin [
          ifelse uncertainty >= uncertaintymax [imitation set typeofchoice 1][repetition set typeofchoice 2]
        ][
          ifelse uncertainty >= uncertaintymax [socialcomparison set typeofchoice 3][deliberation set typeofchoice 4]
        ]
      ]
      [innovate]
     ][
     set chosen lput (choice-num - 1) chosen
     set typeofchoice 5
  ]]
end

to innovate ;; 
  if not empty? productlist ;; productlist is a list that tells which productes are investigated yet
  [
    ; choose valid product (< nrproducts)
    let choose-product-numb one-of productlist ;; choose one of products that has not been investigated from each agent's list
    let target-product one-of products with [product-number = choose-product-numb] ;; choose a product 
    let target-product-number [product-number] of target-product ;; get the product number, which was given in the beginning 
    set productlist remove target-product-number productlist
    
    set choice-num target-product-number
    set choice target-product
    set chosen lput (target-product-number - 1) chosen
    
    if count link-neighbors > 0 [
    set share replace-item (choose-product-numb - 1) share ((count link-neighbors with [prev-product-numb = choose-product-numb])/ count link-neighbors)]
        
    set payoff-choice (1 - abs (preference - [attribute] of target-product)) * normative + (1 - normative) * item (choose-product-numb - 1) share ;; get the quality of the product]

    let target-product-attribute [attribute] of target-product
    set repertoire replace-item (target-product-number - 1) repertoire payoff-choice ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.     
  ]
end

to imitation
  if count link-neighbors > 0
  [
    let drawn random-float 1
    let teller 0
    let cumshare item teller share
    while [teller < nrproducts]
    [
     ifelse drawn <= cumshare [set choice-num teller + 1 set teller nrproducts][set teller teller + 1 set cumshare cumshare + item teller share] 
    ]
    
    set repertoire replace-item (choice-num - 1)  repertoire 1 ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.  
    set chosen lput (choice-num - 1) chosen
    set choice turtle (choice-num - 1) 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
  ]
end

to socialcomparison
  if count link-neighbors > 0
  [
    let drawn random-float 1
    let teller 0
    let cumshare item teller share
    let imchoice 0
    while [teller < nrproducts]
    [
     ifelse drawn <= cumshare [set imchoice teller + 1 set teller nrproducts][set teller teller + 1 set cumshare cumshare + item teller share] 
    ]
    let imutility (1 - abs (preference - [attribute] of choice)) * normative + (1 - normative) * item (imchoice - 1) share
    if imutility > item (choice-num - 1) utility [set choice-num imchoice]    
        
    set repertoire replace-item (choice-num - 1)  repertoire 1 ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.  
    set chosen lput (choice-num - 1) chosen
    set choice turtle (choice-num - 1) 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
  ]
end

to deliberation
let listmax []
  if sum repertoire != 0 ;;if repertoire is empty, agents cannot exploit
  [
    let teller 1
    let payoffestimate 0
    while [teller <= nrproducts] 
    [
      if member? (teller - 1) repertoirelist [
        if count link-neighbors > 0 [
        set share replace-item (teller - 1) share ((count link-neighbors with [prev-product-numb = teller])/ count link-neighbors)]
      
        set payoffestimate (1 - abs (preference - [attribute] of turtle (teller - 1))) * normative + (1 - normative) * item (teller - 1) share ;; get the quality of the product]

        set repertoire replace-item (teller - 1) repertoire payoffestimate
      ]
      set teller teller + 1
    ] 
    
    set teller 0
    let maxrep max repertoire ;; choose a max in repertoire
    while [teller < nrproducts]
    [
      if member? teller repertoirelist [
         if item teller repertoire = maxrep [set listmax lput teller listmax]
      ]
      set teller teller + 1
    ]
    set choice-num 1 + one-of listmax
    set chosen lput (choice-num - 1) chosen
    let help choice-num
    set choice one-of products with [product-number = help] ;; choose the product
       
    set repertoire replace-item (choice-num - 1) repertoire payoff-choice ;;place it in repertoire. 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
  ]
end

to repetition
 set chosen lput (choice-num - 1) chosen
end

to do-plot
  set-current-plot "share-products"
  histogram chosen
  
   
  set-current-plot "Choices"
  set-current-plot-pen "imitation"
  plot count agents with [typeofchoice = 1]
  set-current-plot-pen "repetition"
  plot count agents with [typeofchoice = 2]
  set-current-plot-pen "socialcomparison"
  plot count agents with [typeofchoice = 3]
  set-current-plot-pen "deliberation"
  plot count agents with [typeofchoice = 4]
  
  set totim totim + count agents with [typeofchoice = 1]
  set totrep totrep + count agents with [typeofchoice = 2]
  set totsc totsc + count agents with [typeofchoice = 3]
  set totdel totdel + count agents with [typeofchoice = 4]
  
  set-current-plot "utility/uncertainty"
  set-current-plot-pen "utility"
  set avgutil 0
  ask agents [
    set avgutil avgutil + item (choice-num - 1) utility
  ]
  set avgutil avgutil / nragents
  plot avgutil
  set-current-plot-pen "uncertainty"
  plot sum [uncertainty] of agents / nragents
  
  set-current-plot "share-products-time"
  set-current-plot-pen "1"
  plot count agents with [choice-num = 1]
  set-current-plot-pen "2"
  plot count agents with [choice-num = 2]
  set-current-plot-pen "3"
  plot count agents with [choice-num = 3]
  set-current-plot-pen "4"
  plot count agents with [choice-num = 4]
  set-current-plot-pen "5"
  plot count agents with [choice-num = 5]
  set-current-plot-pen "6"
  plot count agents with [choice-num = 6]
  set-current-plot-pen "7"
  plot count agents with [choice-num = 7]
  set-current-plot-pen "8"
  plot count agents with [choice-num = 8]
  set-current-plot-pen "9"
  plot count agents with [choice-num = 9]
  set-current-plot-pen "10"
  plot count agents with [choice-num = 10]
end

to calgini
  let choices []
  let k 1
  while [k <= nrproducts]
  [
   set choices lput count agents with [choice-num = k] choices
   set k k + 1 
  ]
  set k 1
  let sumdif 0
  while [k <= nrproducts]
  [
    let k2 k + 1
    while [k2 < nrproducts]
    [
       set sumdif sumdif + abs (item k choices - item k2 choices)
       set k2 k2 + 1
    ]
    set k k + 1 
  ]
  set gini sumdif / (nrproducts * nragents)
end
@#$#@#$#@
GRAPHICS-WINDOW
416
10
726
341
0
0
300.0
1
10
1
1
1
0
0
0
1
0
0
0
0
0
0
1
ticks
30.0

BUTTON
2
46
65
79
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
67
46
130
79
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

PLOT
420
346
725
510
share-products
type
number
0.0
25.0
0.0
10.0
true
false
"" ""
PENS
"minority" 1.0 1 -16777216 true "" ""

SLIDER
2
10
130
43
nrproducts
nrproducts
1
25
10
1
1
NIL
HORIZONTAL

SLIDER
145
11
268
44
nragents
nragents
1
1000
500
1
1
NIL
HORIZONTAL

BUTTON
133
46
196
79
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
3
85
133
118
beta
beta
0
1
0
0.01
1
NIL
HORIZONTAL

SLIDER
3
121
133
154
average-node-degree
average-node-degree
0
20
14
1
1
NIL
HORIZONTAL

SLIDER
138
85
269
118
D
D
2
10
2
1
1
NIL
HORIZONTAL

SWITCH
276
11
407
44
fullknowledge
fullknowledge
0
1
-1000

SLIDER
275
85
408
118
utilitymin
utilitymin
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
275
121
410
154
uncertaintymax
uncertaintymax
0
1
0
0.01
1
NIL
HORIZONTAL

PLOT
732
12
1177
286
Choices
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"imitation" 1.0 0 -16777216 true "" ""
"repetition" 1.0 0 -13345367 true "" ""
"socialcomparison" 1.0 0 -10899396 true "" ""
"deliberation" 1.0 0 -2674135 true "" ""

PLOT
4
193
414
405
utility/uncertainty
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"utility" 1.0 0 -16777216 true "" ""
"uncertainty" 1.0 0 -13345367 true "" ""

SWITCH
199
47
299
80
homophily
homophily
1
1
-1000

SWITCH
305
48
408
81
heterobeta
heterobeta
0
1
-1000

SLIDER
138
122
270
155
probbuying
probbuying
0
1
0.1
0.01
1
NIL
HORIZONTAL

PLOT
734
289
1174
508
share-products-time
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1" 1.0 0 -16777216 true "" ""
"2" 1.0 0 -2064490 true "" ""
"3" 1.0 0 -8630108 true "" ""
"4" 1.0 0 -13345367 true "" ""
"5" 1.0 0 -11221820 true "" ""
"6" 1.0 0 -13840069 true "" ""
"7" 1.0 0 -1184463 true "" ""
"8" 1.0 0 -6459832 true "" ""
"9" 1.0 0 -955883 true "" ""
"10" 1.0 0 -2674135 true "" ""

SLIDER
138
157
270
190
advertisement2
advertisement2
0
1
0
0.01
1
NIL
HORIZONTAL

SLIDER
4
156
134
189
nrinitproducts
nrinitproducts
0
10
10
1
1
NIL
HORIZONTAL

@#$#@#$#@
nrproducts is the number of products  
nragents is the number of agents

Scenario on/off means the following. If scenario is on you can control alpha, beta, homopref, psample, pinformative and threshold via the sliders on the left. If scenario is off, you get random values generated (used for the monte carlo simulation). The generated values you will then see on the right.

Alpha is the "subsidy" between timestep 50 and 100 for product 1  
beta is the weight the agent gives to the share of products consumed by neighbors  
homopref is the level of homophily. If homopref is one all agents have the same preferences.  
psample is the probability the agents will sample  
pinformative is the probability the agents will consult its neighbors  
threshold is the level below which a product is replaced (not used in current analysis)

Network: you can chose between scale free network, or the other network. With the other network you can define the average node degree and the value of D. D affect the number of short cuts. If D is low the connections are only local, with D is high you get more links between different parts of the screen.
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
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>nrabove</metric>
    <metric>avggini</metric>
    <metric>avgconc</metric>
    <metric>avgshare1</metric>
    <metric>threshold</metric>
    <metric>beta</metric>
    <metric>psample</metric>
    <metric>pinformative</metric>
    <metric>homopref</metric>
    <metric>alpha</metric>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nragents">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>gini</metric>
    <metric>avgutil</metric>
    <metric>totim</metric>
    <metric>totrep</metric>
    <metric>totsc</metric>
    <metric>totdel</metric>
    <enumeratedValueSet variable="average-node-degree">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nragents">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="0"/>
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
