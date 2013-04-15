package eecs493.cardsah.server;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

class Player {//extends Thread{
    public String name;
    public Socket s;
    public DataInputStream in;
    public DataOutputStream out;

    Player(Socket sock){
        try{
            System.out.println("Something connected...");
            s=sock;
            in=new DataInputStream(new BufferedInputStream(s.getInputStream(),
4096));
            out=new DataOutputStream(new BufferedOutputStream(s.getOutputStream(),
4096));
            name=Server.getString(in);
            System.out.println(name);
            
            //out.writeBytes(name + '\0');
            //out.writeInt(5);
            out.flush();
        }catch(Exception e){System.out.println("Player cntr "+e);}
    }
   
    //public void run() {}
   
}

class admin implements Runnable{
    public void run(){
        try {
            ServerSocket ss=new ServerSocket(4041);
            Socket s=null;
            s=ss.accept();
            if(s!=null)
                s.close();
            System.out.println("Someone pressed start");
            Server srvr=new Server();
            srvr.setStart();
            s=new Socket(InetAddress.getLocalHost().getHostAddress(), 1024);
            if(s!=null)
                s.close();
        } catch (IOException e) {System.out.println("Admin "+e);}
    }
}

public class Server {
    static ServerSocket ss;
    static ArrayList<Player> players;
    static int forfeit=-1;
    static boolean start;
    static int curPlayer=0, score, row, col, lettersused;
    static boolean vertical;
    static String word;
    static int numPlayersPlayed;
    static boolean waitingForPlayers;
   
    static void getConnections(){
        start=false;
        waitingForPlayers = false;
        admin a=new admin();
        Thread t=new Thread(a);
        t.start();
        while(!start){
            try {
                Socket s=ss.accept();
                if(start)
                    break;
                players.add(new Player(s));
                sendPlayers();
                //players.get(players.size()-1).start();
                
            } catch (IOException e) {System.out.println("Add connection "+e);}
        }
        sendStarting();
    }
   
    static void sendPlayers(){
        boolean good=true;
        for(int i=0; i<players.size(); i++){
            try {
                players.get(i).out.writeInt(players.size());
                for(int j=0; j<players.size(); j++){
                    players.get(i).out.writeBytes(players.get(j).name + '\0');
                    players.get(i).out.flush();
                }
            } catch (IOException e) {
                System.out.println("remove "+players.get(i).name);
                players.remove(i);
                good=false;
                break;
            }
        }
        if(!good)
            sendPlayers();
    }
   
    void setStart(){
        start=true;
    }
    
    static void stopWaitingForPlayers()
    {
    	waitingForPlayers = false;
    }
       
    static void sendStarting(){
        int i=0;
        while(i<players.size()){
            try {
                players.get(i).out.writeInt(-1);
                players.get(i).out.flush();
                i++;
            } catch (IOException e) {
                System.out.println("remove "+players.get(i).name);
                players.remove(i);
            }
        }
    }
   
    static void gameplay(){
        try {
        	while(true)
        	{
	        	numPlayersPlayed = 0;
	            for(int i=0; i<players.size(); i++){
	                if(i==curPlayer)
	                    players.get(i).out.writeBoolean(true);
	                	//Possibly write dealer's card here
	                else
	                    players.get(i).out.writeBoolean(false);
	                players.get(i).out.flush();
	            }
	            //Create threads listening for each player's selection
	            for(int i=0; i<players.size(); i++){
	            	if(i != curPlayer)
	            	{
		            	PlayersTurn pt = new PlayersTurn(players.get(i).in, 
		            										players.get(i).name);
		            	Thread t = new Thread(pt);
		            	t.start();
	            	}
	            }
	            waitingForPlayers = true;
        	
	            while(waitingForPlayers){}
        	}
        }catch(IOException e){}
    }
   
    static void writeWinner(String file)
    {
    	try{
	    	for( int n = 0; n < players.size(); n++)
	    	{
	    		players.get(n).out.writeInt(51);
	    		players.get(n).out.writeBytes(file + '\0');
	    		players.get(n).out.flush();
	    	}
    	}
    	catch(IOException e){}
    }
    
    public static synchronized void choiceMade(String user, String file)
    {
    	int index = getUserIndex(user);
    	
    	if( index != -1)
    	{
    		System.out.println(user + " played " + file);
    		numPlayersPlayed++;
    		try
    		{
    			//Tell all other players what card was played
	    		for(int n = 0; n < players.size(); n++)
	    		{
	    			if( index != n)
	    			{
	    				players.get(n).out.writeInt(2);
	    				players.get(n).out.writeBytes(user + '\0' + file + '\0');
	    				players.get(n).out.flush();
	    			}
	    		}
	    		
	    		if( numPlayersPlayed >= players.size() - 1)
	        	{
	        		System.out.println("All players played!");
	        		//tell dealer it is his turn to select winner
	        		players.get(curPlayer).out.writeInt(50);
	        		players.get(curPlayer).out.flush();
	        		String winnerFile = Server.getString(players.get(curPlayer).in);
	        		writeWinner(winnerFile);
	        		updateCurPlayer();
	        		stopWaitingForPlayers();
	        	}
	    		
    		}
    		catch(IOException e){ System.out.println("choice made: " + e);}
    	}
    	else
    	{
    		System.out.println("Couldn't find user, card choice not accepted");
    	}
    }
    
    static int getUserIndex(String user)
    {
    	for( int n=0; n < players.size(); n++)
    	{
    		if( players.get(n).name.equals(user) )
    			return n;
    	}
    	return -1; 
    }
   
    public static String getString(DataInputStream in){
        String result = "";
        try{
            /*while (true) {
                char c = in.readChar();
                if (c == '\0')
                    break;
                result += c;
            }*/
            result = in.readUTF();
        }catch(Exception e){System.out.println("GetString "+e);}
        return result;
    }
   
    static void sendForfeit() throws IOException{
        DataOutputStream out;
        for(int i=0; i<players.size(); i++){
            out=players.get(i).out;
            out.writeInt(-1);
            out.writeInt(forfeit);
            out.flush();
        }
    }
   
    static void updateCurPlayer(){
        curPlayer++;
        if(curPlayer>=players.size())
            curPlayer=0;
    }
   
    public static void main(String[] args){
        try{
            System.out.println(InetAddress.getLocalHost().getHostAddress());
            ss=new ServerSocket(1024);
            players=new ArrayList<Player>();
            getConnections();
            gameplay();
        }catch (Exception e){
            System.out.println("ERROR: Unusable port");
        }
    }
}