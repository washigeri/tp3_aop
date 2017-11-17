package ca.uqac.inf957.chess.aspect;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;

public aspect MoveValidator {

    pointcut moveAttempt(Player player, Move mv): call(boolean Player.move(Move)) && target(player) && args(mv);

    boolean around(Player player, Move mv): moveAttempt(player, mv){
        boolean res = IsMoveInBounds(mv) && IsMovingNull(mv, player) && IsMovingOwnPiece(mv, player)
                && IsMovePieceLegal(mv, player);
        if (res)
            player.getPlayGround().movePiece(mv);
        return res;
    }


    private boolean IsMoveInBounds(Move mv) {
        int bound = Board.SIZE;
        return !(mv.xI >= bound || mv.xF >= bound || mv.yI >= bound || mv.yF >= bound
                || mv.xI < 0 || mv.xF < 0 || mv.yI < 0 || mv.yF < 0);

    }

    private boolean IsMovingOwnPiece(Move mv, Player player) {
        return (player.getPlayGround().getGrid()[mv.xI][mv.yI].getPiece().getPlayer() == player.getColor());
    }

    private boolean IsMovingNull(Move mv, Player player) {
        return (player.getPlayGround().getGrid()[mv.xI][mv.yI].isOccupied());
    }

    private boolean IsMovePieceLegal(Move mv, Player player) {
        return (player.getPlayGround().getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv, player.getPlayGround()));
    }
}
