# Random Numbers in NetLogo
The basic command in NetLogo to generate random numbers is ``random.`` ``Random 100`` means that an integer value is randomly drawn from the series 0, 1, 2, …97, 98, 99. If you type in ``show random 100`` then you will get a different value every time.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_1.png)<br>*Figure 1.*

As we discussed in Chapter 3 a random number is an outcome from a deterministic function. If you start the function with the same number you will get the same sequence as we show here:

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_2.png)<br>*Figure 2.*

If you want to have real numbers instead of integer numbers, you have to use ``random-float.`` With ``random-float 100`` the numbers will be between 0 and 100 as shown below

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_3.png)<br>*Figure 3.*



