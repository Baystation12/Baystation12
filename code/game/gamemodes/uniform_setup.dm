var/list/uniform_list = list("Classic Red" = /obj/item/clothing/under/rank/security, "Corporate Black" = /obj/item/clothing/under/rank/security/corp, "Navy n' White" = /obj/item/clothing/under/rank/security/navyblue)

proc/PreInitUniforms()
	var/list/uniforms = uniform_list
	uniform_list.Cut()
	for(var/uniform in uniforms)
		uniform_list[uniforms[uniform]] = new uniform
proc/ConfigureUniforms()
	PreInitUniforms()
	uniform = pick(uniform_list)
	AnnounceUniforms()

proc/AnnounceUniforms()
	world << "<B><FONT COLOR=RED>The chosen security uniform for the round is [uniform]!"