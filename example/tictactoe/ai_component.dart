part of tictactoe;


class AIComponent extends PlayerComponent {

    static final Random rand = new Random();

    final double _P_SIDE = 0.5;
    final double _P_CORNER = 0.4;
    final double _P_MIDDLE = 0.1;

    void _gameStarted() {

    }

    Future<Position> _pickMove(Player player, Board board) {

        return new Future<Position>.delayed(new Duration(), () {
            final int rows = board.rows;
            final int cols = board.cols;

            // ai logic
            /*
             *
             * for each position p
             *  if winning(p)
             *      place(p)
             *      done
             *  if cornered(p)
             *      place(p)
             *      done
             *
             * // start strategic offensive
             *
             */

            // check for winning positions
            Position p = this._checkWinningMoves(player, board);
            if (null != p) {
                return p;
            }

            // check if we need to move defensively
            p = this._checkDefensiveMoves(player, board);
            if (null != p) {
                return p;
            }



            ////
            // find a strategic play

            // if there are no moves on the board, pick a starting move
            if (board.isEmpty) {
                // Randomly pick between side, corner, or middle
                return this._pickRandomFirstMove(player, board);
            }

            if (board.numOccupied == 1) {

            }

            // This is not the first move.  Determine how many pieces are on
            // the board, and pick a strategy from there
            if (board.numOccupied == 2) {
                // pick an offensive or defensive strategy
                if (rand.nextDouble() < 0.5) {
                    return this._pickOffensiveMove(player, board);
                } else {
                    return this._pickDefensiveMove(player, board);
                }
            }

            if (board.numOccupied == 3) {

            }

            throw new Exception("No available spots");
        });
    }

    /**
     * Check to see if we can win this turn
     */
    Position _checkWinningMoves(Player player, Board board) {

        for (int r = 0; r < board.numRows; r++) {
            for (int c = 0; c < board.numCols; c++) {
                Position p = new Position(r, c);
                if (board.getAt(p) != null) continue;
                if (this._winning(p, board, player)) {
                    return p;
                }
            }
        }
        return null;
    }

