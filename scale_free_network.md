# Scale Free Network
The final cartoon network we will discuss is the scale free network. The term cartoon network is used since actual networks do not exactly follow the idealized networks we are modeling. More detailed simulation models are used to capture more detailed network characteristics of specific networks.

The scale free network captures the observation that the degree distribution is not normally distributed in many real world networks as we saw in Figures 7 and 10. For example, many websites do not link to others, but some have many links. This last category is considered to be a hub. If we plot the degree distribution on a [log-log scale](http://en.wikipedia.org/wiki/Log-log_plot) (Figure 11) we see a straight line. If it were a normal distribution, the frequency of observations with a high in-degree, say 100, would be close to zero. This means that in a scale-free distribution, the distribution has [fat tails](http://en.wikipedia.org/wiki/Fat-tailed_distribution). There are more outliers than would have been in a normal distribution.

These kinds of scale-free degree distributions have been found in many networks. Often they do not follow a straight line for the whole distribution, but for a large part, indicating fat tails of the distribution.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_11.png)<br>*
Figure 11: Degree distribution of world-wide web. Nodes are web pages; links are directed URL hyperlinks from one page to another. The log–log plot shows the number of web pages that have a given in-degree (number of incoming links). Source: Strogatz (2001).*

Barabasi and Albert (1999) published a simple model that generates networks that have a scale-free degree distribution. The model is based on [preferential attachment](http://en.wikipedia.org/wiki/Preferential_attachment). Starting with two nodes, every new node will be linked to the existing network, but with a higher preference to nodes with higher degree number. Thus nodes with high degree have a higher probability of getting more nodes connected. This is also called the “rich become richer” phenomenon.

To model the process to draw a connecting node based on the degree of the nodes already in the network, we implement the following in Netlogo. First we draw a random value between 0 and the total degree number in the network. Then in random order the degree of turtles are added until the algorithm surpasses the cumulative number of degrees the random number initially generated. This is a partnering turtle that is drawn to be connected to the new turtles. The higher the level of the degree the more likely that turtle will be drawn.
```
let total random-float sum [count link-neighbors] of turtles
let partner nobody
ask turtles
[
  let nc count link-neighbors
  if partner = nobody
  [
    ifelse nc > total
      [ set partner self ]
      [ set total total - nc ]
  ]
]
```
In Figure 12 you see a snapshot of the network generation in process. The size of the nodes is proportional to the degree. We see a few hubs and many nodes that are only connected to one other node.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_12.png)<br>*
Figure 12. A typical scale free network.*

Figure 13 shows the degree distribution of the network of 100 nodes generated in the example of Figure 12. The distribution approximates a scale-free distribution, meaning a straight line on a log-log scale of the number of nodes and the degree. The network has 66 nodes with degree one, and only two nodes with a degree higher than 8.

The clustering coefficient is 0, since friends of friends are not friends. The average path length is 4.14, which is higher than the average path length when the network was randomly generated (2.96).

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_13.png)<br>*
Figure 13. Degree distribution of the network in Figure 12 of 100 nodes.*


