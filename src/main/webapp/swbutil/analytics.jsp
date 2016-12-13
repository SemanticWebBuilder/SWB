<%-- 
    Document   : analitics
    Created on : 30-jul-2013, 3:04:58
    Author     : javier.solis.g
--%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.portal.access.LinkedPageCounter"%>
<%@page import="org.semanticwb.base.util.URLEncoder"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>LinkedPagesCounter Viewer</h1>
    <pre>        
<%
        User user=SWBContext.getAdminUser();
       
        if(user==null)
        {
            response.sendError(403);
            return;
        }      
    
    String p=request.getParameter("p");
    if(p!=null)
    {
        LinkedPageCounter cpage=LinkedPageCounter.getCounter(p);
        
        out.println("Page: "+cpage.getId());
        out.println("Hits:"+cpage.getCounter());
        out.println("Link2Childs:"+cpage.getTotalChildCounter());
        out.println("LinkFromParent:"+cpage.getTotalParentCounter());
        out.println("External:"+(cpage.getCounter()-cpage.getTotalParentCounter()));
        out.println("NotFollow:"+(cpage.getCounter()-cpage.getTotalChildCounter()));
        out.println("  Childs:");
        
        Iterator<Map.Entry<String,Integer>> it=cpage.getSortedChildSet().descendingIterator();
        while (it.hasNext())
        {
            Map.Entry<String,Integer> lc = it.next();
            out.println("    <a href='?p="+URLEncoder.encode(lc.getKey())+"'>"+lc.getKey()+"</a> "+lc.getValue());
        }
        
        out.println("  Parents:");
        it=cpage.getSortedParentSet().descendingIterator();
        while (it.hasNext())
        {
            Map.Entry<String,Integer> lc = it.next();
            out.println("    <a href='?p="+URLEncoder.encode(lc.getKey())+"'>"+lc.getKey()+"</a> "+lc.getValue());
        }        
    }else
    {
        out.println("total hits:"+LinkedPageCounter.getTotalHits());
        out.println("total sess:"+LinkedPageCounter.getTotalSessions());
        out.println("total reRess:"+LinkedPageCounter.getTotalSessionsReused());
        out.println("pages:"+LinkedPageCounter.size());
        out.println("links:"+LinkedPageCounter.getTotalLinks());
        
        Iterator<LinkedPageCounter> it=LinkedPageCounter.listPages().descendingIterator();
        while(it.hasNext())
        {
            LinkedPageCounter lp=it.next();
%>    <a href="?p=<%=URLEncoder.encode(lp.getId())%>"><%=lp.getId()%></a> <%=lp.getCounter()%>
<%            
        }
    }
%>        
    </pre>
    </body>
</html>
