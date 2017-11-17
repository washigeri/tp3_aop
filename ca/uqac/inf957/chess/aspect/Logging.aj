package ca.uqac.inf957.chess.aspect;

import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public aspect Logging {
    private String logPath = "log_" + (new SimpleDateFormat("dd-MM-yyyy_HH-mm-ss")).format(new Date()) + ".log";
    private BufferedWriter bufferedWriter = null;

    private void OpenLogFile(){
        try{
            FileWriter fileWriter = new FileWriter(logPath, true);
            bufferedWriter = new BufferedWriter(fileWriter);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void CloseLogFile(){
        try {
            bufferedWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    pointcut moveMade(Move mv, Player player) : call(boolean Player.move(Move)) && args(mv) && target(player);

    after(Move mv, Player player) returning(boolean value) : moveMade(mv, player){
        if(value){
            try {
                OpenLogFile();
                bufferedWriter.write(String.format("%s - %s : %s", player.getColorName(), (player.getClass()).getSimpleName(), mv.toString()));
                bufferedWriter.newLine();
                CloseLogFile();
            }
            catch (IOException e){
                e.printStackTrace();
            }
        }
    }


}
