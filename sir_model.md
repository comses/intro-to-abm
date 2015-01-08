# SIR Model
A classic way to describe the diffusion of a disease in a population is to distinguish three components: susceptible, infected and recovered. The so-called SIR model (link is external) is typically studied using differential equations. There are three variables, S the number of susceptible, I the number of infected, and R the number of recovered. If we exclude population change and only look at the virus, we can model that the number of susceptible decrease over time. The rate of this decrease depends on the number of infected and susceptible people. The more susceptible people there are, the more people can become infected. The more infected people there are, the more they can infect susceptible people. β is the contact rate.

dS ⁄ dt = -βIS

The number of infected people is increased by the number that get infected minus the number of people who recover. People recover at a fixed rate and the recovery rate is given by ν.

dI ⁄ dt = βIS - νI


dR ⁄ dt = νI

Now we can define R0, which is called the [basic reproduction number](http://en.wikipedia.org/wiki/Basic_reproduction_number). The ratio is derived by the expected number of new infections from a single infection in a population where all subjects are susceptible. If R0 is above one, more people get infected with each infection and thus the virus spreads. To combat the epidemic R0 needs to become lower than 1.

R0 = β / ν

