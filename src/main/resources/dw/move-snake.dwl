%dw 2.0
output application/json

type Coordinates = {
	x:number,
	y:number
}

type Moves = "up" | "down" | "right" | "left"

fun getCoordinates(initial:Coordinates,direction:Moves) =
direction match {
	case "down" -> {
		x: initial.x,
		y: initial.y - 1
	}
	case "up" -> {
		x: initial.x,
		y: initial.y + 1
	}
	case "left" -> {
		x: initial.x - 1,
		y: initial.y
	}
	case "right" -> {
		x: initial.x + 1,
		y: initial.y
	}
	else -> initial
}

var body = payload.you.body
var board = payload.board
var head = body[0] // First body part is always head
var neck = body[1] // Second body part is always neck

var moves = ["up", "down", "left", "right"]

// Step 0: Find my neck location so I don't eat myself
var myNeckLocation = neck match {
	case neck if neck.x < head.x -> "left" //my neck is on the left of my head
	case neck if neck.x > head.x -> "right" //my neck is on the right of my head
	case neck if neck.y < head.y -> "down" //my neck is below my head
	case neck if neck.y > head.y -> "up"	//my neck is above my head
	else -> ''
}

// TODO: Step 1 - Don't hit walls.
var wallPositionX = head match{
	case head if head.x == 0 -> "left"
	case head if head.x == board.width -> "right"
	else -> ''
}

var wallPositionY = head match{
	case head if head.y == 0 -> "down"
	case head if head.y == board.height -> "up"
	else -> ''
}

// Step 2: Don't hit yourself

var avoidSelf = moves map (move) -> do{
	var newCoordinate = getCoordinates(head,move)
	---
	if (body contains newCoordinate)
		move
	else ""
}

// TODO: Step 3 - Don't collide with others.
// Use information from `payload` to prevent your Battlesnake from colliding with others.

// TODO: Step 4 - Find food.
// Use information in `payload` to seek out and find food.
// food = board.food


// Find safe moves by eliminating neck location and any other locations computed in above steps
var safeMoves = moves - myNeckLocation - wallPositionX - wallPositionY // - remove other dangerous locations

// Next random move from safe moves
var nextMove = safeMoves[randomInt(sizeOf(safeMoves))]

---
{
	move: nextMove,
	shout: "Moving $(nextMove)"
}