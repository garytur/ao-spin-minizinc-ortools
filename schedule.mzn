% 1. Parameters
int: num_players;                      % Number of players
int: num_games;                        % Number of games to schedule
int: num_time_slots;                   % Total number of time slots available

% 1a. Define the range of values that GAMES/PLAYERS can have
set of int: GAMES = 1..num_games;          % Set of games; each game will be represented by a number between 1 and num_games
set of int: PLAYERS = 1..num_players;      % Set of players; each player will be represented by a number between 1 and num_players

% 1b. Define which games are to be played, each game is 2-element entry in an array of length GAMES.
% This array gives the pair of players for each game.  
% Here, game 1 has players 1 and 2, game 2 has players 3 and 4, and game 3 has players 1 and 3.
array[GAMES, 1..2] of int: game_players; 

% 2. Decision variables
% Which game happens in which time slot? Solver will figure out what this array looks like (note the "var" keyword).
array[GAMES] of var 1..num_time_slots: game_start_times; % Start time for each game

% 3. Constraints
% Constraint: No player should play two games simultaneously
constraint
    forall(g1, g2 in GAMES where g1 < g2) (
        let {set of int: common_players = {game_players[g1, 1], game_players[g1, 2]} intersect {game_players[g2, 1], game_players[g2, 2]}} in
        if card(common_players) > 0 then
            game_start_times[g1] != game_start_times[g2]
        else
            true
        endif
    );

% 3a. Objective
% Objective (optional): minimize the latest time slot used
var 1..num_time_slots: makespan;
constraint makespan = max([game_start_times[g] | g in GAMES]);

% 4. Solution mode
solve minimize makespan;

% 5. Output
output [ "Game \(g): starts at slot \(game_start_times[g]) with players \(game_players[g, 1]) and \(game_players[g, 2]) \n" | g in GAMES];

