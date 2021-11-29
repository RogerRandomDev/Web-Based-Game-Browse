extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prior_downloaded = 0
var downloading = false
func download(target,url):
	prior_downloaded = get_downloaded_bytes()
	get_parent().get_node("download&play/ProgressBar").value = 0
	if downloading:return
	download_file = target
	downloading = true
# warning-ignore:return_value_discarded
	request(url)
# warning-ignore:unused_argument
func _physics_process(delta):
	if !downloading:return
# warning-ignore:integer_division
	var cur_progress = ((get_downloaded_bytes()-prior_downloaded)*1000)/max(get_body_size(),1)
	get_parent().get_node("download&play/ProgressBar").value = cur_progress/10
	if get_body_size() == 0:
		downloading = false
		get_parent().check_games(get_parent().get_node("Name").text)
