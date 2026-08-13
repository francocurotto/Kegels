extends Control

func _ready() -> void:
	%Gym.train_started.connect(on_train_started)
	%Gym.train_ended.connect(on_train_ended)

func on_train_started():
	for i in $TabContainer.get_tab_count():
		$TabContainer.set_tab_disabled(i, true)

func on_train_ended():
	for i in $TabContainer.get_tab_count():
		$TabContainer.set_tab_disabled(i, false)
