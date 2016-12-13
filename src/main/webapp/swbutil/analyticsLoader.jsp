<%-- 
    Document   : analyticsLoader
    Created on : 30-jul-2013, 3:05:58
    Author     : javier.solis.g
--%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
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
        <h1>LinkedPagesCounter Loader</h1>
        
        <h2>Log Files</h2>    
    <ul>        
<%
        User user=SWBContext.getAdminUser();
       
        if(user==null)
        {
            response.sendError(403);
            return;
        }      
    
    
    String f=request.getParameter("f");
    if(LinkedPageCounter.isLoading())
    {
        out.println("Loadding File....");        
    }else if(f!=null)
    {
        LinkedPageCounter.reset();
        LinkedPageCounter.loadFile(f);
        response.sendRedirect("analyticsLoader.jsp");
        return;
    }else
    {
        File dir=new File(SWBPortal.getWorkPath()+"/logs");
        File files[]=dir.listFiles();
        for(int x=0;x<files.length;x++)
        {
            File file=files[x];
            if(file.getName().indexOf("_acc.")>0)
            {            
%>
        <li><a href="?f=<%=URLEncoder.encode(file.getPath())%>"><%=file.getName()%></a></li>
<%            
            }
        }
    }
%>        
    </ul>
    </body>
</html>
