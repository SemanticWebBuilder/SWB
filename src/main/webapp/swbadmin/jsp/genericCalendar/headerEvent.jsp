<%-- 
    Document   : ArticleHeader
    Created on : 3/02/2011, 04:55:47 PM
    Author     : jose.jimenez
    Muestra el encabezado de los eventos. Consta del título, descripción, foto y pie de foto.
--%><%@page import="org.semanticwb.portal.resources.sem.genericCalendar.*"
%><%@page import="org.semanticwb.model.*"
%><%@page import="java.util.*"
%><%@page import="java.text.*"
%><%@page import="org.semanticwb.*"
%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/><%
WebPage wp = paramRequest.getWebPage();
String usrLang = paramRequest.getUser().getLanguage();
String title = null;
String description = null;
//Uso de redes sociales
/*String elementURL = "http://" + request.getServerName()
        + (request.getServerPort() != 80 ? ":" + request.getServerPort() : "");
String facebookLang = null;
String twitterLang = null;*/
//String usrCountry = paramRequest.getUser().getCountry();
String imgPath = null;
String validThrough = null;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sdf2Show = new SimpleDateFormat("dd/MM/yyyy");
String id = request.getParameter("id");
//Para conocer el lenguage del país y redireccionar el face/twitter
/*if (usrLang == null) {
    usrLang = "es";
}
if (usrCountry == null) {
    usrCountry = "mx";
}*/
if (id != null) {
        Event e = Event.ClassMgr.getEvent(id, wp.getWebSite());
        title = e.getDisplayTitle(usrLang);
        description = e.getDisplayDescription(usrLang);
        //elementURL = elementURL + wp.getRealUrl(usrLang) + "?id=" + id; //Uso de redes sociales
        imgPath = e.getMainImage();
        if (e.getEventInitDate() != null) {
            Date start = sdf.parse(e.getEventInitDate().substring(0, 10));
            Date ending = e.getEventEndDate() != null ? sdf.parse(e.getEventEndDate().substring(0, 10)) : null;
            validThrough = sdf2Show.format(start) + (ending != null ? " - " + sdf2Show.format(ending) : "");
        }
        
        if (imgPath != null) {
            imgPath = SWBPortal.getWebWorkPath() + e.getWorkPath() + "/"
                        + Event.genCal_mainImage.getName() + "_" + e.getId() + "_"
                        + imgPath;
        }
        if (title == null) {
            title = e.getTitle();
        }
        if (description == null) {
            description = e.getDescription() != null ? e.getDescription() : "";
        }

/* Para utilizar tweter y face */
/*if (usrLang.equalsIgnoreCase("es")) {
    if (!usrCountry.equalsIgnoreCase("es")) {
        facebookLang = usrLang + "_LA";
    } else {
        facebookLang = usrLang + "_ES";
    }
    twitterLang = usrLang;
} else if (usrLang.equalsIgnoreCase("en")) {
    if (!usrCountry.equalsIgnoreCase("gb")) {
        facebookLang = usrLang + "_US";
    } else {
        facebookLang = usrLang + "_GB";
    }
    twitterLang = "";
} else if (usrLang.equalsIgnoreCase("fr")) {
    if (usrCountry.equalsIgnoreCase("ca")) {
        facebookLang = usrLang + "_CA";
    } else { //para Francia
        facebookLang = usrLang + "_FR";
    }
    twitterLang = usrLang;
} else if (usrLang.equalsIgnoreCase("de")) {
    facebookLang = usrLang + "_DE";
    twitterLang = usrLang;
} else if (usrLang.equalsIgnoreCase("it")) {
    facebookLang = usrLang + "_IT";
    twitterLang = usrLang;
} else if (usrLang.equalsIgnoreCase("ja")) {
    facebookLang = usrLang + "_JP";
    twitterLang = usrLang;
} else if (usrLang.equalsIgnoreCase("pt")) {
    facebookLang = usrLang + "_BR";
    twitterLang = "";
} else if (usrLang.equalsIgnoreCase("zh")) {
    facebookLang = usrLang + "_CN";
    twitterLang = "";
}*/

%>  <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/css/genericCalendar.css" rel="stylesheet" type="text/css" />
    <div id="cabecera-contenido">
<%if (imgPath != null) {%>
            <div class="fotoPrincipal">
                <img src="<%=imgPath%>" width="430" height="310" />
            </div>
<%}%>
            <div class="cabeceraEvt"<%=(imgPath == null) ? " style=\"float:left; width: auto\"" : ""%>>
                <div class="top">
                    <h1><%=title%></h1>
                    <h2><%=description%></h2>
                    <%if (validThrough != null) {%>
                    <h3><%=validThrough%></h3>
                    <%}%>
                    <!--div class="tweet">
                        <script type="text/javascript">
                            tweetmeme_url = 'http://www.visitmexico.com/cancun';
                        </script>
                        <script type="text/javascript" src="http://tweetmeme.com/i/scripts/button.js"></script>
                        <a href="http://twitter.com/share" class="twitter-share-button" data-url="<%--=elementURL--%>" data-text="<%--=title--%>" data-count="vertical" data-lang="<%--=twitterLang--%>">Tweet</a>
                        <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
                    </div-->
                    <!--div class="face">
                        <script type="text/javascript" src="http://connect.facebook.net/<%--=facebookLang--%>/all.js#xfbml=1"></script>
                        <fb:like href="<%--=elementURL--%>" show_faces="false" width="220" font="tahoma"></fb:like>
                    </div-->
                </div>
            </div>
        </div>
<%}%>
