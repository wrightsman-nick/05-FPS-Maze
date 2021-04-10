extends Spatial

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

onready var MiniMap = get_node("/root/Game/UI/VP/Map_Container/MiniMap")

var map = []
var tiles = [
	load("res://Maze/Tile00.tscn")
	,load("res://Maze/Tile01.tscn")
	,load("res://Maze/Tile02.tscn")
	,load("res://Maze/Tile03.tscn")
	,load("res://Maze/Tile04.tscn")
	,load("res://Maze/Tile05.tscn")
	,load("res://Maze/Tile06.tscn")
	,load("res://Maze/Tile07.tscn")
	,load("res://Maze/Tile08.tscn")
	,load("res://Maze/Tile09.tscn")
	,load("res://Maze/Tile10.tscn")
	,load("res://Maze/Tile11.tscn")
	,load("res://Maze/Tile12.tscn")
	,load("res://Maze/Tile13.tscn")
	,load("res://Maze/Tile14.tscn")
	,load("res://Maze/Tile15.tscn")
]

var mini_tiles = [
	load("res://MiniMap/Tile00.tscn")
	,load("res://MiniMap/Tile01.tscn")
	,load("res://MiniMap/Tile02.tscn")
	,load("res://MiniMap/Tile03.tscn")
	,load("res://MiniMap/Tile04.tscn")
	,load("res://MiniMap/Tile05.tscn")
	,load("res://MiniMap/Tile06.tscn")
	,load("res://MiniMap/Tile07.tscn")
	,load("res://MiniMap/Tile08.tscn")
	,load("res://MiniMap/Tile09.tscn")
	,load("res://MiniMap/Tile10.tscn")
	,load("res://MiniMap/Tile11.tscn")
	,load("res://MiniMap/Tile12.tscn")
	,load("res://MiniMap/Tile13.tscn")
	,load("res://MiniMap/Tile14.tscn")
	,load("res://MiniMap/Tile15.tscn")
]


var tile = 2  # tile size (in meters)
var mini_tile = 64  # tile size (in pixels)
var width = 20  # width of map (in tiles)
var height = 10  # height of map (in tiles)
var tile_size = Vector2.ZERO

onready var Key = preload("res://Key/key.tscn")
onready var Exit = preload("res://Exit/Exit.tscn")

func _ready():
	randomize()
	tile_size = Vector2(tile,tile)
	make_maze()
	var key = Key.instance()
	key.translate(Vector3((width*tile)-1.5,1,0.5))
	add_child(key)
	print(key.global_transform.origin)
	var exit = Exit.instance()
	exit.translate(Vector3((width*tile)-1.5,0.1,(height*tile)-1.5))
	add_child(exit)
	print(exit.global_transform.origin)
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	for x in range(width):
		for z in range(height):
			var t = tiles[map[x][z]].instance()
			t.translate(Vector3(x,0,z)*tile)
			t.name = "Tile_" + str(x) + "_" + str(z)
			add_child(t)
			var t2 = mini_tiles[map[x][z]].instance()
			t2.position = Vector2(x,z)*mini_tile
			t2.name = "MTile_" + str(x) + "_" + str(z)
			MiniMap.add_child(t2)
