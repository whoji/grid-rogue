# 大方向

* 大方向是抄袭card quest
* PvE 刷楼
* 打成就。刷角色，刷装备。但是有爬楼的设定，从1开始到无穷
* rogue lite
* 快节奏过关, instant gratification


# 参考游戏 (influenced)
* ff8
* card quest
* rune xxx (steam)

# 游戏mechanics 细节

## 世界stage
* 3x3
* 4x4
* 5x5
* 混搭？ 都有？

## 战斗机理 1
* 自己每次走一步
* 四边都有个数值（参考ff8 card）, 两个选择：
    * 4攻击，中间血量 （偏向）
    * 攻击就是血量(和card quest一样)
        * 等同于内心1滴血
* 敌人一样设计
* 有回血的药瓶子 、 也有被动技能
* 有个格子是上一层楼（同rune xxx / card quest）

## 战斗机理 2 （preferred）
* 自己每次走一步
* 如同炉石的卡牌，有atk和hp
	* let's also add replendable armor concept to player
* 敌人一样设计
* board 里面除了敌人，也有atk和hp的物品 （或者只有加HP的，atk物品槽）
* 有个格子是上一层楼（同rune xxx / card quest）
* 这样就和card quest太像了...
* random spawn token
	* item
	* item craft recipe
	* hp restore
	* enemies: depends on player level
	* stairs: to next level
* if a move doesn't kill an enemies, deduct the HP.

## 战斗机理 3
* similar to 2, but enemies will not respawn.
* go upstair for 0 to 99, with higher and higher difficulties.
* your goal is to reach 99, or die
* you can even go back to previous level to do whatever you want
	* pick something. or heal at fountain.
	* fight boss
* need a vertical mini-map like visualization to highlight fountain.shop.etc

## 战斗机理 4
* make it a pokemon-like game
* collecting enemies
* enemies can be combined and crafted into bigger monsters / relics.
* if killed two same type enemies. than you captured it.
* at the end of each run. you can pick 1 (or more) to add to your monster book

## 物品概念
* 有n个格子的物品槽，里面可以放入收集到的物品
* 物品一般提供被动的效果的
* 满了则替换FIFO，不过允许玩家排序
* all items are passive items. No usable.
* items can be combined !!
	* NEW CRAFTING SYSTEM !!
	* once drafted, it should be easily re-summon at the game start.
	* recipe will appear as item in the game.

## 金钱概念
* 每打掉一个怪物，或者上一层楼都加gold
* 用来解锁人物
* you cannot accumulate the gold between plays.
	* you have to buy stuff after the GAME OVER. then 0 Gold.

## Level Design
* level 1: Player init HP = 5; Enemies 1 - 2HP
* level 2: Player init HP = 10;  Enemies 3 - 5HP
* level 3: Player init HP = 20;  Enemies 5 - 10HP

## Enemies
* all kinds of enmies just like HS creatures.
* enemies no passives. just ATK and HP
* enemies has passives, but simple ?
	* tuant
	* windfury
	* divine shield
* general rule: hp = 2 * atk
* the danger zone concept
	* all like the reaper in persona game
	* prevent player grind at a low level too long
	* reaper can be an unlockable!

## 局内成长
* exp 100 then go up 1 lvl
* only 100, that 100 will not change by hero level or game level
* 1 kill 1 exp. will not change. fixed. so kill 100 enemies gain 1 level 

## between runs player progression
* level up all from the shop.
* or buy power-up for owned heroes
* buy new hero
* find blueprint/card, then you know it, then can unlock it.
	* so from the UI view. all with [?], if with blueprint grayed out hero, full color if bought
* how about instead of blueprint, drop some niudan (gashapon), with unknown content?
	* content will be revealed once the run is over
	* if you got duplicated blueprint. 
		* then you discard them
		* or you can upgrade once got three same item. (<--- if go that route then no need to purchase the hero, then what's the point of gold ????)
		* all convert to the same gold amount . or 50% gold amount

## hero design concept
* not upgrade, but different!
	* different growth
	* different playstyle
* or a 2 dimension matrix.
	* 1 dim: different hero: barb, warrior, mage, beserk
	* 1 dim: just power up that hero. but with sight difference
		* swordman, knight, champ, blademaster
* a passive skill can be enhance stair chance
	* hp chance / amount
	* gold chance / amnout

## hero basic attribute design (6.10.2020)
```
[hero_0]
id=0
max_hp=10
atk=5
cost=100
exp_gain=25     ; that means kill 4 enemies -> level up
max_hp_gain=[10,10,20,20,50,50,100,200,300]
atk_gain=[10,10,20,20,50,50,100,200,300]
cap_level=10
gold_reward_after_reach_max_level=1000
```
* once reached cap level, you can buy this hero again(x2 cost), to x2 everything(hp,atk)