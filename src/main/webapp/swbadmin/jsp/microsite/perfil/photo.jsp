<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.platform.*"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>


<%
            User owner = paramRequest.getUser();
            User user = owner;
            WebPage wpage = paramRequest.getWebPage().getWebSite().getWebPage("perfil");
            if (request.getParameter("user") != null)
            {
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                user = (User) semObj.createGenericInstance();
            }   
            


            String photo = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/perfil/profilePlaceholder.jpg";
            if (user.getPhoto() != null)
            {
                photo = SWBPortal.getWebWorkPath() + user.getPhoto();
            }
%>
<br/>
<img src="<%=photo%>" width="150" height="150" alt="<%=user.getFullName()%>" /><br/>
<%if (owner.equals(user))
            {%>
<a class="cambiarFoto" href="<%=wpage.getUrl()%>?changePhoto=1">[cambiar foto]</a>
<%}%>


