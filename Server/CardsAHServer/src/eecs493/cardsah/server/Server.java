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
import java.util.Random;

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
    
    static int cardsPerHand;
    static int howToWin;
    static int points;
    static boolean playToPoints;
    
   
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
                Player p = new Player(s);
                players.add(p);
                sendPlayers();
                try {
					Thread.sleep(500);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
                //players.get(players.size()-1).start();
                if(players.size() == 1)
                {
                	GetRules getRules = new GetRules(p.in,p.out);
                	Thread thr = new Thread(getRules);
                	thr.start();
                }
            } catch (IOException e) {System.out.println("Add connection "+e);}
        }
    	sendRules();
        sendStarting();
    }
    
    public static synchronized void setRules(String cph, String htw,
			String pts, boolean ptp)
    {
    	cardsPerHand = Integer.parseInt(cph);
    	howToWin = Integer.parseInt(htw);
    	playToPoints = ptp;
    	if(playToPoints)
    	{
    		points = Integer.parseInt(pts);
    	}
    	else
    		points = -1;
    }
    
    public static synchronized void sendRules()
    {
    	try
    	{
	    	for(int n = 0; n < players.size(); n++)
	    	{
	    		players.get(n).out.writeInt(99);
	    		players.get(n).out.writeInt(cardsPerHand);
	    		players.get(n).out.writeInt(howToWin);
	    		if(playToPoints)
	    			players.get(n).out.writeInt(points);
	    		players.get(n).out.flush();
	    	}
    	}
    	catch(IOException e)
    	{
    		System.out.println("Send rules " + e);
    	}
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
        	Random rand=new Random();
            int seed=rand.nextInt();
            for(int i=0; i<players.size(); i++){
                players.get(i).out.writeInt(seed);
                players.get(i).out.flush();
            }
            for(int i=0; i<players.size(); i++){
                if(i==curPlayer)
                    players.get(i).out.writeBoolean(true);
                	//Possibly write dealer's card here
                else
                    players.get(i).out.writeBoolean(false);
                players.get(i).out.flush();
            }
        	while(true)
        	{
        		System.out.println("New round started...");
	        	numPlayersPlayed = 0;
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
        	
	            while(waitingForPlayers){
	            	try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
	            }
        	}
        }catch(IOException e){}
    }
   
    static void writeWinner(String file)
    {
    	try{
	    	for( int n = 0; n < players.size(); n++)
	    	{
	    		if(n != curPlayer)
	    		{
		    		players.get(n).out.writeInt(51);
		    		players.get(n).out.writeBytes(file + '\0');
		    		players.get(n).out.flush();
	    		}
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
	        		try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
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
        }catch(Exception e){
        	System.out.println("GetString "+e);
        	System.exit(1);
        }
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