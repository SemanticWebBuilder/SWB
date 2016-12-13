 <%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
 <%@page import="com.google.code.facebookapi.FacebookXmlRestClient"%>
 <%@page import="com.google.code.facebookapi.IFacebookRestClient"%>
 <%@page import="com.google.code.facebookapi.TemplatizedAction"%>
 <%@page import="com.google.code.facebookapi.Permission"%>
 <%@page import="com.google.code.facebookapi.FeedImage"%>
 <%@page import="com.google.code.facebookapi.IFeedImage"%>
 <%@page import="org.w3c.dom.Document"%>
 <%@page import="org.semanticwb.*"%>
 <%@page import="java.util.*"%>
 <%@page import="java.io.*"%>
 <%@page import="java.net.URL"%>

 <%
     IFacebookRestClient<Document> userClient = getUserClient(session);
     if (userClient != null) {
        String api_key=userClient.getApiKey();
        String secret_key=userClient.getSecret();
        if(userClient.users_hasAppPermission(Permission.STATUS_UPDATE))
        {
            System.out.println("entra a mandar");
            HashMap map = new HashMap();
            map.put("commentamelo","<a href=\"http://www.webbuilder.org.mx\">hola-2</a>");
            //URL urlImage=new URL("http://www.webbuilder.org.mx/OS/work/sites/COSWB/templates/14/3/semanticwebbuilder.jpg");
            //URL urlLink=new URL("http://www.webbuilder.org.mx");
            URL urlImage=new URL("http","www.webbuilder.org.mx","/OS/work/sites/COSWB/templates/14/3/semanticwebbuilder.jpg");
            URL urlLink=new URL("http://www.webbuilder.org.mx");

            FeedImage image = new FeedImage(urlImage, urlLink);
	        ArrayList<IFeedImage> images = new ArrayList<IFeedImage>();
	        images.add(image);
            HashMap map1 = new HashMap();
            map1.put("src", "http://www.webbuilder.org.mx/OS/work/sites/COSWB/templates/14/3/semanticwebbuilder.jpg");
            map1.put("href", "http://www.webbuilder.org.mx");
            map.put("images", images);

            ArrayList<Long> target_ids = new ArrayList<Long>();
            target_ids.add(new Long("1826241626"));

            userClient.feed_publishUserAction(new Long("137386010688"),map,images, target_ids, "Esta es una prueba de texto largo", 200);
            //Página para dar de alta templates:http://developers.facebook.com/tools.php?feed
            //Poner el número de plantilla talvez en el web.properties para que pueda ser obtenido x todos los recursos facilmente

            File file=new File("C:/semanticwebbuilder.jpg");
            Document dom=userClient.photos_upload(file);
            System.out.println("dom:"+SWBUtils.XML.domToXml(dom));
        }
     }

  %>


<%!
     static FacebookXmlRestClient getUserClient(HttpSession session) {
            return (FacebookXmlRestClient) session.getAttribute("facebook.user.client");
     }
%>



