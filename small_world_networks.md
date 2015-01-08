# Small World Networks
One may have experienced an encounter with a stranger who is linked within just a few connections with you. In this way, one might be just a few handshakes away from the president of the United States. Let’s define “handshake” here as literally shaking someone’s hand as you meet in person. Let’s exclude the handshakes presidents give to the crowd when they have rallies. So, how many handshakes are you away from the president? You may be surprised at how small this number is for most people. Let’s do this with a person picked at random from the billions of adults living on this planet and try to define how many handshakes they are away. Any guess? Here we would expect that this number is not much more than a handful of handshakes.

This suggests that the average path length of social networks around the world is small. Psychologist [Stanley Milgram](http://en.wikipedia.org/wiki/Stanley_Milgram) did an experiment in the 1960s where he asked a number of people in the midwestern U.S. to send a letter to somebody in Boston. However, they did not receive the address of the person, but just a number of hints, like occupation. To reach their target, people had to send the letter to somebody they thought would have more success in finding the target. Milgram was interested in whether the letters would arrive at their target address, and how many connections it would take. Not all letters reached their target, but of those that reached the target the average number of links was six. This led to the saying that all people are on average just six handshakes away. This experiment was replicated 35 years later with emails, and again the average number of links between the source and the target was found to be six.

Is the random network a good model for social networks? No, since social networks have another distinctive attribute. Many friends of a person are also friends of each other. This is called clustering within networks. To calculate the clustering coefficient of a node we will look at all the friends of this node, and count how many possible friendships exist between nodes. The total actual friendships among friends were divided by the total possible friendships. This is the clustering coefficient, which was 0.054 in the random network example. In random networks this coefficient is not very high since many connections are random, and friends are not friends of each other.

We will now look at a [small world network](http://en.wikipedia.org/wiki/Small-world_network) that captures both the high level of clustering and a short average path length. The model was developed by [Duncan Watts](http://en.wikipedia.org/wiki/Duncan_J._Watts) and [Steven Strogatz](http://en.wikipedia.org/wiki/Steven_Strogatz). They started with a regular network of nodes that are arranged in a circle. Each node is connected to two nodes to the left and two nodes to the right. This means that the clustering coefficient is 0.50, since 50% of the links between the friends of a node are connected with each other. For a network of 100 nodes, the average path length is about 13 links.

When we relink a few nodes the average path length drops significantly. In the figure below, the relink of four nodes leads to a drop in the average path length from 13 to 9 links. To relink a node, we chose a random node A and then chose randomly from this node one of the links with another node B. The node B is then replaced with a randomly chosen node from the whole population of nodes, except node A and existing nodes of node A.

A new primitive we use is `end1,` which indicates the first turtle of a link. In a directed link this will be the source, and for undirected links it will be the turtle with the lower who number. We first check whether new links can still be added to the turtle of interest. If this is the case, a turtle is drawn who is not yet connected to the turtle of interest. We then create a link between both turtles. In Netlogo this looks like
```
let node1 end1
if [ count link-neighbors ] of end1 < (count turtles - 1)
[
  let node2 one-of turtles with [
    (self != node1) and (not link-neighbor? node1) ]
  ask node1 [create-link-with node2]
]
```
When we start relinking, we will make cross-cuts from one part of the network to another part (Figure 8). This will lead to shorter paths between ends of the network.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_8.png)<br>*
Figure 8. Relinking four nodes of a regular network.*

If we relink many nodes, the average path length will initially drop quickly. The average cluster coefficient stays initially high. As we see in Figure 9, the shortcuts reduce the path length between nodes from both sides of the network, but do not affect the linking among friends. As we see in Figure 9, just a few relinkings lead to networks with high clustering and a low average path length. This is the characteristic of small world networks. If we will relink all the nodes, we will end up with a random network with low average path length and low amount of clustering.

What we call a small world network, is a network with just a small fraction of short cuts. This leads to a high clustering coefficient and a short path-length. This is also the kind of network that we find in social networks. Most people are clustered and friends of friends are friends. But if just a small percentage of the friendships are with very different people, the average path length will be small.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_9.png)<br>*
Figure 9: The average path length (apl) and clustering coefficient (cc) for increasing number of nodes relinked in a network of 100 nodes.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_10.png)<br>*
Figure 10. Degree distribution of small world network when 10% of the nodes are rewired.*


