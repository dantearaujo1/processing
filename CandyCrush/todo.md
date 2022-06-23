// TODO:
[X] - Reset selection when no matches found - Wed Jun 15 18:52:27 2022 
[X] - Make candy's fall down like they are suffering from gravity
[X] - Make candy's animation at start
[] - Make continuos matches
[] - Add sound to movement
[X] - Add menu's for the game
[X] - Transitions added
[] - Add UI for the game with timer, points and moves
  [] - Add Timer bar
  [] - Add Points when swapping and make bigger points with bigger matches
  [] - Add an movement limit and an score to reach for winning the level


// BUG:
[X] - When make an swap, the second candy is being checked with empty type
[X] - When first selecting, candy in position 0 or (0,0) doesn't get picked.
[X] - Some Swapping data are being passed wrongly
[] - Swapping with and empty candy that make a match, delete the match but the swapped candy appears at the last empty positionat the last empty position when updatingGravity
[] - Not getting all candys in a match, its like we are only looking one time for each perpendicular direction from the match
[] - Transitions not pausing game state
