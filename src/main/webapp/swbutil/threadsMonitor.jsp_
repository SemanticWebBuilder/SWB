<%-- 
    Document   : threads
    Created on : 28/06/2010, 08:12:15 PM
    Author     : jei
--%>

<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="monitor.ThreadsMonitor"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.TimerTask"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Timer"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="java.lang.management.ThreadInfo"%>
<%@page import="org.semanticwb.portal.monitor.SWBThreadDumper"%>
<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.lang.management.ThreadMXBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%! 
    public Timer timer = null;
    long count=0;
    public PrintWriter fout=null;
    
    String getContent(String curl)
    {
        String content=null;
        try
        {
            URL url=new URL(curl);
            content=SWBUtils.IO.readInputStream((InputStream)url.openConnection().getContent());
            //System.out.println(content);
        }catch(Exception e)
        {
            e.printStackTrace();
        } 
        return content;              
    }

    void start(JspWriter out) throws IOException
    {
        System.out.println(new Date()+" Start Threads Monitor...");
        out.println("<pre>");
        out.println("Start Threads Monitor...");
        out.println("</pre>");
        timer = new Timer("Thread Monitor");
        timer.schedule(new TimerTask()
        {
            Timer _timer=timer;
            
            @Override
            public void run()
            {
                if(fout==null)
                {
                    try
                    {
                        Date d=new Date();
                        fout=new PrintWriter(new FileOutputStream(System.getProperty("user.home")+"/threadsMonitor"+(d.getYear()+1900)+"_"+(d.getMonth()+1)+"_"+(d.getDate())+"_"+(d.getHours()+1)+".txt"));
                    }catch(Exception e){e.printStackTrace();}
                }
                
                
                System.out.println(new Date()+" Run...");
                fout.println("-----------------------------------------------------------------------------------------------------------");
                fout.println(new Date()+" Run...");
                
                if(_timer!=ThreadsMonitor.timer)
                {
                    try
                    {
                        System.out.println("Timer Stoped...");
                        timer.cancel();
                        fout.close();
                    }catch(Exception e)
                    {
                        e.printStackTrace();
                    }
                    return;
                }
                count++;
                
                
                fout.println("--------------------------------------------------------------");
                String content=getContent("http://207.248.166.203:9020/swbutil/threads.jsp");
                fout.println(new Date()+" loading: "+"http://207.248.166.203:9020/swbutil/threads.jsp");
                fout.println(content);
                fout.flush();
                
                fout.println("--------------------------------------------------------------");
                content=getContent("http://207.248.166.215:9020/swbutil/threads.jsp");
                fout.println(new Date()+" loading: "+"http://207.248.166.215:9020/swbutil/threads.jsp");
                fout.println(content);                
                fout.flush();
                /*
                fout.println("--------------------------------------------------------------");
                content=getContent("http://207.248.166.203:9030/STPSEmpleoWebBack/swbutil/threads.jsp");
                fout.println(new Date()+" loading: "+"http://207.248.166.203:9020/STPSEmpleoWebBack/swbutil/threads.jsp");
                fout.println(content);
                fout.flush();
                
                fout.println("--------------------------------------------------------------");
                content=getContent("http://207.248.166.215:9030/STPSEmpleoWebBack/swbutil/threads.jsp");
                fout.println(new Date()+" loading: "+"http://207.248.166.215:9020/STPSEmpleoWebBack/swbutil/threads.jsp");
                fout.println(content);                
                fout.flush();
                */
                
                fout.close();
                fout=null;
                
            }
        }, 1000 * 10, 1000 * 60);
        ThreadsMonitor.timer=timer;
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Threads List</title>
    </head>
    <body>
        <%
            /*
             User user=SWBContext.getAdminUser();
             if(user==null)
             {
             response.sendError(403);
             return;
             }            
             */
            out.println("<h1>Threads Monitor</h1>");

            if (timer == null)
            {
                start(out);
            }

            out.println("<h2>Counter: "+count+"</h1>");

        %>
    </body>
</html>