    /**
     * Check to see if there are any immediate defensive moves we need to make
     * i.e. opponent will win if we don't move here
     */
    Position _checkDefensiveMoves(Player player, Board board) {

        for (Player opponent in board.players) {
            for (int r = 0; r < board.numRows; r++) {
                for (int c = 0; c < board.numCols; c++) {
                    Position p = new Position(r, c);
                    if (board.getAt(p) != null) continue;
                    if (this._winning(p, board, opponent)) {
                        return p;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Determine if moving to a given position will win the game for the
     * given player.
     */
    bool _winning(Position p, Board b, Player player) {

        /*
         * Winning positions:
         * X WiX    X . .   X . .
         * . . .    . Wi.   Wi. .
         * . . .    . . X   X . .
         *
         * The strategy is to construct a list of players at the row, col, and
         * each diagonal passing through point p.  These lists are passed into
         * _checkLine, which returns true iff the given player is the only
         * element of each list.
         */

        // check the column
        List<Player> colPlayers = new List<Player>.generate(b.numRows, (r) {
            Position rowPos = new Position(r, p.col);
            if (p == rowPos) {
                return player;
            }
            return b.getAt(rowPos);
        });
        if (this._checkLine(colPlayers, player)) {
            return true;
        }


        // check the row
        List<Player> rowPlayers = new List<Player>.generate(b.numCols, (c) {
            Position colPos = new Position(p.row, c);
            if (p == colPos) {
                return player;
            }
            return b.getAt(colPos);
        });
        if (this._checkLine(rowPlayers, player)) {
            return true;
        }


        // check the first diagonal
        List<Player> diag1Players =
                new List<Player>.generate(min(b.numRows, b.numCols), (_p) {
            Position pos = new Position(_p, _p);
            if (p == pos) {
                return player;
            }
            return b.getAt(pos);
        });
        if (this._checkLine(diag1Players, player)) {
            return true;
        }


        // check the second diagonal
        List<Player> diag2Players =
                new List<Player>.generate(min(b.numRows, b.numCols), (_p) {
            Position pos;
            if (b.numRows < b.numCols) {
                pos = new Position(b.numRows - 1 - _p, _p);
            } else {
                pos = new Position(_p, b.numCols - 1 - _p);
            }
            if (p == pos) {
                return player;
            }
            return b.getAt(pos);
        });
        if (this._checkLine(diag2Players, player)) {
            return true;
        }

        return false;
    }

    bool _checkLine(Iterable<Player> players, Player curPlayer) {
        for (Player p in players) {
            if (p != curPlayer) {
                return false;
            }
        }
        return true;
    }

    /**
     * Assumes there are no pieces on the board.  Choose a starting move
     * semi-intelligently.
     */
    Position _pickRandomFirstMove(Player player, Board board) {

        int row = 0;
        int col = 0;

        double n = rand.nextDouble();

        if (n < _P_SIDE) {
            // If we choose a side, pick which side
            n = rand.nextDouble();
            if (n < 0.25) {
                return new Position(0, board.numCols ~/ 2);
            } else if (n < 0.5) {
                return new Position(board.numRows ~/ 2, board.numCols - 1);
            } else if (n < 0.75) {
                return new Position(board.numRows - 1, board.numCols ~/ 2);
            } else {
                return new Position(board.numRows ~/ 2, 0);
            }

        } else if (n < _P_SIDE + _P_CORNER) {
            // if we choose a corner, pick which corner
            n = rand.nextDouble();
            if (n < 0.25) {
                return new Position(0, 0);
            } else if (n < 0.5) {
                return new Position(0, board.numCols - 1);
            } else if (n < 0.75) {
                return new Position(board.numRows - 1, board.numCols - 1);
            } else {
                return new Position(board.numRows - 1, 0);
            }

        } else { // if (r < _P_SIDE + _P_CORNER + _P_MIDDLE) should add up to 1
            // Return the middle position
            return new Position(board.numRows ~/ 2, board.numCols ~/ 2);
        }

        return null;
    }

    /*  MOVE 3
     *
     * Pick either an offensive move or a defensive move.
     *
     * Offensive moves will immediately open up a winning move for the current
     * player, but the expectation is that an opponent will block it next turn.
     *
     * Defensive moves do not immediately open up a winning move for the player.
     *
     * Both functions _pickOffensiveMove and _pickDefensiveMove assume that
     * the board count is exactly 2.
     */

    /**
     *
     */
    Position _pickOffensiveMove(Player player, Board board) {

        // where did we move last turn?
        Position p = board.getPositions(player).first;

        List<Position> offensive = this._getOffensiveMoves(player, board, p)
                .toList(growable: false);

        if (offensive.length <= 0) {
            return null;
        }

        // pick an offensive at random
        Position result = offensive[rand.nextInt(offensive.length)];

        return result;
    }

    Set<Position> _getOffensiveMoves(Player player, Board board, Position p) {
        // find possible spots near the position
        List<Position> near = this._availablePositionsNear(p, board);

        // figure out which ones set us up for an offensive
        List<Position> offensive = new List<Position>();
        near.forEach((Position op) {
            List<Position> line = this._getLineFromPoints(p, op,
                    board.numRows, board.numCols);

            if (line.length < board.numRows || line.length < board.numCols) {
                return;
            }

            bool valid = true;
            for (Position pos in line) {
                Player pl = board.getAt(pos);
                if (pl != null && pl != player) {
                    valid = false;
                    break;
                }
            }

            if (valid) {
                offensive.addAll(line.where((Position p) => board.getAt(p) == null));
            }
        });

        return offensive.toSet();
    }

    /**
     *
     */
    Position _pickDefensiveMove(Player player, Board board) {

        // where did we move last turn?
        Position p = board.getPositions(player).first;

        Set<Position> offensive = this._getOffensiveMoves(player, board, p);

        List<Position> defensive = board.positionSet
                .difference(offensive)
                .where((p) => board.getAt(p) == null)
                .toList(growable: false);

        // pick an offensive at random
        Position result = defensive[rand.nextInt(defensive.length)];

        return result;
    }

    List<Position> _getLineFromPoints(Position p1, Position p2,
            int numRows, int numCols) {

        /*
         * X X .    X . .   . X .
         * . . .    . X .   . . .
         * . . .    . . .   . X .
         *
         * p3 = ( (p1.row + p2.row) % 3 , (p1.col + p2.col) % 3)
         *
         *              r = m * c + b
         *  (2,1)       r = ((p1.row - p2.row) / (p1.col - p2.col)) * c +
         *  (4,3)       m = (p1.row - p2.row) / (p1.col - p2.col)
         * . . . . .    br = p1.row - m * p1.col
         * . . . . .    if (p1.row == p2.row)   rows = List.filled(numCols, p1.row)
         * . X . . .    else rows = List.generate(numCols, (i) => (numRows + m * i)
         * . . . . .
         * . . . X .
         * . . . . .
         */

        if (p1.row == p2.row) {
            return new List.generate(numCols, (c) => new Position(p1.row, c));
        }
        if (p1.col == p2.col) {
            return new List.generate(numRows, (r) => new Position(r, p1.col));
        }

        // do it like a linear interpolation
        // y = m x + b
        // y = r, x = c
        // r = m c + b
        int m = ((p1.row - p2.row) ~/ (p1.col - p2.col));
        int b = p1.row - m * p1.col;
        return new List.generate(numCols, (_c) {
            int _r = m * _c + b;
            if (_r >= 0 && _r < numRows) {
                return new Position(_r, _c);
            }
            return null;
        }).where((pos) => pos != null).toList(growable: false);
    }

    /**
     * Return available positions around this position
     */
    List<Position> _availablePositionsNear(Position p, Board b) {

        List<Position> near = new List<Position>();
        for (int r = p.row - 1; r <= p.row + 1; r++) {
            for (int c = p.col - 1; c <= p.col + 1; c++) {
                Position pos = new Position(r, c);
                if (r >= 0 && r < b.numRows && c >= 0 && c < b.numCols &&
                        null == b.getAt(pos)) {
                    near.add(pos);
                }
            }
        }
        return near;
    }
}

