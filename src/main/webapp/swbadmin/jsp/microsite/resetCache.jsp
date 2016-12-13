<%@page import="java.util.*" %>
<%@page import="org.semanticwb.model.*" %>
<%@page import="org.semanticwb.platform.*" %>
<%@page import="org.semanticwb.portal.community.*" %>
<%-- 
    Document   : testMicrosite
    Created on : 19/11/2009, 03:07:52 PM
    Author     : javier.solis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%
    if("true".equals(request.getParameter("reset")))SemanticObject.clearCache();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Cache</h1>
<%
    out.println("Objectos;"+SemanticObject.getCacheSize());
%>
    </body>
</html>
