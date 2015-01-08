# Different Distributions
There are various types of distributions in NetLogo:
```
random-poisson mean
random-normal average stdev
random-exponential average
random-gamma alpha lambda
```
with alpha equal to _average * average / variance and lambda equal to 1 / (variance / average)_

If we run the model for 10,000 ticks and draw a random number from each distribution we get the following distributions.


![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_11.png)<br>
*Figure 11*

The average of the distributions converge to 1 as seen in the Figure 12 below. It takes a few hunderd observations before the mean becomes close to one. This shows that it is important to have many observations to do models with random numbers. Each run is different and to have an informed decision on the results of the model, you have to run the model many times. Luckily NetLogo has a tool that makes it convenient to run a model many times and store the results in text files for further analysis. We discuss this in the next section.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_12.png)<br>
*Figure 12. The mean of observations of 5 distributions. On the y axis is the number of observations generated.*

[image](https://www.openabm.org/book/33102/55-different-distributions)

---

Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.

----


[Attachment](https://www.openabm.org/files/books/3443/ch5-random-distributions.nlogo)	Size
 ch5-random-distributions.nlogo	12.13 KB
