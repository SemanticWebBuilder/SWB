<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.portal.social.facebook.Fb_Photo"%>


<div class="miembros">
<h2 class="titulo">Mis Amigos</h2>
<%
    Iterator itPhotos=((ArrayList)request.getAttribute("aPhotos")).iterator();

    Iterator<Fb_Photo> itusers = itPhotos;
    while (itusers.hasNext()) {
        Fb_Photo photo = itusers.next();
       %>
       <div class="moreUser">
            <a href="<%=photo.getLink()%>" target="_new" text-decoration:none><img src="<%=photo.getSrc()%>" width="90" height="90"></a><br>
       <%
        if (photo.getCaption() != null) {
        %>
            <div class="titulo"><%=photo.getCaption()%></div>
        <%}%>
         <div class="clear">&nbsp;</div>         
       </div>       
    <%}%>
</div>
