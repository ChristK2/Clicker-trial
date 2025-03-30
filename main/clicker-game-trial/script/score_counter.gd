extends Node

var coin_made = 0
@onready var money_counter: Label = $MoneyCounter


func add_money():
	coin_made += 1
	money_counter.text = "Amount of money: " + str(coin_made)
	
