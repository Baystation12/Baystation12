/datum/deity_item/conjuration
	name = DEITY_TREE_CONJURATION
	desc = "Conjuration is the school of creation and teleportation, summoning fireballs or teleporting long distances, this school is extremely powerful."
	category = DEITY_TREE_CONJURATION
	max_level = 3
	base_cost = 50

/datum/deity_item/conjuration/get_cost(var/mob/living/deity/D)
	return base_cost * (level + 1)

//Level 1
/datum/deity_item/boon/single_charge/create_air
	name = "Create Air"
	desc = "Allows your follower to generate a livable atmosphere in the area they are in."
	base_cost = 25
	category = DEITY_TREE_CONJURATION
	boon_path = /spell/create_air/tower
	requirements = list(DEITY_TREE_CONJURATION = 1)

/datum/deity_item/boon/single_charge/acid_spray
	name = "Acid Spray"
	desc = "The simplest form of aggressive conjuration: acid spray is quite effective in melting both man and object."
	base_cost = 130
	category = DEITY_TREE_CONJURATION
	boon_path = /spell/acid_spray/tower
	requirements = list(DEITY_TREE_CONJURATION = 1)

/datum/deity_item/boon/single_charge/force_wall
	name = "Force Wall"
	desc = "A temporary invincible wall for followers to summon."
	base_cost = 30
	category = DEITY_TREE_CONJURATION
	boon_path = /spell/aoe_turf/conjure/forcewall/tower
	requirements = list(DEITY_TREE_CONJURATION = 1)

/datum/deity_item/phenomena/dimensional_locker
	name = "Phenomena: Dimensional Locker"
	desc = "Gain the ability to move a magical locker around. While it cannot move living things, you can move it around as you please, even disappearing it into the nether."
	base_cost = 50
	category = DEITY_TREE_CONJURATION
	phenomena_path = /datum/phenomena/movable_object/dimensional_locker
	requirements = list(DEITY_TREE_CONJURATION = 1)

//Level 2
/datum/deity_item/boon/single_charge/faithful_hound
	name = "Faithful Hound"
	desc = "This spell allows a follower to summon a singular spectral dog that guards the nearby area. Anyone without the password is barked at or bitten."
	base_cost = 40
	category = DEITY_TREE_CONJURATION
	boon_path = /spell/aoe_turf/conjure/faithful_hound/tower
	requirements = list(DEITY_TREE_CONJURATION = 2)

/datum/deity_item/wizard_armaments
	name = DEITY_UNLOCK_ARMS
	desc = "Unlock spells related to the summoning of weapons and armor. These spells only last a short duration, but are extremely effective."
	base_cost = 25
	category = DEITY_TREE_CONJURATION
	requirements = list(DEITY_TREE_CONJURATION = 2)

/datum/deity_item/boon/single_charge/sword
	name = "Summon Sword"
	desc = "This spell allows your followers to summon a golden firey sword for a short duration."
	base_cost = 50
	boon_path = /spell/targeted/equip_item/dyrnwyn/tower
	category = DEITY_TREE_CONJURATION
	requirements = list(DEITY_UNLOCK_ARMS = 1)

/datum/deity_item/boon/single_charge/shield
	name = "Summon Shield"
	desc = "This spell allows your followers to summon a magical shield for a short duration."
	base_cost = 20
	boon_path = /spell/targeted/equip_item/shield/tower
	category = DEITY_TREE_CONJURATION
	requirements = list(DEITY_UNLOCK_ARMS = 1)

/datum/deity_item/phenomena/portals
	name = "Phenomena: Portals"
	desc = "Gain the ability to create portals for your followers to enter through. You will need to create two for it work. Any created past that will delete the oldest portal."
	base_cost = 75
	requirements = list(DEITY_TREE_CONJURATION = 2)
	category = DEITY_TREE_CONJURATION
	phenomena_path = /datum/phenomena/portals

//Level 3
/datum/deity_item/boon/single_charge/fireball
	name = "Fireball"
	desc = "Embue your follower with the power of exploding fire."
	base_cost = 85
	boon_path = /spell/targeted/projectile/dumbfire/fireball/tower
	category = DEITY_TREE_CONJURATION
	requirements = list(DEITY_TREE_CONJURATION = 3)

/datum/deity_item/boon/single_charge/force_portal
	name = "Force Portal"
	desc = "This spell allows a follower to summon a force portal. Anything that hits the portal gets sucked inside and is then thrown out when the portal explodes."
	base_cost = 45
	boon_path = /spell/aoe_turf/conjure/force_portal/tower
	category = DEITY_TREE_CONJURATION
	requirements = list(DEITY_TREE_CONJURATION = 3)

/datum/deity_item/phenomena/banishing_smite
	name = "Phenomena: Banishing Smite"
	desc = "Gain the ability to smite an individual, dealing damage to them. If they are weakened enough, this can cause them to temporarily be transported."
	base_cost = 75
	requirements = list(DEITY_TREE_CONJURATION = 3)
	category = DEITY_TREE_CONJURATION
	phenomena_path = /datum/phenomena/banishing_smite