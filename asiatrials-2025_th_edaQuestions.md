**Questions for EDA**

*Important note: we only care about the PRO event, meaning you have to account for that in your queries in the event_id column*

---

**Overarching concern:**
Where is the sport growing in Asia/Oceania?

---

**Participation / Growth**

* How many matches were recorded per country (as a proxy for activity level)?
* How many unique athletes did each country have (counting both winners and losers)?

---

**Competitive Structure**

* What is the gender distribution overall and within each country?

---

**Country-Level Performance**

* What was the total medal count per country in terms of golds, silvers and bronzes?
* What was the overall win rate vs lose rate of each country represented?
   Account for sample size.
* What is the submission rate per country (percentage of wins by submission)?
* What are the most common submission types overall and by country?
* What is the average match time per country (as a proxy for efficiency/aggression)?

**Country vs Country** (Subset of country level performance)

* What are the head-to-head records between countries (winner_country vs loser_country matrix)?
* Where do upsets occur, defined as lower-represented countries defeating higher-represented countries?

**Gym-Level Performance**

* What is the win rate per gym (with a minimum match/sample threshold)?
* What is the submission rate per gym?
* Which gyms have the most unique athletes, and how does that compare to their total match count (depth vs volume)?
* How many gyms were represented at the last Asian trials?
* What countries did they come from, list the countries from most gyms to least.
* Which gyms sent the most athletes, which sent the least.

**Match Dynamics**

* What is the distribution of finish methods (submission vs other)?
* How are matches distributed by time-to-finish (e.g., <60s, 60–180s, etc.)?
* What are the fastest finishes by bracket and by country?

