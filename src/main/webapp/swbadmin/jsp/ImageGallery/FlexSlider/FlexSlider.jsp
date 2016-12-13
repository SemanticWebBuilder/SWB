<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.util.List"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    List<String> imagenes = (List<String>) request.getAttribute("images");
    List<String> thumbnails = (List<String>) request.getAttribute("thumbnails");
    List<String> descriptions = (List<String>) request.getAttribute("descriptions");
    String pathJS = SWBPortal.getContextPath() + "/swbadmin/jsp/ImageGallery/FlexSlider/js/";
    String pathIMG = SWBPortal.getContextPath() + "/swbadmin/jsp/ImageGallery/FlexSlider/images/";
    String pathCSS = SWBPortal.getContextPath() + "/swbadmin/jsp/ImageGallery/FlexSlider/css/";
    boolean autoplay = Boolean.valueOf(paramRequest.getResourceBase().getAttribute("autoplay", "false"));
    int autoPlayInterval = Integer.parseInt(paramRequest.getResourceBase().getAttribute("pause", "2500"));
    int slideDuration = Integer.parseInt(paramRequest.getResourceBase().getAttribute("fadetime", "500"));
    String title = paramRequest.getResourceBase().getTitle(paramRequest.getUser().getLanguage());
    if (title == null)
    {
        title = paramRequest.getResourceBase().getTitle();
    }
    if (title == null)
    {
        title = "";
    }
    boolean showTitle = Boolean.parseBoolean(paramRequest.getResourceBase().getAttribute("title", "false"));
    if (showTitle)
    {
%>
<h1><%=title%></h1>
<%
    }
%>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<!-- Demo CSS -->
<link rel="stylesheet" href="<%=pathCSS%>demo.css" type="text/css" media="screen" />
<link rel="stylesheet" href="<%=pathCSS%>flexslider.css" type="text/css" media="screen" />





<div id="slider" class="flexslider">
    <div class="slides">
        <%
            int i = 0;
            for (String image : imagenes)
            {
                String thumb = thumbnails.get(i);
                String description = descriptions.get(i);
                i++;
        %>
        <div data-thumb="<%=thumb%>">
            <img src="<%=image%>" />
            <%
                if (!description.isEmpty())
                {
                    description=SWBUtils.TEXT.encodeExtendedCharacters(description);
            %>
            <div class="slideDescription"><%=description%></div>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
</div>






<!-- jQuery -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="<%=pathJS%>libs/jquery-1.7.min.js">\x3C/script>')</script>

<!-- FlexSlider -->
<script defer src="<%=pathJS%>jquery.flexslider.js"></script>

<script type="text/javascript">
    $(window).load(function() {
        $('.flexslider').flexslider({
            animation: "slide",
            controlNav: "thumbnails",
            slideshowSpeed: <%=autoPlayInterval%>,
            animationLoop: true,
            slideshow: <%=autoplay%>,
            animationSpeed: <%=slideDuration%>,
            selector: ".slides > div",
        });
    });
</script>




<!-- Optional FlexSlider Additions -->
<script src="<%=pathJS%>jquery.easing.js"></script>
<script src="<%=pathJS%>jquery.mousewheel.js"></script>
<script defer src="<%=pathJS%>demo.js"></script>


