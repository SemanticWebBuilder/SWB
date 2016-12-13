<%-- 
    Document   : threads
    Created on : 28/06/2010, 08:12:15 PM
    Author     : jei
--%>

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
    ThreadMXBean thbean = java.lang.management.ManagementFactory.getThreadMXBean();
    /** The Constant SEGUNDO. */
    final long SEGUNDO = 1000;
    
    /** The Constant MINUTO. */
    final long MINUTO = 60 * SEGUNDO;
    
    /** The Constant HORA. */
    final long HORA   = 60 * MINUTO;
    
    /** The Constant DIA. */
    final long DIA    = 24 * HORA;    
    
    int countBLOCKEDThread()
    {
        int x=0;
        long[] tiarr = thbean.getAllThreadIds();
        for (long ct : tiarr)
        {
            ThreadInfo ti = thbean.getThreadInfo(ct);
            if (ti.getThreadState().equals(Thread.State.BLOCKED))
            x++;
        }
        return x;
    }

    String dumpBLOCKEDThreadWithStackTrace()
    {
        StringBuilder sb = new StringBuilder("ThreadDump: " + "\n");
        long[] tiarr = thbean.getAllThreadIds();
        for (long ct : tiarr)
        {
            ThreadInfo ti = thbean.getThreadInfo(ct);
            if (ti.getThreadState().equals(Thread.State.BLOCKED))
            sb.append(formatThreadInfo(thbean.getThreadInfo(ct, Integer.MAX_VALUE)));
        }
        return sb.toString();
    }
    
    String formatThreadInfo(ThreadInfo ti)
    {
        StringBuilder sb = new StringBuilder("\"" + ti.getThreadName() + "\""
                + " Id=" + ti.getThreadId()
                + " in " + ti.getThreadState());
        if (ti.getLockName() != null)
        {
            sb.append(" on lock=" + ti.getLockName());
        }
        if (ti.isSuspended())
        {
            sb.append(" (suspended)");
        }
        if (ti.isInNative())
        {
            sb.append(" (running in native)");
        }
        sb.append("\n");
        if (ti.getLockOwnerName() != null)
        {
            sb.append("     owned by " + ti.getLockOwnerName()
                    + " Id=" + ti.getLockOwnerId() + "\n");
        }
        for (StackTraceElement ste : ti.getStackTrace())
        {
            sb.append("    at " + ste.toString() + "\n");
        }
        sb.append("\n");
        return sb.toString();
    }    
    
    String dumpThreadWithStackTrace()
    {

        StringBuilder sb = new StringBuilder("ThreadDump: " + "\n");
        long[] tiarr = thbean.getAllThreadIds();
        for (long ct : tiarr)
        {
            sb.append("ThreadCpuTime: "+formatTime(thbean.getThreadCpuTime(ct)/1000000)+"\n");
            sb.append(formatThreadInfo(thbean.getThreadInfo(ct, Integer.MAX_VALUE)));
        }
        return sb.toString();
    }   

    String formatTime(long t) 
    {
        String str;
        if (t < 1 * MINUTO) {
            String seconds = String.format("%.3f", t / (double)SEGUNDO);
            str = ""+seconds+" Segundos";
        } else {
            long remaining = t;
            long days = remaining / DIA;
            remaining %= 1 * DIA;
            long hours = remaining / HORA;
            remaining %= 1 * HORA;
            long minutes = remaining / MINUTO;

            if (t >= 1 * DIA) {
                str = ""+days+" dias, "+hours+" horas, "+minutes+" minutos";
            } else if (t >= 1 * HORA) {
                str = ""+hours+" horas, "+minutes+" minutos";
            } else {
                str = ""+minutes+" minutos";
            }
        }
        return str;
    }       
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Threads List</title>
    </head>
    <body>
        <%        

        User user=SWBContext.getAdminUser();
/*       
        if(user==null)
        {
            response.sendError(403);
            return;
        }            
*/
            String stop=null;// request.getParameter("stop");
            if(stop!=null)
            {
                ThreadGroup group=Thread.currentThread().getThreadGroup();
                int numThreads = group.activeCount();
                Thread[] athreads = new Thread[numThreads*2];
                numThreads = group.enumerate(athreads, false);

                // Enumerate each thread in `group'
                for (int i=0; i<numThreads; i++) {
                    // Get thread
                    Thread thread = athreads[i];
                    out.println("thread:"+thread.getName()+"<br>");
                    if(stop!=null && stop.length()>1 && thread.getName().indexOf(stop)>-1)
                    {
                        try
                        {
                            thread.suspend();;
                            //thread.interrupt();
                            thread.stop();
                            //thread.destroy();
                        }catch(Throwable e){out.println(e);}
                        out.println("Interrupted...<br>");
                    }
                }
            }
            

            ThreadMXBean threads=ManagementFactory.getThreadMXBean();
            long t[]=threads.getAllThreadIds();

            out.println("<h1>Threads:"+t.length+"</h1>");

        %>
        <h1>Threads BLOCKED <%=countBLOCKEDThread()%></h1>
        <pre><%=dumpBLOCKEDThreadWithStackTrace()%></pre>

        <h1>All Threads <%=t.length%></h1>
        <pre><%=dumpThreadWithStackTrace()%></pre>
    </body>
</html>
