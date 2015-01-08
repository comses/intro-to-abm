# Creating a Landscape
In this section we create a landscape where different types of food resources are located. Unlike the model in the previous chapter where one resource was spread throughout the whole landscape, now we assume that there are multiple types of resources spread over the landscape.

Before we discuss how we implement the landscape we need to introduce a new primitive, namely `list.` This primitive allows us to store a list of values, turtles, strings. This is helpful to store information in an efficient way. To define a list you can simply put the values in a list between brackets separated by spaces like set `listname [1 2 3 4].`

If you want to use a value of the list you call it by `item i` where i is the location of the value in the list. Note that Netlogo starts counting with 0 at the first location. Thus
```
item 1 listname
```
is equal to
```
2
```
To change the values of a list you need to use `replace-item i.` For example, if you want to replace the value 3 to 5 then you do
```
set listname replace-item 2 listname 5
```
`listname` is now `[1 2 5 4].`

To add an item at the end of the list you use `lput.` For example, you want to add the value 6 to `listname` then you will do the following
```
set listname lput 6 listname
```
This leads to `[1 2 5 4 6].`

However, if you want to add a value at the beginning of the list you use `fput.` For example, you add 7 in front of `listname` then you do
```
set listname fput 7 listname
```
which leads to `[7 1 2 5 4 6].`

We now go back to the foraging model landscape. We will distinguish 3 food sources. Each food resource has a certain density, a level of energy and color that displays in the interface. We now define the lists that we will use in creating the maps:
```
set density [0.01 0.005 0.001]
set foodenergy [10 20 100]
set foodcolor [green red blue]
```
To create the environment we will randomly place patches on the landscape that contain one of the three types of food. Only one of the food types can be on a patch. We also want to have the number of patches for each food type equal to the number needed to generate the density that is defined in the list above. If the number of cells is `world-width * world-height` then the number of cells that will be needed to create the density for food type i is equal to `item i density * (world-width * world-height).`

Now we can create the algorithm that will create the initial map of food resources. For each food type we will turn patches into food sources until the desired density is reached.
```
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
  ```
This leads to a landscape like in Figure 2.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_7_Fig_2.png)<br>*
Figure 2: Map generated with 3 food types.*

What happens if a food item is eaten? Do we replace the food item immediately at the same place or will it appear later at another place? With our model we will explore the consequences of uncertainty, so we will make a model where we can define how frequently a food item is replenished at the same location or at another random location at the map. We also will include the possibility of a delay of replenishment.

If a patch is not colored black, there is a food item. The agent determines which food item it is, collects the food and determines the replenishment.
```
if pcolor != black [
  let iter 0
  while [iter < 3]
  [
    if pcolor = item iter foodcolor
    [
      set pcolor black
      set whichfood 0
      set energy energy + item iter foodenergy
      ```
With a probability `pmove` the food will be replenished at another location. If the food location is replaced, a countdown process will start to time when the food will become available. This also happens when the food location does not change.
```
      ifelse random-float 1 < pmove [
        ask one-of patches with [whichfood = 0]
        [
          set countdown countdownmax
          set whichfood (iter + 1)
        ]
      ][
        set countdown countdownmax set whichfood (iter + 1)]
      ]
      set iter iter + 1
    ]
  ]
  ```
We created a countdown for food items when they are eaten, so each tick we will need to update the countdown. To do this we added the procedure regrowth that is triggered each tick. If the `countdown` equals 0 the patch will be colored according to the food type on the patch.
```
to regrowth
  ask patches with [countdown > 0]
  [
    set countdown countdown - 1
    if countdown = 0 [set pcolor item (whichfood - 1) foodcolor]
  ]
end
```

