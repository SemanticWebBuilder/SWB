<%@page import="org.semanticwb.SWBPortal" %><%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    String sAttr="cs";
    if(request.getParameter("sAttr")!=null) sAttr=request.getParameter("sAttr");
    SWBPortal.UTIL p = new SWBPortal.UTIL();
    p.sendValidateImage(request, response, sAttr, 4,  null);
%>