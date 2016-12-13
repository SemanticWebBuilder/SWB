<%-- 
    Document   : cluster
    Created on : Jul 12, 2012, 5:57:10 PM
    Author     : serch
--%>

<%@page import="org.semanticwb.base.SWBObserver"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.platform.SWBMessageCenter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String ini=request.getParameter("init");
    if(ini!=null && ini.equals("true"))
    {
        //Eliminar esto cuando se cambie getMessageServer...
        try
        {
            SWBPlatform.getMessageCenter().getMessageServer().stop(new Throwable());
        }catch(Exception noe){};
        SWBPlatform.getMessageCenter().init();
        out.println("Inited...");
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cluster IPs</title>
    </head>
    <body>
        <h1>Cluster IPs</h1>
        <pre>
<%=
SWBPlatform.getMessageCenter().getListAddress()
%>
        </pre>
      Size: <%=
SWBPortal.getMessageCenter().messageSize()

%><br/>
<pre>
<%
Iterator<SWBObserver> iter = SWBPlatform.getMessageCenter().getObservers();
while (iter.hasNext()){
    SWBObserver obs = iter.next();
    
}
%>
        </pre>

    </body>
</html>