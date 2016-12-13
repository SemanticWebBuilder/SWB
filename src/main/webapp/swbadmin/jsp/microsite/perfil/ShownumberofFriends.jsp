<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%><%
            User user = (User) request.getAttribute("user");
            WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
            if (request.getParameter("user") != null && !request.getParameter("user").equals(user.getURI()))
            {
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                user = (User) semObj.createGenericInstance();
            }
            else
            {
                if (!user.isSigned())
                {
%>
<li>&nbsp;</li>
<%

                    return;
                }
            }

            Iterator<Friendship> itMyFriends = Friendship.ClassMgr.listFriendshipByFriend(user, site);
            int count = 0;
            while (itMyFriends.hasNext())
            {
                itMyFriends.next();
                count++;
            }
            String url = site.getWebPage("Amigos").getUrl();
            if (request.getParameter("user") != null)
            {
                url += "?user=" + java.net.URLEncoder.encode(request.getParameter("user"));
            }
            String mis_invitacionesURL = site.getWebPage("mis_invitaciones").getUrl();
            if (request.getParameter("user") != null)
            {
                mis_invitacionesURL += "?user=" + java.net.URLEncoder.encode(request.getParameter("user"));
            }
            String mis_solicitudesURL = site.getWebPage("mis_solicitudes").getUrl();
            if (request.getParameter("user") != null)
            {
                mis_solicitudesURL += "?user=" + java.net.URLEncoder.encode(request.getParameter("user"));
            }
%>
<li><a href="<%=url%>" >Amigos (<%=count%>)</a></li>
<%
            if (request.getParameter("user") != null && user.isSigned())
            {
                // muestra si el amigo esta invitado
                user = (User) request.getAttribute("user");
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                User friend = (User) semObj.createGenericInstance();

                Iterator<FriendshipProspect> prospecs = FriendshipProspect.ClassMgr.listFriendshipProspectByFriendShipRequester(user, site);
                boolean invited = false;
                while (prospecs.hasNext())
                {
                    FriendshipProspect propect = prospecs.next();
                    if (propect!=null && propect.getFriendShipRequested()!=null && propect.getFriendShipRequested().getURI()!=null && friend.getURI()!=null && user.getURI()!=null && propect.getFriendShipRequested().getURI().endsWith(friend.getURI()) && propect.getFriendShipRequester().getURI().equals(user.getURI()))
                    {
                        invited = true;
                        break;
                    }
                }
                if (invited)
                {
%>
<li><a href="<%=mis_solicitudesURL%>" >Has invitado a este usuario a ser tu amigo</a></li>
<%                }
                prospecs = FriendshipProspect.ClassMgr.listFriendshipProspectByFriendShipRequested(user, site);
                invited = false;
                while (prospecs.hasNext())
                {
                    FriendshipProspect propect = prospecs.next();
                    if (propect.getFriendShipRequested().getURI().endsWith(user.getURI()) && propect.getFriendShipRequester().getURI().equals(friend.getURI()))
                    {
                        invited = true;
                        break;
                    }
                }
                if (invited)
                {
%>
<li><a href="<%=mis_invitacionesURL%>" >Tienes una invitación de este usuario para ser tu amigo</a></li>
<%                }

            }
%>