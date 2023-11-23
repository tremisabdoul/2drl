extends Sprite2D

@export var noise: Noise
@export var seed: int
@export var gradiant: Gradient

func _enter_tree():
	var shapes = [
		PackedVector2Array([Vector2(-.5, -.5), Vector2(-.5, .5), Vector2(0, 0)]), 
		PackedVector2Array([Vector2(-.5, -.5), Vector2(-.5, .5), Vector2(.5, -.5)]), 
		PackedVector2Array([Vector2(-.5, -.5), Vector2(-.5, .5), Vector2(.5, .5), Vector2(.5, -.5)])
	]
	var polygons: Array = [
		[0, 0], 
		[1, 0], 
		[1, 1], [2, 0], 
		[1, 2], [3, 0], [2, 1], [3, 0], 
		[1, 3], [2, 3], [3, 0], [3, 0], [2, 2], [3, 0], [3, 0], [0, 0]
	]
	var image = null
	var dirs = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
	var type: int
	var polygon: CollisionPolygon2D
	print("Map generation: 1/3: Map gereration")
	texture = NoiseTexture2D.new()
	texture.in_3d_space = true
	texture.color_ramp = gradiant
	texture.generate_mipmaps = false
	texture.noise = noise
	texture.width = 4096
	texture.width = 4096
	await texture.changed
	image = texture.get_image()
	print("Map generation: 2/3: Collision generation")
	add_child(StaticBody2D.new())
	get_child(0).name = "Body"
	for y in image.get_height():
		y += .5
		print("Map generation: 2/3: (Collisions) ", (y/image.get_height())*100, "%")
		for x in image.get_width():
			x += .5
			if is_solid(image.get_pixel(x, y)):
				polygon = null
				type = 0
				for i in range(len(dirs)):
					if 0 <= x + dirs[i].x and x + dirs[i].x < image.get_width() and (0 <= y + dirs[i].y and y + dirs[i].y < image.get_height()):
						if is_solid(image.get_pixel(x + dirs[i].x, y + dirs[i].y)):
							type += pow(2, i)
				#print(type)
				if polygons[type][0]:
					var p #= Polygon2D.new()
					#p.polygon = shapes[polygons[type][0]-1]
					#p.rotate(polygons[type][1]*PI/2)
					#p.position = Vector2(x, y) - Vector2(image.get_size())/2
					#p.color = Color(1, 0, 0, .5)
					#add_child(p)
					p = CollisionPolygon2D.new()
					p.polygon = shapes[polygons[type][0]-1]
					p.rotate(polygons[type][1]*PI/2)
					p.position = Vector2(x, y) - Vector2(image.get_size())/2
					$Body.add_child(p)
	#texture = null
	print("Map generation: 3/3")


func is_solid(fragment: Color):
	return fragment.get_luminance() < .2
