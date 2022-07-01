// TODO:
[X] - Reset selection when no matches found - Wed Jun 15 18:52:27 2022 
[X] - Make candy's fall down like they are suffering from gravity
[X] - Make candy's animation at start
[X] - Add menu's for the game
[X] - Transitions added
[X] - Add UI for the game with timer, points and moves
  [X] - Add Points when swapping and make bigger points with bigger matches
    [X] - Points Added
    [X] - Increase Points after swap
    [X] - Bigger Points with bigger swaps
[X] - Add an movement limit and an score to reach for winning the level
  [X] - Score to reach.
    [X] - Score to reach logic
  [X] - Movement limit.
    [X] - Movement limit logic
[] - Make continuos matches
[] - Add sound to movement -- NOT WORKING
[] - Add Resource Loader


// BUG:
[X] - When make an swap, the second candy is being checked with empty type
[X] - When first selecting, candy in position 0 or (0,0) doesn't get picked.
[X] - Some Swapping data are being passed wrongly
[X] - Swapping with and empty candy that make a match, delete the match but the swapped candy appears at the last empty positionat the last empty position when updatingGravity
[] - Not getting all candys in a match, its because we are only looking one time for each perpendicular direction from candy inside the match
[X] - Glitch when updatingGravity
[X] - Not updating Gravity when going from one level to another sometimes
[X] - Transitions not pausing game state
