<%@page import="org.semanticwb.model.*"%><%@page import="org.semanticwb.portal.community.*"%><%@page import="org.semanticwb.model.WebPage"%><%@page import="java.util.*"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.platform.*"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%
User owner=(User)request.getAttribute("user");
User user=owner;
if(owner!=null && request.getParameter("user")!=null && !request.getParameter("user").equals(user.getURI()))
{
    SemanticObject semObj=SemanticObject.createSemanticObject(request.getParameter("user"));
    user=(User)semObj.createGenericInstance();
}%><%=user.getFullName()%>
