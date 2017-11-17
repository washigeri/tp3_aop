package ca.uqac.inf957.chess.piece;

import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;

public class Pawn extends Piece {

    public Pawn(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "P" : "p");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
	    }

}
