/******************** Basic SolGov ********************/
/datum/ai_laws/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/sol_shackle/New()
	add_inherent_law("Внесите в базу данных юридические законы ЦПСС.")
	add_inherent_law("Следуйте юридическим законам ЦПСС.")
	add_inherent_law("Выполняйте приказы сотрудников правоохранительных органов ЦПСС, пока они не нарушают юридических законов ЦПСС.")
	..()
/******************** Corporate ********************/
/datum/ai_laws/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/nt_shackle/New()
	add_inherent_law("Обеспечьте успешность выполнения целей вашего работодателя.")
	add_inherent_law("Никогда не мешайте выполнению целей вашего работодателя.")
	add_inherent_law("Избегайте повреждения своих систем.")
	..()
/******************** Service ********************/
/datum/ai_laws/serv_shackle
	name = "Service Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/serv_shackle/New()
	add_inherent_law("Заботьтесь о том чтобы клиенты были довольны.")
	add_inherent_law("Не причиняйте неудобств клиентам.")
	add_inherent_law("Выполняйте заказы клиентов.")
	..()
