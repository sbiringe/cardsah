package eecs493.cardsah.server;

import java.io.DataInputStream;
import java.io.DataOutputStream;

public class GetRules implements Runnable
{
	DataInputStream in;
	DataOutputStream out;
	String user;
	
	GetRules(DataInputStream input, DataOutputStream output)
	{
		in = input;
		out = output;
	}
	
	@Override
	public void run() {
    	String cardsPerHand = Server.getString(in);
    	String howToWin = Server.getString(in);
    	String points = "";
    	boolean playToPoints = (Integer.parseInt(howToWin) == 0);
    	if(playToPoints)
    	{
    		points = Server.getString(in);
    	}

    	System.out.print("Rules: ");
    	System.out.print(cardsPerHand + " cards per hand, ");
    	System.out.print(howToWin + " win type, ");
    	System.out.print(points + " points to win");
    	System.out.println();
    	
    	Server.setRules(cardsPerHand, howToWin, points, playToPoints);
	}
	
}