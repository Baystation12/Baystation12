

/* Faction wide stats */

/mob/living/simple_animal/hostile/innie
	faction = "Insurrection"
	health = 100
	maxHealth = 100
	icon = 'code/modules/halo/insurrection/simple_mobs.dmi'
	var/armour_colour = "brown"
	var/armour_tier = "light"

/mob/living/simple_animal/hostile/innie/New()
	. = ..()
	icon_state = "[armour_tier]_innie_[armour_colour]"
	icon_living = "[armour_tier]_innie_[armour_colour]"
	icon_dead = "dead_[armour_tier]_innie_[armour_colour]"



/* Light Defenders */

/mob/living/simple_animal/hostile/innie
	name = "Insurrection Defender (Light)"
	armour_tier = "light"
	combat_tier = 1
	possible_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum)

/mob/living/simple_animal/hostile/innie/black
	name = "Gao Defender (Light)"
	armour_colour = "black"

/mob/living/simple_animal/hostile/innie/green
	name = "Khoros Defender (Light)"
	armour_colour = "green"

/mob/living/simple_animal/hostile/innie/blue
	name = "Freedom Defender (Light)"
	armour_colour = "blue"

/mob/living/simple_animal/hostile/innie/white
	name = "Olympus Defender (Light)"
	armour_colour = "white"



/* Medium Defenders */

/mob/living/simple_animal/hostile/innie/medium
	name = "Insurrection Defender (Medium Armoured)"
	armour_tier = "medium"
	resistance = 5
	combat_tier = 2
	possible_weapons = list(/obj/item/weapon/gun/projectile/ma5b_ar/MA37,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/m392_dmr/innie)

/mob/living/simple_animal/hostile/innie/medium/black
	name = "Gao Defender (Medium Armoured)"
	armour_colour = "black"

/mob/living/simple_animal/hostile/innie/medium/green
	name = "Khoros Defender (Medium Armoured)"
	armour_colour = "green"

/mob/living/simple_animal/hostile/innie/medium/blue
	name = "Freedom Defender (Medium Armoured)"
	armour_colour = "blue"

/mob/living/simple_animal/hostile/innie/medium/white
	name = "Olympus Defender (Medium Armoured)"
	armour_colour = "white"



/* Heavy Defenders */

/mob/living/simple_animal/hostile/innie/heavy
	name = "Insurrection Defender (Heavy Armoured)"
	armour_tier = "heavy"
	resistance = 10
	combat_tier = 3
	possible_weapons = list(/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/m392_dmr/innie,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts)

/mob/living/simple_animal/hostile/innie/heavy/black
	name = "Gao Defender (Heavy Armoured)"
	armour_colour = "black"

/mob/living/simple_animal/hostile/innie/heavy/green
	name = "Khoros Defender (Heavy Armoured)"
	armour_colour = "green"

/mob/living/simple_animal/hostile/innie/heavy/blue
	name = "Freedom Defender (Heavy Armoured)"
	armour_colour = "blue"

/mob/living/simple_animal/hostile/innie/heavy/white
	name = "Olympus Defender (Heavy Armoured)"
	armour_colour = "white"

/* Builder Mob */

/mob/living/simple_animal/hostile/builder_mob/urf
	name = "URF Combat Engineer"
	desc = "Looks like this one has taken the burden of construction rather than combat."
	icon = 'code/modules/halo/insurrection/simple_mobs.dmi'
	icon_state = "light_innie_brown"
	icon_living = "light_innie_brown"
	icon_dead = "light_innie_brown_dead"
	faction = "Insurrection"
