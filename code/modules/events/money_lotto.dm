/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(prob(50))
		if(all_money_accounts.len)
			var/datum/money_account/D = pick(all_money_accounts)
			winner_name = D.owner_name

			deposit_success = D.deposit(winner_sum, "Nyx Daily Loan Lottery winner!", "Biesel TCD Terminal #[rand(111,333)]")
	else
		winner_name = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
		deposit_success = pick(0,1)

/datum/event/money_lotto/announce()
	var/author = "[GLOB.using_map.company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate <b>[winner_name]</b> for recieving the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] [GLOB.using_map.local_currency_name]!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. In order to have your winnings re-sent, send a cheque containing a processing fee of 5000 [GLOB.using_map.local_currency_name] to the ND 'Stellar Slam' office on the Nyx gateway with your updated details."

	news_network.SubmitArticle(body, author, channel, null, 1)
