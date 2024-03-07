extends Node

@export var cellCountX : int;
@export var cellCountY : int;
@export var topLeft : Node2D;
@export var bottomRight: Node2D;

var cellPrefab = preload("res://cell.tscn");

var cells = [];

# Distance variables 
var xDis;
var yDis;
var xDelta;
var yDelta;

# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeCells();
	print(GetClosestCell(Vector2(0, 0)));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func InitializeCells():
	xDis = bottomRight.position.x - topLeft.position.x;
	yDis = bottomRight.position.y - topLeft.position.y;
	
	xDelta = xDis / cellCountX;
	yDelta = yDis / cellCountY;
	
	for i in cellCountX:
		cells.append([])
		for j in cellCountY:
			cells[i].append([]);
			cells[i][j] = cellPrefab.instantiate();
			cells[i][j].position = topLeft.position + Vector2(i * xDelta + (xDelta / 2.0), j * yDelta+ (yDelta / 2.0));
			cells[i][j].id = Vector2(i, j);
			add_child(cells[i][j]);

func GetClosestCell(pos : Vector2):
	# Get percent along each axis after adding half deltas 
	var adjustedPos = pos - topLeft.position + Vector2(xDelta / 2.0, yDelta / 2.0);
	var xPercent = adjustedPos.x / xDis;
	var yPercent = adjustedPos.y / yDis;
	
	# Multiple percent by cell counts 
	var cellUncleanedX = xPercent * cellCountX;
	var cellUncleanedY = yPercent * cellCountY;
	
	# Round down to integer 
	var cellX = floori(cellUncleanedX);
	var cellY = floori(cellUncleanedY);
	
	# Pass values into cells after making sure in range 
	if(cellX >= 0 && cellX < cellCountX && cellY >= 0 && cellY< cellCountY):
		return cells[cellX][cellY];
	
	return null;
