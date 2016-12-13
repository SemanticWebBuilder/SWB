<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="com.google.gdata.util.AuthenticationException"%>
<%@page import="com.google.gdata.client.*"%>
<%@page import="com.google.gdata.client.youtube.*"%>
<%@page import="com.google.gdata.data.*"%>
<%@page import="com.google.gdata.data.geo.impl.*"%>
<%@page import="com.google.gdata.data.youtube.*"%>
<%@page import="com.google.gdata.data.extensions.*"%>
<%@page import="com.google.gdata.util.*"%>
<%@page import="com.google.gdata.data.media.*"%>
<%@page import="com.google.gdata.data.media.mediarss.*"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.net.URL"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>

<%
String action=paramRequest.getAction();
SWBResourceURL url=paramRequest.getRenderUrl();
SWBResourceURL urlAction=paramRequest.getActionUrl();
YouTubeService service = (YouTubeService)request.getAttribute("service");
if(action.equals("uploadVideo")){
    urlAction.setAction("setPlayList");
    String videoId=request.getParameter("videoId");
    System.out.println("videoId en jsp:"+videoId);
    urlAction.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/videos/"+videoId);
    String tokenUrl=request.getParameter("tokenUrl");
    String token=request.getParameter("token");
    if(tokenUrl!=null && token!=null){
 %>
    <form action="<%=tokenUrl%>?nexturl=http://localhost:8080<%=urlAction%>" method ="post" enctype="multipart/form-data">
        <ul>
        <input type="file" name="file"/>
        <input type="hidden" name="token" value="<%=token%>"/>
        <input type="submit" value="subir a youtube" />
        </ul>
    </form>
 <%
    }
}else if(action.equals("newVideo")){    
%>
    <form action="<%=urlAction.setAction("uploadVideo")%>">
        <ul>
            <li>Título:<input type="text" name="title"></li>
            <li>Descripción:<input type="text" name="description"></li>
            <li>Palabras clave:<input type="text" name="keywords"></li>
            <li><input type="submit" value="enviar"></li>
        </ul>
    </form>
<%
}else if(action.equals("comment") || action.equals("spam")){
    String entryUrl=request.getParameter("entryUrl");
    urlAction.setAction(action);
    urlAction.setParameter("entryUrl", entryUrl);
    %>
        <form action="<%=urlAction%>" method="post">
            <fieldset>
            <legend>Comentario</legend>
            <ul>
                <p>Comentario:<input type="text" name="comment"/></p>
                <p><input type="submit" value="enviar"/></p>
            </ul>
            </fieldset>
        </form>
    <%
}else if(action.equals("detail")){
     String entryUrl=request.getParameter("entryUrl");
     VideoEntry videoEntry = service.getEntry(new URL(entryUrl), VideoEntry.class);

}else if(action.equals("showAll")){
    try{
     String feedUrl = "http://gdata.youtube.com/feeds/api/playlists/D2C26D097ECEAB44?v=2";
     PlaylistFeed feed = service.getFeed(new URL(feedUrl), PlaylistFeed.class);
     for(PlaylistEntry entry : feed.getEntries()) {
         //System.out.println("entry:"+entry.getId());
     String videoId=entry.getHtmlLink().getHref();
     //System.out.println("videoId:"+videoId);
     int pos=videoId.indexOf("v=");
     if(pos>-1) videoId=videoId.substring(pos+2);
     pos=videoId.indexOf("&");
     if(pos>-1) videoId=videoId.substring(0,pos);
     //System.out.println("youtube videoId:"+videoId);
     %>
        <div class="moreUser">
            <object width="225" height="155">
            <param name="movie" value="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1"></param>
            <param name="wmode" value="transparent"></param>
            <embed src="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="355"></embed>
            </object>
            <p><%=entry.getTitle().getPlainText()%></p>
            <p><%=entry.getMediaGroup().getDescription().getPlainTextContent()%></p>
            <p><%=entry.getPublished()%></p>
            <p><%=entry.getUpdated()%></p>

            <%url.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/videos/"+videoId);url.setAction("detail");%><p><a href="<%=url%>">detalle</a> |
            <%url.setAction("comment");%><a href="<%=url%>">comentar</a> |
            <%url.setAction("spam");%><a href="<%=url%>">spam</a> |
            <%urlAction.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/videos/"+videoId);urlAction.setAction("favorite");%><a href="<%=urlAction%>">favorito</a> |
            <%urlAction.setAction("delete");%><a href="<%=urlAction%>">eliminar</a>
            <%
             //Recuperar los comentarios de un video
            int cont=0;
            String commentUrl = entry.getComments().getFeedLink().getHref();
            CommentFeed commentFeed = service.getFeed(new URL(commentUrl), CommentFeed.class);
            for(CommentEntry comment : commentFeed.getEntries()) {
              cont++;
              %><p><%=comment.getPlainTextContent()%></p><%
              if(cont>=5) break;
            }
            %>
        </div>
<%
    }
   }catch(Exception e){e.printStackTrace();}
}else {   
%>
 <div class="miembros">
     <%url.setAction("newVideo");%>
     <p><a href="<%=url%>">nuevo video</a></p>
<%
try{
    
     //TODO(Tengo que barrerme aqui todos lo videos (ids regresados por youtube) que tengo en el Resource.getData()
     //y agregarlos a la Lista de reproducción que le corresponda, si lo hace bien, eliminar los mismos del mismo Resource.getData()
     //String entryUrl="http://gdata.youtube.com/feeds/api/videos/kfBFXro7njM";
     //VideoEntry videoEntry = service.getEntry(new URL(entryUrl), VideoEntry.class);
     //String feedUrl = "http://gdata.youtube.com/feeds/api/playlists/D2C26D097ECEAB44?v=2";
     //PlaylistEntry playlistEntry = new PlaylistEntry(videoEntry);
     //service.insert(new URL(feedUrl), playlistEntry);

     String feedUrl = "http://gdata.youtube.com/feeds/api/users/default/favorites";
     VideoFeed videoFeed = service.getFeed(new URL(feedUrl), VideoFeed.class);
     for(VideoEntry entry : videoFeed.getEntries()) {
        String videoId=entry.getHtmlLink().getHref();
        int pos=videoId.indexOf("v=");
        if(pos>-1) videoId=videoId.substring(pos+2);
        String sid=entry.getId();
        pos=-1;pos=sid.indexOf("favorite:");
        if(pos>-1) sid=sid.substring(pos+9);
     %>
            <div class="moreUser">
                <object width="225" height="155">
                <param name="movie" value="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1"></param>
                <param name="wmode" value="transparent"></param>
                <embed src="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="355"></embed>
                </object>
                <p><%=entry.getTitle().getPlainText()%></p>
                <p><%=entry.getMediaGroup().getDescription().getPlainTextContent()%></p>
                <p><%=entry.getPublished()%></p>
                <p><%=entry.getUpdated()%></p>
                
                <%url.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/videos/"+videoId);url.setAction("detail");%><p><a href="<%=url%>">detalle</a> |
                <%url.setAction("comment");%><a href="<%=url%>">comentar</a> |
                <%url.setAction("spam");%><a href="<%=url%>">spam</a> |
                <%urlAction.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/users/default/favorites/"+sid);urlAction.setAction("unfavorite");%><a href="<%=urlAction%>">Eliminar de los favoritos</a> |
                <%urlAction.setParameter("entryUrl", "http://gdata.youtube.com/feeds/api/videos/"+videoId);urlAction.setAction("delete");%><a href="<%=urlAction%>">eliminar</a>
                <%
                 //Recuperar los comentarios de un video
                int cont=0;
                String commentUrl = entry.getComments().getFeedLink().getHref();
                CommentFeed commentFeed = service.getFeed(new URL(commentUrl), CommentFeed.class);
                for(CommentEntry comment : commentFeed.getEntries()) {
                  cont++;
                  %><p><%=comment.getPlainTextContent()%></p><%
                  if(cont>=5) break;
                }
                %>
            </div>
<%
    }
}catch(Exception e){e.printStackTrace();}
%>
</div>
 <div class="miembros">
  <p><a href="<%=url.setAction("showAll")%>">Ver todos</a></p>
 </div>
<%
}
%>
