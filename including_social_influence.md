# Including Social Influence
In the model we described above agents were repeating their decisions, or they were deliberating on finding the solution that maximizes the expected utility. In practice people often benefit from the experiences of other people in making a decision. Using information on other people’s behavior or experiences may function as a cue to simplify the decision task. Especially wchen people are uncertain (due to the complexity of the decision, uncertain personality) and the behavior in question is very visible (either by observation or discussion) social heuristics are used.

People are assumed to imitate if they are uncertain. When agents imitate they follow the majority of the people in the community. This does not necessary lead to a product that satisfies the agent. For example, an agent may imitate the product choice of their friends even though they have different preferences. Another approach is social comparison, where agents look at the products used by agents like them and the agent will evaluate those options.

The expected uncertainty *E [Uncij]* reflects how uncertain an agent i is about having made the best choice when choosing product j. The more friends in their social network consume other products, the more uncertain an agent is. Furthermore, the value of βi determines how sensitive an agent is to not having the same choice as his or her friends. The more important the social need (the lower the value of βi), the more uncertain an agent becomes when his or her friends consume different products:


E [Uncij] = (1 − β)(1 − xj )          (3)

with (1 − xj ) represents the fraction of the friends of agent i who consume a different product than agent i. It is essential that agents start engaging in social processing when their uncertainty exceeds a critical level, the maximum uncertainty level.

Agents make a choice between what they really like and whether they select the same product as their neighbors. We specify the different heuristics they use.

**Deliberate**<br>
Agent evaluate all the options available and will calculate what the expected utility will be if one consumes the product. Based on the expectation she will choose the product with the highest expected utility.<br>
**Repeat**<br>
Agent will repeat her choice from the previous time.<br>
**Imitate**<br>
Agent will copy the most popular product in her neighborhood.<br>
**Socially compare**<br>
Agent will evaluate the most popular product in her neighborhood and will chose this option if it increases her expected utility compared to sticking with her current choice.<br>

Figure 7 shows the chosen products in the social network, and illustrates the clustering of choices in parts of the network. Although initially agents randomly chose a product, within a few time steps we see clusters emerging. Figure 8 shows that in the beginning of the simulation there is a lot of social comparison and imitation, and when the agents start to settle on their choices they continue making repetitive choices.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_7.png)<br>*
Figure 7: Network of agents where each agent is colored according to the product chosen.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_8.png)<br>*
Figure 8. The number of agents who make choices according to a particular heuristic.*

Next we will explore the effect of different levels of the maximum uncertainty level when using a heterogeneous β and a minimum utility of 0.5. We ran the model 100 times 100 ticks at different levels of maximum uncertainty toleration. Figure 9 shows that when no uncertainty is tolerated agents only imitate and socially compare. When the uncertainty tolerance is increased we see repetition and deliberation being included. The gini coefficient drops, and was highest when agents only imitated or socially compared. With a higher maximum allowable uncertainty the average utility is increased a bit since imitation does not necessarily lead to solutions that have high utility.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_9.png)<br>*
Figure 9. Distribution of heuristics for different levels of maximum uncertainty tolerated.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_10.png)<br>*
Figure 10. Gini coefficient of products and average utility for different levels of maximum uncertainty tolerated.*

We will now explore the consequences if agents do not know all the available products at the start of the simulation. Suppose agents have a memory of the products on the market. In previous simulations we assumed that the agents had full knowledge about the opportunities. Suppose that initially they have only a memory of products they and their neighbors are consuming. Agents build up their memory and thus their repertoire of possible products if they see one of their neighbors consuming a product.

Figure 11 shows that there is more equality if agents do not have full knowledge. Since not all options are known, and agents initially are randomly allocated a product, there remains a spread of many products in the population. When agents know the products available, we see that one or two products start to get a larger market share, especially when they use imitation.

The average utility is generally higher when agents have full knowledge. This is not surprising since they have more options available to increase their utility.
However, when agents only care about what others do, and they imitate decisions of others, we see that there will be a higher level of satisfaction.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_11a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_11b.png)<br>*
Figure 11. Gini coefficient (top) and average utility (bottom) for simulations with full and incomplete knowledge for different levels of maximum tolerated uncertainty.*

Figure 12 shows that when agents have incomplete initial knowledge, they will use more deliberation and less repetition. Their utility is more frequent below the threshold of satisfaction leading agents to deliberate.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_12a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_14_Fig_12b.png)<br>*
Figure 12. Share of different heuristics with full (top) and incomplete knowledge (bottom) for different levels of maximum tolerated uncertainty.*


