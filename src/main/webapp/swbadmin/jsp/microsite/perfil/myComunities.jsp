<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%
    if(request.getParameter("user")!=null)
    {
        return;
    }
%>
<div id="contactos">
  <h2>Mis Subscripciones</h2>
  <ul>
<%
User user=paramRequest.getUser();

String lang="es";
if(user.getLanguage()!=null) lang=user.getLanguage();
Iterator<Member> itMember=Member.ClassMgr.listMemberByUser(user);
while(itMember.hasNext()){
    Member member=itMember.next();
    MicroSite microsite=member.getMicroSite();
    %>
        <li><a href="<%=microsite.getUrl()%>">microsite.getTitle(lang)</a></li>
    <%
}
%>
  </ul>
</div>

