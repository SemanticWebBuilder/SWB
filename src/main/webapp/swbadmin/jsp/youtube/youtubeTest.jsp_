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

<%
String username = "george24Infotec@gmail.com";
String password = "george24";
String developerkey = "AI39si4crQ_Zn6HmLxroe0TP48ZDkOXI71uodU9xc1QRyl8Y5TaRc2OIIOKMEatsw9Amce81__JcvvwObue_8yXD2yC6bFRhXA";
String basicPath = "http://gdata.youtube.com/feeds/api/users/";
String feedUploads="/uploads";

 System.out.println("entra a youtube jsp");
if (username == null || password == null || developerkey == null) {
    return;
}

YouTubeService service = new YouTubeService("SEMANTICWEBBUILDER", developerkey);

try {
    service.setUserCredentials(username, password);
} catch (AuthenticationException e) {
    System.out.println("Invalid login credentials jorge.");
}
try{
    String feedUrl = basicPath + "semanticweb1" + feedUploads;
    VideoFeed videoFeed = service.getFeed(new URL(feedUrl), VideoFeed.class);
    for (VideoEntry entry : videoFeed.getEntries()) {
        String videoId=entry.getId();
        int pos=videoId.indexOf("video:");
        if(pos>-1) videoId=videoId.substring(pos+6);
        %>
            <p>
                <object width="225" height="155">
                <param name="movie" value="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1"></param>
                <param name="wmode" value="transparent"></param>
                <embed src="http://www.youtube.com/v/<%=videoId%>&rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="355"></embed>
                </object>
            </p>
            <p><%=entry.getTitle().getPlainText()%></p>
            <p><%=entry.getMediaGroup().getDescription().getPlainTextContent()%></p>
            <p><%=entry.getPublished()%></p>
            <p><%=entry.getUpdated()%></p>
        <%
        //Revisión de estado de los videos
        if(entry.isDraft()) {
          System.out.println("Video is not live");
          YtPublicationState pubState = entry.getPublicationState();
          if(pubState.getState() == YtPublicationState.State.PROCESSING) {
            System.out.println("Video is still being processed.");
          }
          else if(pubState.getState() == YtPublicationState.State.REJECTED) {
            System.out.print("Video has been rejected because: ");
            System.out.println(pubState.getDescription());
            System.out.print("For help visit: ");
            System.out.println(pubState.getHelpUrl());
          }
          else if(pubState.getState() == YtPublicationState.State.FAILED) {
            System.out.print("Video failed uploading because: ");
            System.out.println(pubState.getDescription());
            System.out.print("For help visit: ");
            System.out.println(pubState.getHelpUrl());
          }
        }

        //Recuperar los comentarios de un video
        String commentUrl = entry.getComments().getFeedLink().getHref();
        CommentFeed commentFeed = service.getFeed(new URL(commentUrl), CommentFeed.class);
        for(CommentEntry comment : commentFeed.getEntries()) {
          %><p><%=comment.getPlainTextContent()%></p><%
        }

        //Comentar un video
        //CommentEntry newComment = new CommentEntry();
        //newComment.setContent(new PlainTextConstruct("my api test comment"));
        //service.insert(new URL(commentUrl), newComment);

        //Marcar un video como innadecuado
        //String complaintUrl = entry.getComplaintsLink().getHref();
        //ComplaintEntry complaintEntry = new ComplaintEntry();
        //complaintEntry.setComment("Este video no me agrada, test about youtube java api.");
        //service.insert(new URL(complaintUrl), complaintEntry);


        //Obtener videos relacionados (youtube los relaciona según sus criterios)
        /*
        if (entry.getRelatedVideosLink() != null) {
           feedUrl = entry.getRelatedVideosLink().getHref();

           videoFeed = service.getFeed(new URL(feedUrl), VideoFeed.class);
           for(VideoEntry entry1 : videoFeed.getEntries() ) {
            System.out.println("Title: " + entry1.getTitle().getPlainText());
            System.out.println(entry1.getMediaGroup().getDescription().getPlainTextContent());
           }
        }*/
        //Borrar un video
        //entry.delete();

    }
}catch(Exception e){e.printStackTrace();}
try{
    /* Subir un video
    VideoEntry newEntry = new VideoEntry();
    newEntry.setGeoCoordinates(new GeoRssWhere(37.0,-122.0));
    //alternatively, one could specify just a descriptive string
    newEntry.setLocation("Mountain View, CA");

    YouTubeMediaGroup mg = newEntry.getOrCreateMediaGroup();

    mg.addCategory(new MediaCategory(YouTubeNamespace.CATEGORY_SCHEME, "Autos"));
    mg.addCategory(new MediaCategory(YouTubeNamespace.DEVELOPER_TAG_SCHEME, "xyzzy"));
    mg.setPrivate(false);
    mg.setTitle(new MediaTitle());
    mg.getTitle().setPlainTextContent("testing");
    mg.setKeywords(new MediaKeywords());
    mg.getKeywords().addKeyword("foo");
    mg.setDescription(new MediaDescription());
    mg.getDescription().setPlainTextContent("my description");
    MediaFileSource ms = new MediaFileSource(new File("C:\\jimena.mp4"), "video/quicktime");
    newEntry.setMediaSource(ms);

    String uploadUrl = "http://uploads.gdata.youtube.com/feeds/api/users/semanticweb1/uploads";

    VideoEntry createdEntry = service.insert(new URL(uploadUrl), newEntry);
 * */

    /**Subir un video por forma**/

    VideoEntry newEntry = new VideoEntry();
    newEntry.setGeoCoordinates(new GeoRssWhere(37.0,-122.0));
    
    newEntry.setLocation("Mountain View, CA");
    YouTubeMediaGroup mg = newEntry.getOrCreateMediaGroup();

    mg.addCategory(new MediaCategory(YouTubeNamespace.CATEGORY_SCHEME, "Autos"));
    mg.addCategory(new MediaCategory(YouTubeNamespace.DEVELOPER_TAG_SCHEME, "xyzzy"));
    mg.setTitle(new MediaTitle());
    mg.setPrivate(false);
    mg.getTitle().setPlainTextContent("testing");
    mg.setKeywords(new MediaKeywords());
    mg.getKeywords().addKeyword("foo");
    mg.setDescription(new MediaDescription());
    mg.getDescription().setPlainTextContent("my description");


    URL uploadUrl = new URL("http://gdata.youtube.com/action/GetUploadToken");
    FormUploadToken token = service.getFormUploadToken(uploadUrl, newEntry);
%>
    <form action="?nexturl=http://localhost:8080/swb/Ciudad_Digital_2/youtube" method ="post" enctype="multipart/form-data">
        <input type="file" name="file"/>
        <input type="hidden" name="token" value=""/>
        <input type="submit" value="subir a youtube" />
    </form>

<%
     //Recuperar listas de reproducción de un usuario

     String feedUrl = "http://gdata.youtube.com/feeds/api/users/default/playlists";
     PlaylistLinkFeed feed = service.getFeed(new URL(feedUrl), PlaylistLinkFeed.class);
     for(PlaylistLinkEntry entry : feed.getEntries()) {
      System.out.println("Title: " + entry.getTitle().getPlainText());
      System.out.println("Description: " + entry.getDescription());

      if(entry.getFeedUrl()!=null){
          String playlistUrl = entry.getFeedUrl();
          PlaylistFeed playlistFeed = service.getFeed(new URL(playlistUrl), PlaylistFeed.class);
          for(PlaylistEntry playlistEntry : playlistFeed.getEntries()) {
              System.out.println("Title: " + playlistEntry.getTitle().getPlainText());
              System.out.println("Description: " + playlistEntry.getDescription());
              System.out.println("Position: " + playlistEntry.getPosition());
              System.out.println("Video URL: " + playlistEntry.getHtmlLink().getHref());
          }
      }
    }

    //**Crear una lista de reproducción (Podria crear una lista de reprodccuón por comunidad creada y ahi se guardarian todos los videos de la misma)
    //feedUrl = "http://gdata.youtube.com/feeds/api/users/semanticweb1/playlists";
    //PlaylistLinkEntry newEntry = new PlaylistLinkEntry();
    //newEntry.setTitle(new PlainTextConstruct("Lista 2 desde api"));
    //newEntry.setDescription("Mi segunda lista de reprodcción (esta fue creada desde la api)");
    //newEntry.setSummary(new PlainTextConstruct("Summary de Jorge Jiménez"));
    //PlaylistLinkEntry createdEntry = service.insert(new URL(feedUrl), newEntry);
    


 }catch(Exception e){e.printStackTrace();}

 %>





