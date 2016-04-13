module Main (..) where
import Time
-- import Keyboard
import Graphics.Collage
import Graphics.Element
import Color
import Random
-- import Window

type Direction = Up | Down | Left | Right

type alias Position = (Int, Int)

type alias Snake =
  {
    headX : Float
  , headY : Float
  , width : Float
  , height : Float
  }

type alias Input =
  {
    direction: Direction
  , delta : Time.Time
  }

--- CONSTANTS
columns : Float
columns    = 50.0
rows : Float
rows       = 25.0
initSeed : Random.Seed
initSeed   = Random.initialSeed 12345123

width : Snake -> Float
width(snake) = snake.width * columns

height : Snake -> Float
height(snake) = snake.height * rows


toCoord : Snake -> (Float, Float)
toCoord (snake) = (snake.width/2 + (snake.headX - (columns/2)) * snake.width,
                  snake.width/2 + (snake.headY - (rows   /2)) * snake.width)

displaySnake : Snake -> Graphics.Collage.Form
displaySnake(snake) =
    let style = { color = Color.white
                , width = snake.width
                , cap   = Graphics.Collage.Flat
                , join  = Graphics.Collage.Sharp 10
                , dashOffset = 0
                , dashing    = [] }
    in
      Graphics.Collage.traced style (Graphics.Collage.path (List.map toCoord [snake]))


--- MAIN

delta : Signal Time.Time
delta = Time.fps 9

display : (Int, Int) -> Graphics.Element.Element
display (w, h) =
    Graphics.Element.container w h
                              Graphics.Element.middle
    <| Graphics.Collage.collage w h
                [displaySnake {headX = 10.0, headY = 10.0, width= 10.0, height= 10.0}]

-- input : Signal Input
-- input = Signal.sampleOn delta (Signal.map2 Input Up delta)

-- gameState : Signal Game
-- gameState = Signal.foldp stepGame initGame input
main : Graphics.Element.Element
main = display(100,100)
