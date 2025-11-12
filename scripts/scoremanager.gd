extends Node

var score: int = 0
signal score_changed(new_score)
				# Scoremanager is the global function for the scoring system, which is created so that we can call it wherever we want
func add_points(points_value: int):
	score += points_value
# Here we add the "score" to the counter, which is actually in this case 1p for each as it counts the total mushrooms.
	emit_signal("score_changed", score)
	print("Score:", score)


# Functions for poisonous counter, which will be used in the end screen.
var poisonous_count: int = 0
signal pcount_changed(new_pcount)

func add_pcount(poisonous: int):
	poisonous_count += poisonous
	emit_signal("pcount_changed", poisonous_count)
	print("Poisonous:", poisonous_count)


# Functions for edible counter, which will be used in the end screen.
var edible_count: int = 0
signal ecount_changed(new_ecount)

func add_ecount(edible: int):
	edible_count += edible
	emit_signal("ecount_changed", edible_count)
	print("Edible:", edible_count)


# Just resets the counter to 0 as default when starting the game
func reset_score():
	score = 0
	emit_signal("score_changed", score)
