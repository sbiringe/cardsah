package eecs493.cardsah.server;

import java.io.DataInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

public class PlayersTurn implements Runnable
{
	DataInputStream in;
	String user;
	
	PlayersTurn(DataInputStream input, String user)
	{
		in = input;
		this.user = user;
	}
	
	@Override
	public void run() {
		String file = Server.getString(in);
		
        Server.choiceMade(user, file);
	}
	
}