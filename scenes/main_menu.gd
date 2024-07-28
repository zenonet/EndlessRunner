extends Control


func _on_play_button_pressed():
	GameManager.start_game()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	$AboutPanel.visible = false


func _on_about_button_pressed():
	$AboutPanel.visible = true
