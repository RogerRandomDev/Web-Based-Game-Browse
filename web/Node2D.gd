extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var images = []
const os_names = ["Windows"]
# Called when the node enters the scene tree for the first time.
func _ready():
	prepare_files()
	if !os_names.has(OS.get_name()):get_tree().quit()
	var http0 = HTTPRequest.new()
	add_child(http0)
	http0.connect("request_completed",self,'store_images')
	http0.request('https://rogerrandomdev.github.io/Library/images/')
	yield(http0,"request_completed")
	http0.queue_free()
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_on_request_completed")
	http.request('https://rogerrandomdev.github.io/Library/game_list.txt')
	yield(http,"request_completed")
	http.queue_free()


var returned = ''
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_request_completed(result, response_code, headers, body):
	var output = str2var(body.get_string_from_utf8())
	for item in output.size():
		var http0 = HTTPRequest.new()
		add_child(http0)
		http0.connect("request_completed",self,'store_images')
		http0.request('https://rogerrandomdev.github.io/Library/images/'+output[item].replace(' ','_').replace('-','_')+".png")
		yield(http0,"request_completed")
		http0.queue_free()
	
	for item in output.size():
		var img = Sprite.new()
		img.texture = images[item]
		var lab = Label.new()
		lab.text = output[item]
		img.scale = Vector2(64/img.texture.get_width(),64/img.texture.get_height())
		lab.add_child(img)
		lab.align = lab.ALIGN_CENTER
		lab.rect_min_size = Vector2(128,32)
		lab.rect_size = Vector2(64,32)
		img.position = Vector2(64,64)
		var button = Button.new()
		button.rect_size = Vector2(128,80)
		lab.add_child(button)
		button.modulate = Color(0,0,0,0)
		button.connect("pressed",self,"swap_menu",[item])
		$item_holder.add_child(lab)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func store_images(result, response_code, headers, body):
	var image = Image.new()
	if len(body) >= 8000:return
	image.load_png_from_buffer(body)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.set_flags(2)
	images.append(texture)
	
func swap_menu(menu):
	var http0 = HTTPRequest.new()
	add_child(http0)
	http0.connect("request_completed",self,'_open_desc')
	http0.request('https://rogerrandomdev.github.io/Library/descriptions/'+$item_holder.get_child(menu).text.replace(' ','_').replace('-','_')+".txt")
	yield(http0,"request_completed")
	http0.queue_free()
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _open_desc(result, response_code, headers, body):
	var output = str2var(body.get_string_from_utf8())
	$Name.text = output.replace('[','').replace(']','').split(',')[0].replace("'",'')
	$Description.text = output.replace('[','').replace(']','').split(',')[1].replace("'",'').replace('\\n','\n')
func prepare_files():
	var dir = Directory.new()
	if !dir.dir_exists("user://RR_GAMES"):
		dir.make_dir_recursive('user://RR_GAMES')
	#needs to get the files inside, so it knows the already-owned games.
	
