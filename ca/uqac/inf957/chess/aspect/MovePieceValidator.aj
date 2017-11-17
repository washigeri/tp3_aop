package ca.uqac.inf957.chess.aspect;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.piece.Piece;

public aspect MovePieceValidator {

    boolean Piece.isMoveLegal(Move mv, Board board) {
        return false;
    }



    pointcut moveLegal(Piece piece, Move mv, Board board): call(boolean Piece.isMoveLegal(Move, Board))
            && target(piece) && args(mv,board);

    private enum PIECES {
        Bishop, King, Knight, Pawn, Queen, Rook
    }

    boolean around(Piece piece, Move mv, Board board): moveLegal(piece, mv, board){
        boolean res = false;
        PIECES pieceClass = PIECES.valueOf(piece.getClass().getSimpleName());
        switch (pieceClass) {
            case King:
                res = IsKingMoveLegal(piece, mv, board);
                break;
            case Pawn:
                res = IsPawnMoveLegal(piece, mv, board);
                break;
            case Rook:
                res = IsRookMoveLegal(piece, mv, board);
                break;
            case Bishop:
                res = IsBishopMoveLegal(piece, mv, board);

                break;
            case Knight:
                res = IsKnightMoveLegal(piece, mv, board);
                break;
            case Queen:
                res = IsQueenMoveLegal(piece, mv, board);
                break;
        }
        return res;
    }

    private boolean IsKingMoveLegal(Piece piece, Move mv, Board board) {
        return (Math.abs(mv.xI - mv.xF) == 1) && (Math.abs(mv.yI - mv.yF) == 1)
                && (!board.getGrid()[mv.xF][mv.yF].isOccupied()
                || board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer());
    }

    private boolean IsPawnMoveLegal(Piece piece, Move mv, Board board) {
        int direction = (piece.getPlayer() == 0) ? -1 : 1;
        if ((mv.yF - mv.yI) * direction != 1)
            return false;
        else if (Math.abs(mv.xI - mv.xF) == 0)
            return !board.getGrid()[mv.xF][mv.yF].isOccupied();
        else {
            return ((Math.abs(mv.xI - mv.xF) == 1) && (board.getGrid()[mv.xF][mv.yF].isOccupied())
                    && (board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer()));
        }

    }

    private boolean IsRookMoveLegal(Piece piece, Move mv, Board board) {
        if ((mv.xF - mv.xI != 0) && (mv.yF - mv.yI != 0) || (mv.xF - mv.xI == 0) && (mv.yF - mv.yI == 0))
            return false;
        else if (mv.xF - mv.xI != 0) {
            int dir = (mv.xF - mv.xI > 0) ? 1 : -1;
            for (int k = 0; k < Math.abs(mv.xI - mv.xF); k++) {
                if (board.getGrid()[mv.xI + dir * k][mv.yI].isOccupied()) {
                    return false;
                }
            }
            return !board.getGrid()[mv.xF][mv.yF].isOccupied() ||
                    board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer();
        } else {
            int dir = (mv.yF - mv.yI > 0) ? 1 : -1;
            for (int k = 0; k < Math.abs(mv.yI - mv.yF); k++) {
                if (board.getGrid()[mv.xI][mv.yI + dir * k].isOccupied()) {
                    return false;
                }
            }
            return !board.getGrid()[mv.xF][mv.yF].isOccupied() ||
                    board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer();
        }
    }

    private boolean IsBishopMoveLegal(Piece piece, Move mv, Board board) {
        if (Math.abs(mv.xI - mv.xF) != Math.abs(mv.yI - mv.yF)) {
            return false;
        }
        else {
            int xdir, ydir;
            xdir = Integer.compare(0, mv.xI - mv.xF);
            ydir = Integer.compare(0, mv.yI - mv.yF);
            for (int k = 1; k < Math.abs(mv.xF - mv.xI); k++) {
                if (board.getGrid()[mv.xI + xdir * k][mv.yI + ydir * k].isOccupied()) {
                    return false;
                }
            }
            return !board.getGrid()[mv.xF][mv.yF].isOccupied() ||
                    board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer();
        }
    }

    private boolean IsKnightMoveLegal(Piece piece, Move mv, Board board) {
        return (((Math.abs(mv.xF - mv.xI) == 2) && (Math.abs(mv.yF - mv.yI) == 1)) ||
                ((Math.abs(mv.yI - mv.yF) == 2) && (Math.abs(mv.xF - mv.xI) == 1))) &&
                (!board.getGrid()[mv.xF][mv.yF].isOccupied() ||
                        board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() != piece.getPlayer());
    }

    private boolean IsQueenMoveLegal(Piece piece, Move mv, Board board) {
        return (IsBishopMoveLegal(piece, mv, board) || IsRookMoveLegal(piece, mv, board));
    }
}
