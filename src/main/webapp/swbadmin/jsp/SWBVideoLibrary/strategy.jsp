<%@page import="org.semanticwb.model.Resourceable"%>
<%@page import="org.semanticwb.model.GenericObject"%>
<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.videolibrary.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="org.semanticwb.model.WebPage"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
    //String idPage="Videos";
    class VideoContentComparator implements Comparator<VideoContent>
    {

        public int compare(VideoContent o1, VideoContent o2)
        {
            try
            {
                return o1.getResourceBase().getIndex() >= o2.getResourceBase().getIndex() ? 1 : -1;
            }
            catch (Exception e)
            {
            }
            return 0;
        }
    }
%>
<%
    String usrlanguage = paramRequest.getUser().getLanguage();
    SWBVideoLibrary library = (SWBVideoLibrary) request.getAttribute("library");
    String titleSection = library.getResourceBase().getDisplayTitle(usrlanguage);
    if (titleSection == null || titleSection.trim().equals(""))
    {
        titleSection = SWBUtils.TEXT.encodeExtendedCharacters(library.getResourceBase().getDisplayTitle(usrlanguage));
    }
    String descriptionSection = library.getResourceBase().getDescription(usrlanguage);
    if (descriptionSection == null || descriptionSection.trim().equals(""))
    {
        descriptionSection = SWBUtils.TEXT.encodeExtendedCharacters(library.getResourceBase().getDescription());
    }
%>
<div class="bloqueVideos">
    <h2 class="tituloBloque"><%=titleSection%><span class="span_tituloBloque"> <%=descriptionSection%></span></h2>
    <%
        //WebPage wp= paramRequest.getWebPage().getWebSite().getWebPage(idPage);    
        WebPage wp = null;
        Resourceable resourceable = library.getResourceBase().getResourceable();
        if (resourceable instanceof WebPage)
        {
            wp = (WebPage) resourceable;
        }
        if (wp != null && wp.isActive())
        {
            SWBResourceURL urldetail = null;
            GenericIterator<Resource> resources = wp.listResources();
            while (resources.hasNext())
            {
                Resource resource = resources.next();
                if (resource.getResourceData() != null)
                {
                    ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setResourceBase(resource);
                    ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setVirtualResource(resource);
                    ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setTopic(wp);
                    urldetail = paramRequest.getRenderUrl();
                    urldetail.setMode(paramRequest.Mode_VIEW);
                }
            }

            //DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));
            int limit = 5;
            ArrayList<VideoContent> contentsToShow = new ArrayList<VideoContent>();
            List<VideoContent> contents = (List<VideoContent>) request.getAttribute("list");
            Collections.sort(contents, new VideoContentComparator());
            if (urldetail != null)
            {
                int i = 0;
                for (VideoContent content : contents)
                {
                    if (content.isHomeShow())
                    {
                        contentsToShow.add(content);
                        if (i >= limit)
                        {
                            break;
                        }
                    }
                }
                boolean hasVideos = false;
                if (contentsToShow.size() > 0)
                {
                    hasVideos = true;
                }
                i = 1;
                contents = contentsToShow;
                String viewAll = "Sección completa de videos";
                if (paramRequest.getUser().getLanguage() != null && paramRequest.getUser().getLanguage().equalsIgnoreCase("en"))
                {
                    viewAll = "View all videos";
                }
                if (contentsToShow.size() > 0)
                {
                    String code = "";
                    if (contentsToShow.get(0).getCode() != null)
                    {
                        code = contentsToShow.get(0).getCode();
                    }
                    code = code.replace("/", "\\/");
    %>
    <script type="text/javascript">
        <!--
    document.write('<%=code%>');
-->
    </script>
    <%
            contentsToShow.remove(0);
        }
        if (contentsToShow.size() > 0)
        {

    %>
    <div id="listadoVideos">
        <ul>
            <%                    for (VideoContent content : contentsToShow)
                {
                    i++;
                    urldetail.setParameter("uri", content.getResourceBase().getSemanticObject().getURI());
                    String title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                    if (title == null || title.trim().equals(""))
                    {
                        title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                    }
                    title = SWBUtils.TEXT.cropText(title, 65);
            %>
            <li><a rel="destino" href="<%=urldetail%>"><%=title%></a></li>
                <%

                    }
                %>
        </ul>
        <p class="listaVideos"><a href="<%=wp.getUrl()%>"><%=viewAll%></a></p>
    </div>
    <%
    }
    else if (hasVideos)
    {

    %>
    <div id="listadoVideos">
        <p class="listaVideos"><a href="<%=wp.getUrl()%>"><%=viewAll%></a></p>
    </div>
    <%
                }
            }
        }

    %>
</div>











