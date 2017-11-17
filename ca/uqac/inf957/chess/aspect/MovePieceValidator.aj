package ca.uqac.inf957.chess.aspect;

import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.piece.Piece;

public aspect MovePieceValidator {
    pointcut moveLegal(Piece piece, Move mv): call(* Piece.isMoveLegal(Move)) && target(piece) && args(mv);
}
