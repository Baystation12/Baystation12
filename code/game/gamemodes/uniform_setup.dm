var/list/uniform_list = list("Classic Red" = /obj/item/clothing/under/rank/security, "Corporate Black" = /obj/item/clothing/under/rank/security/corp, "Navy n' White" = /obj/item/clothing/under/rank/security/navyblue)


proc/ConfigureUniforms()
	uniform = pick(uniform_list)
	var/new_uniform = uniform_list[uniform]
	uniform = new new_uniform
	uniform_name = uniform
	AnnounceUniforms()

proc/AnnounceUniforms()
	world << "<B><FONT COLOR=RED>The chosen security uniform for the round is \icon[uniform] [uniform_name]!</B></FONT>"