/obj/item/weapon/archaeological_find
	name = "object"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano01"
	var/find_type = 0

/obj/item/weapon/archaeological_find/New(loc, var/new_item_type)
	if(new_item_type)
		find_type = new_item_type
	else
		find_type = rand(1, MAX_ARCHAEO)

	var/item_type = "object"
	icon_state = "unknown[rand(1,4)]"
	var/additional_desc = ""
	var/obj/item/weapon/new_item
	var/source_material = ""
	var/apply_material_decorations = 1
	var/apply_image_decorations = 0
	var/material_descriptor = ""
	var/apply_prefix = 1

	if(prob(40))
		material_descriptor = pick("rusted ","dusty ","archaic ","fragile ")
	source_material = pick("cordite","quadrinium",DEFAULT_WALL_MATERIAL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")

	var/talkative = 0
	if(prob(5))
		talkative = 1

	//for all items here:
	//icon_state
	//item_state
	switch(find_type)
		if(ARCHAEO_BOWL)
			item_type = "bowl"
			if(prob(33))
				new_item = new /obj/item/weapon/reagent_containers/glass/replenishing(src.loc)
			else
				new_item = new /obj/item/weapon/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "bowl"
			apply_image_decorations = 1
			if(prob(20))
				additional_desc = "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."
		if(ARCHAEO_URN)
			item_type = "urn"
			if(prob(33))
				new_item = new /obj/item/weapon/reagent_containers/glass/replenishing(src.loc)
			else
				new_item = new /obj/item/weapon/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "urn"
			apply_image_decorations = 1
			if(prob(20))
				additional_desc = "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."
		if(ARCHAEO_CUTLERY)
			item_type = "[pick("fork","spoon","knife")]"
			if(prob(25))
				new_item = new /obj/item/weapon/material/kitchen/utensil/fork(src.loc)
			else if(prob(50))
				new_item = new /obj/item/weapon/material/kitchen/utensil/knife(src.loc)
			else
				new_item = new /obj/item/weapon/material/kitchen/utensil/spoon(src.loc)
			additional_desc = "[pick("It's like no [item_type] you've ever seen before",\
			"It's a mystery how anyone is supposed to eat with this",\
			"You wonder what the creator's mouth was shaped like")]."
		if(ARCHAEO_STATUETTE)
			name = "statuette"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "statuette"
			icon_state = "statuette"
			additional_desc = "It depicts a [pick("small","ferocious","wild","pleasing","hulking")] \
			[pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")] \
			[pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")]."
			if(prob(25))
				new_item = new /obj/item/weapon/vampiric(src.loc)
		if(ARCHAEO_INSTRUMENT)
			name = "instrument"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "instrument"
			icon_state = "instrument"
			if(prob(30))
				apply_image_decorations = 1
				additional_desc = "[pick("You're not sure how anyone could have played this",\
				"You wonder how many mouths the creator had",\
				"You wonder what it sounds like",\
				"You wonder what kind of music was made with it")]."
		if(ARCHAEO_KNIFE)
			item_type = "[pick("bladed knife","serrated blade","sharp cutting implement")]"
			new_item = new /obj/item/weapon/material/knife(src.loc)
			additional_desc = "[pick("It doesn't look safe.",\
			"It looks wickedly jagged",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges")]."
		if(ARCHAEO_COIN)
			//assuming there are 10 types of coins
			var/chance = 10
			for(var/type in typesof(/obj/item/weapon/coin))
				if(prob(chance))
					new_item = new type(src.loc)
					break
				chance += 10

			item_type = new_item.name
			apply_prefix = 0
			apply_material_decorations = 0
			apply_image_decorations = 1
		if(ARCHAEO_HANDCUFFS)
			item_type = "handcuffs"
			new_item = new /obj/item/weapon/handcuffs(src.loc)
			additional_desc = "[pick("They appear to be for securing two things together","Looks kinky","Doesn't seem like a children's toy")]."
		if(ARCHAEO_BEARTRAP)
			item_type = "[pick("wicked","evil","byzantine","dangerous")] looking [pick("device","contraption","thing","trap")]"
			apply_prefix = 0
			new_item = new /obj/item/weapon/beartrap(src.loc)
			additional_desc = "[pick("It looks like it could take a limb off",\
			"Could be some kind of animal trap",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along part of it")]."
		if(ARCHAEO_LIGHTER)
			item_type = "[pick("cylinder","tank","chamber")]"
			new_item = new /obj/item/weapon/flame/lighter(src.loc)
			additional_desc = "There is a tiny device attached."
			if(prob(30))
				apply_image_decorations = 1
		if(ARCHAEO_BOX)
			item_type = "box"
			new_item = new /obj/item/weapon/storage/box(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "box"
			var/obj/item/weapon/storage/box/new_box = new_item
			new_box.max_w_class = pick(ITEM_SIZE_TINY,2;ITEM_SIZE_SMALL,3;ITEM_SIZE_NORMAL,4;ITEM_SIZE_LARGE)
			var/storage_amount = base_storage_cost(new_box.max_w_class)
			new_box.max_storage_space = rand(storage_amount, storage_amount * 10)
			if(prob(30))
				apply_image_decorations = 1
		if(ARCHAEO_GASTANK)
			item_type = "[pick("cylinder","tank","chamber")]"
			if(prob(25))
				new_item = new /obj/item/weapon/tank/air(src.loc)
			else if(prob(50))
				new_item = new /obj/item/weapon/tank/anesthetic(src.loc)
			else
				new_item = new /obj/item/weapon/tank/phoron(src.loc)
			icon_state = pick("oxygen","oxygen_fr","oxygen_f","phoron","anesthetic")
			additional_desc = "It [pick("gloops","sloshes")] slightly when you shake it."
		if(ARCHAEO_TOOL)
			item_type = "tool"
			if(prob(25))
				new_item = new /obj/item/weapon/wrench(src.loc)
			else if(prob(25))
				new_item = new /obj/item/weapon/crowbar(src.loc)
			else
				new_item = new /obj/item/weapon/screwdriver(src.loc)
			additional_desc = "[pick("It doesn't look safe.",\
			"You wonder what it was used for",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains on it")]."
		if(ARCHAEO_METAL)
			apply_material_decorations = 0
			var/list/possible_spawns = list()
			possible_spawns += /obj/item/stack/material/steel
			possible_spawns += /obj/item/stack/material/plasteel
			possible_spawns += /obj/item/stack/material/glass
			possible_spawns += /obj/item/stack/material/glass/reinforced
			possible_spawns += /obj/item/stack/material/phoron
			possible_spawns += /obj/item/stack/material/gold
			possible_spawns += /obj/item/stack/material/silver
			possible_spawns += /obj/item/stack/material/uranium
			possible_spawns += /obj/item/stack/material/sandstone
			possible_spawns += /obj/item/stack/material/silver

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
			new_item:amount = rand(5,45)
		if(ARCHAEO_PEN)
			if(prob(75))
				new_item = new /obj/item/weapon/pen(src.loc)
			else
				new_item = new /obj/item/weapon/pen/reagent/sleepy(src.loc)
			if(prob(30))
				apply_image_decorations = 1
		if(ARCHAEO_CRYSTAL)
			apply_prefix = 0
			if(prob(25))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "smooth green crystal"
				icon_state = "Green lump"
			else if(prob(33))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "irregular purple crystal"
				icon_state = "Phazon"
			else
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "rough red crystal"
				icon_state = "changerock"
			additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")

			apply_material_decorations = 0
			if(prob(10))
				apply_image_decorations = 1
			if(prob(25))
				new_item = new /obj/item/device/soulstone(src.loc)
				new_item.icon = 'icons/obj/xenoarchaeology.dmi'
				new_item.icon_state = icon_state
		if(ARCHAEO_CULTBLADE)
			//cultblade
			apply_prefix = 0
			new_item = new /obj/item/weapon/melee/cultblade(src.loc)
			apply_material_decorations = 0
			apply_image_decorations = 0
		if(ARCHAEO_TELEBEACON)
			new_item = new /obj/item/device/radio/beacon(src.loc)
			talkative = 0
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "unknown[rand(1,4)]"
			new_item.desc = ""
		if(ARCHAEO_CLAYMORE)
			apply_prefix = 0
			new_item = new /obj/item/weapon/material/sword(src.loc)
			new_item.force = 10
			item_type = new_item.name
		if(ARCHAEO_CULTROBES)
			//arcane clothing
			apply_prefix = 0
			var/list/possible_spawns = list(/obj/item/clothing/head/culthood,
			/obj/item/clothing/head/culthood/magus,
			/obj/item/clothing/head/culthood/alt,
			/obj/item/clothing/head/helmet/space/cult)

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
		if(ARCHAEO_SOULSTONE)
			//soulstone
			apply_prefix = 0
			new_item = new /obj/item/device/soulstone(src.loc)
			item_type = new_item.name
			apply_material_decorations = 0
		if(ARCHAEO_SHARD)
			if(prob(50))
				new_item = new /obj/item/weapon/material/shard(src.loc)
			else
				new_item = new /obj/item/weapon/material/shard/phoron(src.loc)
			apply_prefix = 0
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_RODS)
			apply_prefix = 0
			new_item = new /obj/item/stack/rods(loc)
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_STOCKPARTS)
			var/list/possible_spawns = typesof(/obj/item/weapon/stock_parts)
			possible_spawns -= /obj/item/weapon/stock_parts
			possible_spawns -= /obj/item/weapon/stock_parts/subspace

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
			item_type = new_item.name
			apply_material_decorations = 0
		if(ARCHAEO_KATANA)
			apply_prefix = 0
			new_item = new /obj/item/weapon/material/sword/katana(src.loc)
			new_item.force = 10
			item_type = new_item.name
		if(ARCHAEO_LASER)
			//energy gun
			var/spawn_type = pick(\
			/obj/item/weapon/gun/energy/laser/practice/xenoarch,\
			/obj/item/weapon/gun/energy/laser/xenoarch,\
			/obj/item/weapon/gun/energy/xray/xenoarch,\
			/obj/item/weapon/gun/energy/captain/xenoarch)
			if(spawn_type)
				var/obj/item/weapon/gun/energy/new_gun = new spawn_type(src.loc)
				new_item = new_gun
				new_item.icon_state = "egun[rand(1,6)]"
				new_gun.desc = "This is an antique energy weapon, you're not sure if it will fire or not."

				//10% chance to have an unchargeable cell
				//15% chance to gain a random amount of starting energy, otherwise start with an empty cell

				if(prob(10))
					new_gun.power_supply.maxcharge = 0
				if(prob(15))
					new_gun.power_supply.charge = rand(0, new_gun.power_supply.maxcharge)
				else
					new_gun.power_supply.charge = 0

			item_type = "gun"
		if(ARCHAEO_GUN)
			//revolver
			var/obj/item/weapon/gun/projectile/new_gun = new /obj/item/weapon/gun/projectile/revolver(src.loc)
			new_item = new_gun
			new_item.icon_state = "gun[rand(1,4)]"
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'

			//33% chance to be able to reload the gun with human ammunition
			if(prob(66))
				new_gun.caliber = "999"

			//33% chance to fill it with a random amount of bullets
			new_gun.max_shells = rand(1,12)
			new_gun.loaded.Cut()
			if(prob(33))
				var/num_bullets = rand(1, new_gun.max_shells)
				for(var/i = 1 to num_bullets)
					var/obj/item/ammo_casing/A = new new_gun.ammo_type(new_gun)
					new_gun.loaded += A
					if(A.caliber != new_gun.caliber)
						A.caliber = new_gun.caliber
						A.desc = "A bullet casing of unknown caliber."

			item_type = "gun"
		if(ARCHAEO_UNKNOWN)
			//completely unknown alien device
			if(prob(50))
				apply_image_decorations = 0
		if(ARCHAEO_FOSSIL)
			//fossil bone/skull
			//new_item = new /obj/item/weapon/fossil/base(src.loc)

			//the replacement item propogation isn't working, and it's messy code anyway so just do it here
			var/list/candidates = list(/obj/item/weapon/fossil/bone=9,/obj/item/weapon/fossil/skull=3,
			/obj/item/weapon/fossil/skull/horned=2)
			var/spawn_type = pickweight(candidates)
			new_item = new spawn_type(src.loc)

			apply_prefix = 0
			additional_desc = "A fossilised part of an alien, long dead."
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_SHELL)
			//fossil shell
			new_item = new /obj/item/weapon/fossil/shell(src.loc)
			apply_prefix = 0
			additional_desc = "A fossilised, pre-Stygian alien crustacean."
			apply_image_decorations = 0
			apply_material_decorations = 0
			if(prob(10))
				apply_image_decorations = 1
		if(ARCHAEO_PLANT)
			//fossil plant
			new_item = new /obj/item/weapon/fossil/plant(src.loc)
			item_type = new_item.name
			additional_desc = "A fossilised shred of alien plant matter."
			apply_image_decorations = 0
			apply_material_decorations = 0
			apply_prefix = 0
		if(ARCHAEO_REMAINS_HUMANOID)
			//humanoid remains
			apply_prefix = 0
			item_type = "humanoid [pick("remains","skeleton")]"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remains"
			additional_desc = pick("They appear almost human.",\
			"They are contorted in a most gruesome way.",\
			"They look almost peaceful.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"The mouth is wide open in a death rictus, the victim would appear to have died screaming.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_REMAINS_ROBOT)
			//robot remains
			apply_prefix = 0
			item_type = "[pick("mechanical","robotic","cyborg")] [pick("remains","chassis","debris")]"
			icon = 'icons/mob/robots.dmi'
			icon_state = "remainsrobot"
			additional_desc = pick("Almost mistakeable for the remains of a modern cyborg.",\
			"They are barely recognisable as anything other than a pile of waste metals.",\
			"It looks like the battered remains of an ancient robot chassis.",\
			"The chassis is rusting and old, but remarkably well preserved.",\
			"The chassis is scored by numerous burns and partially melted.",\
			"The chassis is battered and broken, in some cases only chunks of metal are left.",\
			"A pile of wires and crap metal that looks vaguely robotic.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_REMAINS_XENO)
			//xenos remains
			apply_prefix = 0
			item_type = "alien [pick("remains","skeleton")]"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remainsxeno"
			additional_desc = pick("It looks vaguely reptilian, but with more teeth.",\
			"They are faintly unsettling.",\
			"There is a faint aura of unease about them.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"This creature would have been twisted and monstrous when it was alive.",\
			"It doesn't look human.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(ARCHAEO_GASMASK)
			//gas mask
			if(prob(25))
				new_item = new /obj/item/clothing/mask/gas/poltergeist(src.loc)
			else
				new_item = new /obj/item/clothing/mask/gas(src.loc)
	var/decorations = ""
	if(apply_material_decorations)
		source_material = pick("cordite","quadrinium",DEFAULT_WALL_MATERIAL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")
		desc = "A [material_descriptor ? "[material_descriptor] " : ""][item_type] made of [source_material], all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality."

		var/list/descriptors = list()
		if(prob(30))
			descriptors.Add("is encrusted with [pick("","synthetic ","multi-faceted ","uncut ","sparkling ") + pick("rubies","emeralds","diamonds","opals","lapiz lazuli")]")
		if(prob(30))
			descriptors.Add("is studded with [pick("gold","silver","aluminium","titanium")]")
		if(prob(30))
			descriptors.Add("is encircled with bands of [pick("quadrinium","cordite","ferritic-alloy","plasteel","duranium")]")
		if(prob(30))
			descriptors.Add("menaces with spikes of [pick("solid phoron","uranium","white pearl","black steel")]")
		if(descriptors.len > 0)
			decorations = "It "
			for(var/index=1, index <= descriptors.len, index++)
				if(index > 1)
					if(index == descriptors.len)
						decorations += " and "
					else
						decorations += ", "
				decorations += descriptors[index]
			decorations += "."
		if(decorations)
			desc += " " + decorations

	var/engravings = ""
	if(apply_image_decorations)
		engravings = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] \
		[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
		[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
		[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
		if(prob(50))
			engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
		engravings += "."

		if(desc)
			desc += " "
		desc += engravings

	if(apply_prefix)
		name = "[pick("Strange","Ancient","Alien","")] [item_type]"
	else
		name = item_type

	if(desc)
		desc += " "
	desc += additional_desc
	if(!desc)
		desc = "This item is completely [pick("alien","bizarre")]."

	//icon and icon_state should have already been set
	if(new_item)
		new_item.name = name
		new_item.desc = src.desc

		if(talkative)
			new_item.talking_atom = new(new_item)

		qdel(src)

	else if(talkative)
		src.talking_atom = new(src)
