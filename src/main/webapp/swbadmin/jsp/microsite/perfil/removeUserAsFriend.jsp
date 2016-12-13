<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.SWBPortal"%>

<%
            WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
            User owner = (User) request.getAttribute("user");
            if (owner == null)
            {
                return;
            }
            User user = owner;
            if (request.getParameter("user") != null && !request.getParameter("user").equals(user.getURI()))
            {
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                user = (User) semObj.createGenericInstance();
            }
            if (owner == null || user == null)
            {
                return;
            }
            boolean areFriends = false;

            if (owner != null && user != null && owner.getURI()!=null && user.getURI()!=null && !owner.getURI().equals(user.getURI()) && Friendship.areFriends(owner, user, site))
            {
                areFriends = true;
            }

            boolean friendRemoved = false;

            if (areFriends && request.getParameter("removeFriend") != null && request.getParameter("removeFriend").equalsIgnoreCase("true"))
            {
                friendRemoved = Friendship.removeFriendRelationShip(owner, user, site);
            }

            if (areFriends && !friendRemoved)
            { //Si el usuario que esta en session(owner) es diferente que el que vino por parametro (user)
                String url = ((WebPage) request.getAttribute("webpage")).getUrl() + "?user=" + user.getEncodedURI() + "&removeFriend=true";
%>
<li><a href="<%=url%>" >Eliminar a <%=user.getFullName()%> como amigo</a></p>
    <%
            }
    %>
