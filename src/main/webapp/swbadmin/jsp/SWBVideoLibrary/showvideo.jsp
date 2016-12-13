<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.videolibrary.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.User"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%

    String usrlanguage = paramRequest.getUser().getLanguage();
    Locale locale=new Locale(usrlanguage);
    Calendar calendar = Calendar.getInstance(locale);
    DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));
    VideoContent content=(VideoContent)request.getAttribute("content");
    String title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle(usrlanguage));
    if(title!=null && title.trim().equals(""))
    {
        title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle());
    }

    String originaltitle=SWBUtils.TEXT.encodeExtendedCharacters(content.getOriginalTitle());
    if(originaltitle==null || originaltitle.trim().equals(""))
    {
        originaltitle=SWBUtils.TEXT.encodeExtendedCharacters(content.getOriginalTitle());
    }

    String date="";
    if(content.getPublishDate()!=null)
    {
        date=sdf.format(content.getPublishDate());
    }
    String duration="";
    try
    {
        duration=SWBUtils.TEXT.encodeExtendedCharacters(String.valueOf(content.getDuration()));
        if(duration!=null && duration.trim().equals(""))
        {
            duration=SWBUtils.TEXT.encodeExtendedCharacters(String.valueOf(content.getDuration()));
        }
    }
    catch(Exception e){}
    String code="";
    if(content.getCode()!=null)
    {
        code=content.getCode();
        code=code.replace("/", "\\/");
    }
    SWBResourceURL urlall=paramRequest.getRenderUrl();
    urlall.setMode(urlall.Mode_VIEW);
    urlall.setCallMethod(urlall.Call_CONTENT);
    String source=content.getSource();
    content.getResourceBase().incViews();
    
%>
<div class="columnaIzquierda">
    <br/>
    <script type="text/javascript">
            <!--
            document.write('<%=code%>');
            -->
        </script>

    <br/>

</div>
<div class="columnaCentro">
    <h2 class="blogTitle">
    <script type="text/javascript">
            <!--
            document.write('<%=title%>');
            -->
        </script></h2><br/>
        <%
        if(originaltitle!=null && !originaltitle.equals(""))
        {
            %>
            <p>Título original: <script type="text/javascript">
            <!--
            document.write('<%=originaltitle%>');
            -->
        </script></p>
            <%
        }

    %>
        <%
            if(date!=null && !date.equals(""))
            {
                %>
                <p>Creado el: <%=date%></p>
                <%
            }
        %>
        <%
            if(duration!=null && !duration.equals(""))
            {
                %>
                <p>Duración : <%=duration%></p>
                <%
            }
        %>
        <%
            if(source!=null)
            {
                if(content.getVideoWebPage()==null)
                {
                    %>
                    <p>Fuente: <%=source%></p>
                    <%
                }
                else
                {
                    String urlsource=content.getVideoWebPage();
                    urlsource=urlsource.replace("&", "&amp;");
                    %>
                    <p>Fuente: <a target="_blank" href="<%=urlsource%>"><%=source%></a></p>
                    <%
                }
            }
        %>
    
    <%
        if(content.getTags()!=null)
        {
            String tags=SWBUtils.TEXT.encodeExtendedCharacters(content.getTags());
            %>
            <p>Etiquetas: <script type="text/javascript">
            <!--
            document.write('<%=tags%>');
            -->
        </script></p>
            <%
        }
    
        String viewAll="[Ver todos los videos]";
        /*if(paramRequest.getUser().getLanguage()!=null && !paramRequest.getUser().getLanguage().equalsIgnoreCase("es"))
        {
            viewAll="[View all videos]";
        }*/
    %>
        
    <p><a href="<%=urlall%>"><%=viewAll%></a></p>


</div>

