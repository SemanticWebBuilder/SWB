<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.portal.social.facebook.Fb_User"%>

<div class="miembros">
<h2 class="titulo">Mis Amigos</h2>
    <%
    Iterator itFriends=((ArrayList)request.getAttribute("aUserData")).iterator();

    Iterator<Fb_User> itusers = itFriends;
    while (itusers.hasNext()) {
        Fb_User user = itusers.next();
        if(user.getPic_with_logo()!=null){
       %>
       <div class="moreUser">
            <a href="<%=user.getProfile_url()%>" target="_new" text-decoration:none><img src="<%=user.getPic_with_logo()%>" width="90" height="90"/></a><br>
            <%if(user.getName()!=null){%> <%=user.getName()%><%}%><br>
            <%if(user.getBirthday()!=null && !user.getBirthday().equals("null")){%> <%=user.getBirthday()%><%}%><br>
            <%if(user.getCity()!=null && !user.getCity().trim().equals("null")){%> <%=user.getCity()%><%}%><br>

            <div class="clear">&nbsp;</div>
       </div>
    <%
        }
     }
    %>
</div>
