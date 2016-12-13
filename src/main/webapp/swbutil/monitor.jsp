<%@page import="org.semanticwb.portal.monitor.SWBSummaryData"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.servlet.internal.Distributor"%>
<%@page import="org.semanticwb.portal.monitor.SWBLocalMemoryPool"%>
<%@page import="org.semanticwb.portal.SWBMonitor"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.util.Vector"%>
<%@page import="org.semanticwb.portal.monitor.SWBSummary"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<%!
static private SWBSummary swbSummary = new SWBSummary();
%><html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SWB Monitor Info</title>
    </head>
    <body>        
<%
    org.semanticwb.model.User user=SWBContext.getAdminUser();
/*    
    if(user==null)
    {
        response.sendError(403);
        return;
    }
*/    
 
    String pc=null; //request.getParameter("pageCache");
    SWBSummaryData sample=swbSummary.getSample();
    if(pc!=null)Distributor.setPageCache(Boolean.parseBoolean(pc));
%>        
        <h1>General</h1>
        <ul>
            <li>PageCache:<%= Distributor.isPageCache() %></li>
            <li>CPU Time:<%= String.format("%1$3.6f",sample.instantCPU) %></li>
            <li>Instance Name:<%= sample.vmInstanceName %></li>
            <li>Commited:<%= String.format("%,d",sample.currentCommited) %></li>
            <li>Heap:<%= String.format("%,d",sample.currentHeap) %></li>
            <li>GC:<% for (String item:sample.gcDetails) { out.print("<br>"+item);} %></li>
            <li>Threads:<%= sample.startedTh %></li>
            <li>Demonios:<%= sample.deamonTh %></li>
        </ul>
        <h1>Memoria</h1>

        <% 
        if (null!=swbSummary.getMemoryPoolProxies()) {
           
            java.util.Iterator<SWBLocalMemoryPool> iter = swbSummary.getMemoryPoolProxies().iterator();
            if (null!=iter){ 
                while (iter.hasNext()){
                    SWBLocalMemoryPool lmp = iter.next();
                    if (null!=lmp){ 
                        %><br><h3><%=lmp.getStat().getPoolName()%></h3>
<pre><% if (null!=lmp.getStat().getBeforeGcUsage()) { %><%=lmp.getStat().getBeforeGcUsage().toString() %>
<% } if (null!=lmp.getStat().getAfterGcUsage()) { %><%=lmp.getStat().getAfterGcUsage().toString() %>
<% } if (null!=lmp.getStat().getUsage()) { %><%=lmp.getStat().getUsage().toString() %>
<% } %></pre>
                        <% 
                    }
                }
            }
        } 
        %>
        <h1>Histórico</h1>
        <table border="1">
            <thead>
                <tr>
                    <th align="center">Date</th>
                    <th align="center">Used Memory</th>
                    <th align="center">Max Memory</th>
                    <th align="center">Hits</th>
                    <th align="center">Hits Time</th>
                    <th align="center">Hits/Second</th>
                    <th align="center">Users</th>
                    <th align="center">C.ResHits</th>
                    <th align="center">C.ResLoadHits</th>
                </tr>
            </thead>
            <tbody>
        
<%
        Vector<SWBMonitor.MonitorRecord> data = SWBPortal.getMonitor().getMonitorRecords();
        Enumeration<SWBMonitor.MonitorRecord> en = data.elements();
        
        long old=0;
        while (en.hasMoreElements()) 
        {
            SWBMonitor.MonitorRecord mr = en.nextElement();
            
            String date = "" + mr.getDate().getHours() + ":" + mr.getDate().getMinutes() + ":" + mr.getDate().getSeconds();
            
            if(old==0)old=mr.getHits();
%>
                <tr>
                    <td align="right"><%=date%></td>
                    <td align="right"><%=String.format("%,d", mr.getUsedMemory())%></td>
                    <td align="right"><%=String.format("%,d", mr.getMaxMemory())%></td>
                    <td align="right"><%=String.format("%,d", mr.getHits())%></td>
                    <td align="right"><%=String.format("%,d", mr.getHitsTime())%></td>
                    <td align="right"><%=String.format("%,d", (mr.getHits()-old)/SWBPortal.getMonitor().getDelay())%></td>
                    <td align="right"><%=String.format("%,d", mr.getMaxUsers())%></td>
                    <td align="right"><%=String.format("%,d", mr.getCacheResHits())%></td>
                    <td align="right"><%=String.format("%,d", mr.getCacheResLoadHits())%></td>
                </tr>
<%
            old=mr.getHits();
        }
%>        
            </tbody>
        </table>
        
    </body>
</html>
