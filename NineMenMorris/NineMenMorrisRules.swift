

/**
 * @author Jonas WÂhslÈn, jwi@kth.se.
 * Revised by Anders Lindstrˆm, anderslm@kth.se
 */

/*
 * The game board positions
 *
 * 03           06           09
 *     02       05       08
 *         01   04   07
 * 24  23  22        10  11  12
 *         19   16   13
 *     20       17       14
 * 21           18           15
 *
 */

import Foundation

public class NineMenMorrisRules {
    static let BLUE_MOVES = 1;
    static let RED_MOVES = 2;

	static let EMPTY_SPACE = 0;
	static let BLUE_MARKER = 4;
	static let RED_MARKER = 5;
    
    private var gameplan = Array<Int>()
    private var bluemarker = 9
    private var redmarker = 9
    private var turn = RED_MOVES // player in turn

	/**
	 * Returns true if a move is successful
	 */
    func legalMove(to: Int, from: Int, color: Int) -> Bool {
		if color == turn {
			if turn == NineMenMorrisRules.RED_MOVES {
				if redmarker >= 0 {
					if gameplan[to] == NineMenMorrisRules.EMPTY_SPACE {
						gameplan[to] = NineMenMorrisRules.RED_MARKER
						redmarker--
						turn = NineMenMorrisRules.BLUE_MOVES
						return true
					}
				}
				/*else*/
				if gameplan[to] == NineMenMorrisRules.EMPTY_SPACE {
                    let valid = isValidMove(to, from: from)
					if valid {
						gameplan[to] = NineMenMorrisRules.RED_MARKER
						turn = NineMenMorrisRules.BLUE_MOVES
						return true
					} else {
						return false
					}
				} else {
					return false
				}
			} else {
				if bluemarker >= 0 {
					if gameplan[to] == NineMenMorrisRules.EMPTY_SPACE {
						gameplan[to] = NineMenMorrisRules.BLUE_MARKER
						bluemarker--
						turn = NineMenMorrisRules.RED_MOVES
						return true
					}
				}
				if gameplan[to] == NineMenMorrisRules.EMPTY_SPACE {
                    let valid = isValidMove(to, from: from)
					if valid {
						gameplan[to] = NineMenMorrisRules.BLUE_MARKER
						turn = NineMenMorrisRules.RED_MOVES
						return true
					} else {
						return false
					}
				} else {
					return false
				}
			}
		} else {
			return false
		}
	}

	/**
	 * Returns true if position "to" is part of three in a row.
	 */
    func remove(to: Int) -> Bool {
		if (to == 1 || to == 4 || to == 7) && gameplan[1] == gameplan[4] && gameplan[4] == gameplan[7] {
			return true
		} else if (to == 2 || to == 5 || to == 8) && gameplan[2] == gameplan[5] && gameplan[5] == gameplan[8] {
			return true
		} else if (to == 3 || to == 6 || to == 9) && gameplan[3] == gameplan[6] && gameplan[6] == gameplan[9] {
			return true
		} else if (to == 7 || to == 10 || to == 13) && gameplan[7] == gameplan[10] && gameplan[10] == gameplan[13] {
			return true
		} else if (to == 8 || to == 11 || to == 14) && gameplan[8] == gameplan[11] && gameplan[11] == gameplan[14] {
			return true
		} else if (to == 9 || to == 12 || to == 15) && gameplan[9] == gameplan[12] && gameplan[12] == gameplan[15] {
			return true
		} else if (to == 13 || to == 16 || to == 19) && gameplan[13] == gameplan[16] && gameplan[16] == gameplan[19] {
			return true
		} else if (to == 14 || to == 17 || to == 20) && gameplan[14] == gameplan[17] && gameplan[17] == gameplan[20] {
			return true
		} else if (to == 15 || to == 18 || to == 21) && gameplan[15] == gameplan[18] && gameplan[18] == gameplan[21] {
			return true
		} else if (to == 1 || to == 22 || to == 19) && gameplan[1] == gameplan[22] && gameplan[22] == gameplan[19] {
			return true
		} else if (to == 2 || to == 23 || to == 20) && gameplan[2] == gameplan[23] && gameplan[23] == gameplan[20] {
			return true
		} else if (to == 3 || to == 24 || to == 21) && gameplan[3] == gameplan[24] && gameplan[24] == gameplan[21] {
			return true
		} else if (to == 22 || to == 23 || to == 24) && gameplan[22] == gameplan[23] && gameplan[23] == gameplan[24] {
			return true
		} else if (to == 4 || to == 5 || to == 6) && gameplan[4] == gameplan[5] && gameplan[5] == gameplan[6] {
			return true
		} else if (to == 10 || to == 11 || to == 12) && gameplan[10] == gameplan[11] && gameplan[11] == gameplan[12] {
			return true
		} else if (to == 16 || to == 17 || to == 18) && gameplan[16] == gameplan[17] && gameplan[17] == gameplan[18] {
			return true
		}
        
		return false
	}

