<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.SWBPortal"%>

<%
      User user = (User) request.getAttribute("user");
      WebSite website = ((WebPage) request.getAttribute("webpage")).getWebSite();
      User owner=user;
      if (request.getParameter("user") != null && !request.getParameter("user").equals(user.getURI()))
      {
            SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
            user = (User) semObj.createGenericInstance();
      }
      if (request.getParameter("addprospect") != null && request.getParameter("addprospect").equalsIgnoreCase("true"))
      {
        FriendshipProspect.createFriendshipProspect(owner, user, website);
      }
      if (user!=null && user.getURI()!=null && owner!=null && owner.getURI()!=null && !owner.getURI().equals(user.getURI()) && !Friendship.areFriends(owner, user, website) && !FriendshipProspect.findFriendProspectedByRequester(owner, user, website))
      {
         String url = ((WebPage) request.getAttribute("webpage")).getUrl() + "?user=" + user.getEncodedURI() + "&addprospect=true";
        %>
          <li><a href="<%=url%>" >Invitar a <%=user.getFullName()%></a></li>
        <%
      }
%>

            