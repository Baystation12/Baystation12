/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(20, 100, 150, 200)
	if(prob(50))
		if(all_money_accounts.len)
			var/datum/money_account/D = pick(all_money_accounts)
			winner_name = D.owner_name
			if(!D.suspended)
				var/datum/transaction/T = new("Nyx Daily Loan Lottery", "Winner!", winner_sum, "Biesel TCD Terminal #[rand(111,333)]")
				D.do_transaction(T)
				deposit_success = 1

	else
		winner_name = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
		deposit_success = pick(0,1)

/datum/event/money_lotto/announce()
	var/author = "[GLOB.using_map.company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate <b>[winner_name]</b> for winning the Nyx Daily Loan Lottery, and receiving the amazing sum of [winner_sum] Thalers!"
	
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. In order to have your winnings re-sent, send a cheque containing a processing fee of 100 Thalers to the ND Finance office on the Nyx gateway with your updated details."
	else
		body += "<br>Their loan has been set up with an AMAZING interest rate of only 10% per month. If you want to get one of the galaxy's best consumer finance loans, contact us at finance@nyxdaily.com!"

	news_network.SubmitArticle(body, author, channel, null, 1)