	/**
	 * Request to remove a marker for the selected player.
	 * Returns true if the marker where successfully removed
	 */
    func remove(from: Int, color: Int) -> Bool {
		if gameplan[from] == color {
			gameplan[from] = NineMenMorrisRules.EMPTY_SPACE;
			return true
        } else {
			return false
        }
	}

	/**
	 *  Returns true if the selected player have less than three markerss left.
	 */
    func win(color: Int) -> Bool {
		var countMarker = 0
		var count = 0;
		while count < 23 {
            if gameplan[count] != NineMenMorrisRules.EMPTY_SPACE && gameplan[count] != color {
				countMarker++
            }
			count++
		}
        
        if bluemarker <= 0 && redmarker <= 0 && countMarker < 3 {
			return true
        } else {
			return false
        }
	}

	/**
	 * Returns EMPTY_SPACE = 0 BLUE_MARKER = 4 READ_MARKER = 5
	 */
    func board(from: Int) -> Int {
		return gameplan[from];
	}
	
	/**
	 * Check whether this is a legal move.
	 */
    func isValidMove(to: Int, from: Int) -> Bool {
		
        if gameplan[to] != NineMenMorrisRules.EMPTY_SPACE {
            return false
        }
		
		switch to {
		case 1:
			return (from == 4 || from == 22)
		case 2:
			return (from == 5 || from == 23)
		case 3:
			return (from == 6 || from == 24)
		case 4:
			return (from == 1 || from == 7 || from == 5)
		case 5:
			return (from == 4 || from == 6 || from == 2 || from == 8)
		case 6:
			return (from == 3 || from == 5 || from == 9)
		case 7:
			return (from == 4 || from == 10)
		case 8:
			return (from == 5 || from == 11)
		case 9:
			return (from == 6 || from == 12)
		case 10:
			return (from == 11 || from == 7 || from == 13)
		case 11:
			return (from == 10 || from == 12 || from == 8 || from == 14)
		case 12:
			return (from == 11 || from == 15 || from == 9)
		case 13:
			return (from == 16 || from == 10)
		case 14:
			return (from == 11 || from == 17)
		case 15:
			return (from == 12 || from == 18)
		case 16:
			return (from == 13 || from == 17 || from == 19)
		case 17:
			return (from == 14 || from == 16 || from == 20 || from == 18)
		case 18:
			return (from == 17 || from == 15 || from == 21)
		case 19:
			return (from == 16 || from == 22)
		case 20:
			return (from == 17 || from == 23)
		case 21:
			return (from == 18 || from == 24)
		case 22:
			return (from == 1 || from == 19 || from == 23)
		case 23:
			return (from == 22 || from == 2 || from == 20 || from == 24)
		case 24:
			return (from == 3 || from == 21 || from == 23)
        default:
            break
		}
        
		return false
	}
}