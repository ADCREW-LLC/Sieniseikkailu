extends Label

func _ready():
	Scoremanager.score_changed.connect(_on_score_changed)		# basically calls the Scoremanager's values to the label
	text = "%d /10" % Scoremanager.score #text for the label (%d means the changing value)

func _on_score_changed(new_score):		# updates score according to Scoremanager
	text = "%d / 10" % new_score  #text for the label (%d means the changing value)
