<%@page import="org.semanticwb.SWBPortal" %><%
  SWBPortal.UTIL p = new SWBPortal.UTIL();
  p.sendValidateImage(request, response, "cs", 4,  null);
%>