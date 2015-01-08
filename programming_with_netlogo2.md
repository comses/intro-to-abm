# Programming with NetLogo(2)
Let’s start with the implementation of a model of termites making piles of wood chips. You start a new NetLogo model and first create the interface. You add to buttons “setup” and “go.” The setup button is at the observer level and will be executed once. The go button is at the observer level and goes forever

Also add two sliders: “number” with a minimum of 1 and a maximum of 300 with a stepsize of 1, and “density” with a minimum of 0 and a maximum of 100 with a stepsize of 1.

Next, you will go to the procedures tab, and define setup as follows
```
to setup
  ca
  setup-chips
  setup-termites
end
```
Randomly strew yellow wood chips (patches) with given density
```
to setup-chips
  ask patches [ if random-float 100 < density
    [set pcolor yellow ]]
end
```
Randomly position given number of white termites
```
to setup-termites
  create-turtles number
  ask turtles [set color white
    setxy random-xcor random-ycor]
end
```
Before you continue, click on the setup button in the interface. Does it work?

Now we continue with the go command. When you press on go, the termites (turtles), will continuously execute three rules:

*   look around for a wood chip and pick it up
*   look around for a pile of wood chips
*   look around for an empty spot in the pile and drop off the chip

```
to go
  ask turtles [
    pick-up-chip
    find-new-pile
    drop-off-chip
  ]
end
```
The pick-up-chip command is defined as follows,
```
to pick-up-chip
  while [pcolor != yellow]
    [explore]
  set pcolor black
  set color orange
end
```
where explore command is defined as
```
to explore
  fd 1
  rt random-float 50 – random-float 50
end
```
Find a new pile is defined as
```
to find-new-pile
  while [ pcolor != yellow]
  [ explore]
end
```
Finally, drop off chip is modeled like
```
to drop-off-chip
  while [ pcolor != black]
    [explore]
  set pcolor yellow
  set color white
  fd 20
end
```
Click on the “go” button in the interface. What is happening? If you click on the “Settings” and change the dimensions of number of patches on the screen to a larger number, say 100x100 patches. Will the same results appear?
