# Bug-bird Co-evolution
Instead of playing the game and simply catching bugs we can model the hunting behavior of the preditor—the bird. Once we do this we can even model an entire population of birds.

The model distinguishes two types of hunting behavior that we discuss below. Each bird first determines whether there are any bugs within the vision of the bird.
```
set candidate-bugs bugs in-cone initial-bird-vision  120
```
If there are multiple bugs within the bird’s vision, which one will the bird follow? The first strategy is for the bird to lock onto a target bug. If the bird has not defined a target it will choose the nearest bug.

The following code defines the heading of the bird before it is moved. The first line is to define the closest bug, which is the bug with the shortest distance to the bird out of the list of candidate bugs.
```
set closest-bug min-one-of candidate-bugs
[distance myself]
```
The following statement defines that if there was no pursuit and the agent wants to pursue a target bug, the closest bug is the target bug.
```
if (target = nobody and bug-pursuit-strategy = "lock on one") [
  set prey-agent closest-bug
  set target prey-agent
  set heading towards prey-agent
]
```
If the bug goes after the closest bug it will have the heading towards the closest bug.
```
if (bug-pursuit-strategy = "closest" and target != closest-bug) [
  set prey-agent closest-bug
  set target prey-agent
  set heading towards prey-agent
]
```
We notice that nothing is said about what would happen if the agent already has a target. This target may change its position forcing the bird to adjust its heading to remain successful. Therefore we add the following, which will be added directly after the closest bug is determined.
```
if (target != nobody and bug-pursuit-strategy = "lock on one") [
  set heading towards prey-agent
]
```
When birds and bugs reproduce there is a mutation of the speed and vision levels of the parent. Reproduction is asexual, but the child is not an exact clone of the parent. To include mutation the hatched new bug or bird will be adjusted for speed and vision. Below is the code for the speed of the bug. In 50% of a parent’s offspring, the speed will be higher than the parent and in the other 50% it will be lower. The amount it will be higher or lower is a random value between 0 and the mutation rate. Note that the model includes upper and lower values for speed. Speed cannot be negative, and because of physical constraints speed is also assumed to be constrained to a maximum value.
```
ifelse random 2 = 0
  [set speed (speed + random-float bug-speed-mutation )]
  [set speed (speed - random-float bug-speed-mutation )]

if speed > max-speed [set speed max-speed]
if speed < 0 [set speed 0]
```

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch__Fig_5.png)<br>*
Figure 5. Screenshot of Bug Hunt Coevolution.*

Figure 6 show some typical results of this model. Bugs benefit by going faster to survive. The same holds for birds, especially if the birds start to speed up. When a bug’s vision increases it starts to flee earlier, so a bird benefits when it can spot a bug first (and move faster than the bug).

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_8_Fig_6.png)<br>*
Figure 6: Evolution of speed and vision of birds and bugs.*


