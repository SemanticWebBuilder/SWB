<%-- 
    Document   : importTriples
    Created on : 12-jul-2012, 14:13:06
    Author     : javier.solis.g
--%>

<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
<%
    String smodel=request.getParameter("model");
    if(smodel==null)return;
    WebSite site=SWBContext.getWebSite(smodel);
    FileInputStream in=new FileInputStream(SWBUtils.getApplicationPath()+"/swbutil/"+smodel+".nt");
    site.getSemanticModel().getRDFModel().read(in, null, "N-TRIPLE");
    in.close();
    out.println("OK");
%>        
    </body>
</html>
