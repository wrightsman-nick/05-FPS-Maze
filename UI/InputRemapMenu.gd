extends Control

func _on_Quit_pressed():
	Global.save_input()
	get_tree().quit()
