/obj/item/implant/processing/mobspawner/spider
	name = "spider beacon implant"
	desc = "An implant with small spiders etched along the metal."
	base_mob_type = /mob/living/simple_animal/hostile/giant_spider
	wait_time = 180 SECONDS
	wait_variation = 60 SECONDS
	mob_limit = 2

/obj/item/implant/processing/mobspawner/get_mob_type()
	return pickweight(GLOB.implant_spider_castes)

/obj/item/implant/processing/mobspawner/spider/get_data()
	return ..() + "This implant materializes creatures of the <b>large spider</b> family.<br>"

/obj/item/implant/processing/mobspawner/spider/phase_in_anim(mob/mob)
	mob.SpinAnimation(4,1)

/obj/item/implanter/mobspawner/spider
	name = "implanter (SPIDER)"
	imp = /obj/item/implant/processing/mobspawner/spider
