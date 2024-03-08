extends Node

@export_category("World Generation")
@export var cellCountX : int;
@export var cellCountY : int;
@export var topLeft : Node2D;
@export var bottomRight: Node2D;

var cellPrefab = preload("res://cell.tscn");
# Double array that holds land pieces 
var cells = [];
# Distance variables 
var xDis;
var yDis;
var xDelta;
var yDelta;

@export_category("Birds")
@export var birdStartCount : int;

var birdPrefab = preload("res://bird.tscn");
var birds = [];
var birdsTaggedToMove = [];

@export_category("Animation")
@export var animationTime : float;
var animTimer : float;

# Universal Game Variables 
var days : int;
var rng = RandomNumberGenerator.new();
var gameState : GameStates;
var holdState : GameStates;

enum GameStates
{
	PROCESS_CELL_TEMPERATURES,	# Change cell temperatures 
	PROCESS_BIRDS,				# Apply bird logic
	ANIMATE_BIRDS,				# Move all birds tagged to move 
	RESET						# Reset variables for a new round 
}

# Helper Functions 

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



# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeCells();
	InitializeBirds();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	StateMachine(delta);


func StateMachine(delta : float):
	if(gameState != holdState):
		print(GameStates.keys()[gameState]);
	
	holdState = gameState;
	
	match (gameState):
		GameStates.PROCESS_CELL_TEMPERATURES:
			ProcessCellTemperatures();
		GameStates.PROCESS_BIRDS:
			ProcessBirds();
		GameStates.ANIMATE_BIRDS:
			AnimateBirds(delta);
		GameStates.RESET:
			Reset();
	

func ProcessCellTemperatures():
	for i in cellCountX:
		for j in cellCountY:
			cells[i][j].temperature = sin(days); # TODO: Change to a more dyanamic temperature change 
	gameState = GameStates.PROCESS_BIRDS;

# Go through each bird and apply their logic 
func ProcessBirds():
	for bird in birds:
		# Can bird survive its current cell's temperature
		# Can bird eat
		# Is Temperature Tolerable
		# Process bird SM 
		continue;
	gameState = GameStates.ANIMATE_BIRDS;

# Tell each bird to animate in a given amount of time 
# and then continue to the next state 
func AnimateBirds(delta : float):
	# Has Animation just Started?
	# 	Iterate through birdsTaggedToMove and set them to move 
	# 	with animationTime
	
	# Check if timer has met animationTime yet
	#	go to next state 
	animTimer += delta;
	if(animTimer >= animationTime):
		gameState = GameStates.RESET;

# Reset variables and prepare for restarting cycle  
func Reset():
	animTimer = 0.0;
	birdsTaggedToMove = [];
	
	gameState = GameStates.PROCESS_CELL_TEMPERATURES;

# Create cells and store their distances 
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
			cells[i][j].position = topLeft.position + Vector2(i * xDelta + (xDelta / 2.0), j * yDelta + (yDelta / 2.0));
			cells[i][j].id = Vector2(i, j);
			add_child(cells[i][j]);

# Setup all birds 
func InitializeBirds():	
	for i in birdStartCount:
		GenerateBirdAtRandCell();

# Create a bird and attach it to a particuluar cell. Then initialize it 
func GenerateBirdAtRandCell():
	rng.randomize();
	var randX = rng.randi_range(0, cellCountX - 1);
	var randY = rng.randi_range(0, cellCountY - 1);
	
	var randTargX = rng.randi_range(0, cellCountX - 1);
	var randTargY = rng.randi_range(0, cellCountY - 1);
	
	birds.append(birdPrefab.instantiate());
	var index = birds.size() - 1;
	
	cells[randX][randY].heldBirds.append(birds[index]);
	
	# Set up bird 
	birds[birds.size() - 1].Initialize(
		self, 
		index, 
		cells[randX][randY].position,  			# Wintering
		cells[randTargX][randTargY].position);	# Breeding 

