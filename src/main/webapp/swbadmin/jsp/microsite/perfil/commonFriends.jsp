<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.SWBPortal"%>

<%
        WebPage wpage=paramRequest.getWebPage();
        WebSite wsite=wpage.getWebSite();
        User owner = paramRequest.getUser();
        User user = owner;
        if (request.getParameter("user") != null) {
            SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
            user = (User) semObj.createGenericInstance();
        }
        if (owner == user) {
            return;
        }

        ArrayList aOwnerFriends=new ArrayList();
        Iterator<Friendship> itOwnerFriends = Friendship.ClassMgr.listFriendshipByFriend(owner, wsite);
        while (itOwnerFriends.hasNext()) {
            Friendship friendship = itOwnerFriends.next();
            Iterator<User> itfriendUser = friendship.listFriends();
            while (itfriendUser.hasNext()) {
                User friendUser = itfriendUser.next();
                if (!friendUser.getURI().equals(owner.getURI()) && !friendUser.getURI().equals(user.getURI())) {
                    aOwnerFriends.add(friendUser);
                }
            }
        }

        ArrayList acommonFriends=new ArrayList();
        Iterator<Friendship> itUserFriends = Friendship.ClassMgr.listFriendshipByFriend(user, wsite);
        while (itUserFriends.hasNext()) {
            Friendship friendship = itUserFriends.next();
            Iterator<User> itfriendUser = friendship.listFriends();
            while (itfriendUser.hasNext()) {
                User friendUser = itfriendUser.next();
                if (!friendUser.getURI().equals(owner.getURI()) && !friendUser.getURI().equals(user.getURI())) {
                    if(aOwnerFriends.contains(friendUser)){
                        acommonFriends.add(friendUser);
                    }
                }
            }
        }
        %>
        <div class="miembros">
            <h2>Amigos en común</h2>
            <%
            String imgSize="width=\"80\" height=\"70\"";;
            boolean isStrategy=false;
            if (paramRequest.getCallMethod() == paramRequest.Call_STRATEGY)
            {
                isStrategy=true;
                imgSize="width=\"39\" height=\"39\"";
            }
            String photo=SWBPortal.getContextPath()+"/swbadmin/images/defaultPhoto.jpg";
            String firstName="", lastName="";
            int contTot=0;
            Iterator <User>itCommonFriends=acommonFriends.iterator();
            while(itCommonFriends.hasNext()){
                User commonfriend=itCommonFriends.next();
                if(commonfriend.getPhoto()!=null) photo=commonfriend.getPhoto();
                if(commonfriend.getFirstName()!=null) firstName=commonfriend.getFirstName();
                if(commonfriend.getLastName()!=null) lastName=commonfriend.getLastName();
                  %>
                    <div class="moreUser">
                        <a href="<%=wsite.getWebPage("perfil").getUrl()%>?user=<%=commonfriend.getEncodedURI()%>"><img src="<%=SWBPortal.getWebWorkPath()+photo%>" <%=imgSize%> title="<%=firstName%> <%=lastName%>"/>
                    <%if(!isStrategy){%>
                        <br/>
                        <%=firstName%>
                        <%=lastName%>
                    <%}%>
                    </a>
                     </div>
                     <%
                     contTot++;
                     if(isStrategy && contTot==18) break;

            }
            if(isStrategy && contTot>=18){%>
                 <div class="clear">
                    <p class="vermas"><a href="<%=wsite.getWebPage("Amigos_en_Comun").getUrl()%>" >Ver todos</a></p>
                 </div>
             <%}else if(contTot==0){%>
               <div class="clear">
                <p class="titulo">Aún no tienen amigos en común</p>
               </div>
             <%}%>
             <div class="clear"></div>
          </div>

