<%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.model.GenericIterator"%><%@page import="org.semanticwb.model.Country"%><%@page import="org.semanticwb.model.User"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%><%@page import="org.semanticwb.portal.api.SWBResource"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="java.text.DateFormat"%><%@page import="java.util.Locale"%><%@page import="org.semanticwb.portal.resources.sem.news.*"%><%@page import="org.semanticwb.model.Resource"%><%@page import="java.util.*"%><%@page import="org.semanticwb.model.ResourceCollectionCategory"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
public static String changeCharacters(String data)
    {
        if (data == null || data.trim().equals(""))
        {
            return data;
        }
        String changeCharacters = data.toLowerCase().trim();
        if (changeCharacters.indexOf("[") != -1)
        {
            changeCharacters = changeCharacters.replace('[', ' ');
        }
        if (changeCharacters.indexOf("]") != -1)
        {
            changeCharacters = changeCharacters.replace(']', ' ');
        }
        if (changeCharacters.indexOf("/") != -1)
        {
            changeCharacters = changeCharacters.replace('/', ' ');
        }
        if (changeCharacters.indexOf(";") != -1)
        {
            changeCharacters = changeCharacters.replace(';', ' ');
        }
        if (changeCharacters.indexOf(":") != -1)
        {
            changeCharacters = changeCharacters.replace(':', ' ');
        }
        if (changeCharacters.indexOf("-") != -1)
        {
            changeCharacters = changeCharacters.replace('-', ' ');
        }
        if (changeCharacters.indexOf(",") != -1)
        {
            changeCharacters = changeCharacters.replace(',', ' ');
        }
        changeCharacters = changeCharacters.replace('á', 'a');
        changeCharacters = changeCharacters.replace('é', 'e');
        changeCharacters = changeCharacters.replace('í', 'i');
        changeCharacters = changeCharacters.replace('ó', 'o');
        changeCharacters = changeCharacters.replace('ú', 'u');
        changeCharacters = changeCharacters.replace('à', 'a');
        changeCharacters = changeCharacters.replace('è', 'e');
        changeCharacters = changeCharacters.replace('ì', 'i');
        changeCharacters = changeCharacters.replace('ò', 'o');
        changeCharacters = changeCharacters.replace('ù', 'u');
        changeCharacters = changeCharacters.replace('ü', 'u');
        changeCharacters = changeCharacters.replace('ñ', 'n');
        StringBuilder sb = new StringBuilder();
        boolean addSpace = true;
        for (char schar : changeCharacters.toCharArray())
        {
            if (schar == ' ')
            {
                if (addSpace)
                {
                    sb.append(schar);
                    addSpace = false;
                }
            }
            else
            {
                sb.append(schar);
                addSpace = true;
            }

        }
        return sb.toString().trim();
    }

    public String getTitleURL(String title)
    {
        title = changeCharacters(title);

        StringBuilder sb = new StringBuilder();

        for (char s : title.toCharArray())
        {
            if (s == ' ')
            {
                sb.append('-');
            }
            else if (Character.isLetterOrDigit(s))
            {
                sb.append(s);
            }
            else
            {
                sb.append('-');
            }
        }
        return sb.toString();
    }
    class SWBNewContentComparator implements Comparator<SWBNewContent>
    {

        public int compare(SWBNewContent o1, SWBNewContent o2)
        {
            Date d1 = o1.getPublishDate();
            Date d2 = o2.getPublishDate();
            if (d1 == null)
            {
                d1 = o1.getResource().getCreated();
            }
            if (d2 == null)
            {
                d2 = o2.getResource().getCreated();
            }
            if (d1 != null && d2 != null)
            {
                return d1.compareTo(d2);
            }
            else
            {
                return o1.getResourceBase().getIndex() >= o2.getResourceBase().getIndex() ? 1 : -1;
            }
        }
    }

    private List<SWBNewContent> getNews(String uri, User user, SWBNews swbNews)
    {
        List<SWBNewContent> news = new ArrayList<SWBNewContent>();
        GenericIterator<Resource> resources = null;
        if (swbNews.getCollection() != null && swbNews.getCollection().getResourceCollectionType().getResourceClassName().equals(SWBNewContent.class.getCanonicalName()))
        {
            if (swbNews.getCategory() == null)
            {
                resources = swbNews.getCollection().listResources();
            }
            else
            {
                boolean isCategoryOfCallection = false;
                GenericIterator<ResourceCollectionCategory> categories = swbNews.getCollection().listCategories();
                while (categories.hasNext())
                {
                    ResourceCollectionCategory category = categories.next();
                    if (category.getURI().equals(swbNews.getCategory().getURI()))
                    {
                        isCategoryOfCallection = true;
                        break;
                    }
                }
                if (isCategoryOfCallection)
                {
                    resources = swbNews.getCategory().listResources();
                }
                else
                {
                    resources = swbNews.getCollection().listResources();
                }
            }
        }
        if (resources != null)
        {
            while (resources.hasNext())
            {
                Resource resource = resources.next();
                if (resource.isActive() && !resource.isDeleted() && user.haveAccess(resource))
                {
                    SWBNewContent object = (SWBNewContent) resource.getResourceData().createGenericInstance();
                    if (uri == null)
                    {
                        try
                        {
                            object.setResourceBase(resource);
                            news.add(object);
                        }
                        catch (Exception e)
                        {
                        }
                    }
                    else
                    {
                        if (uri.equals(resource.getURI()) || uri.equals(resource.getId()))
                        {

                            try
                            {
                                object.setResourceBase(resource);
                                news.add(object);
                            }
                            catch (Exception e)
                            {
                            }
                        }
                    }

                }
            }
        }
        return news;
    }
%>

<%
            String pathPhoto = null;//SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNews/sinfoto.png";


            User user = paramRequest.getUser();

            if (paramRequest.getUser().getDevice().getId() != null && (paramRequest.getUser().getDevice().getId().equals("iPad") || paramRequest.getUser().getDevice().getId().equals("Android")))
            {
%><jsp:include page="shownewIpad.jsp" flush="true" /><%
                return;
            }
            if (paramRequest.getUser().getDevice().getId() != null && (paramRequest.getUser().getDevice().getId().equals("iPhone") || paramRequest.getUser().getDevice().getId().equals("Android_mobile")))
                {
                %><jsp:include page="shownewIphone.jsp" flush="true" /><%
                return;
                }
            // muestra el recurso
            SWBNewContent content = (SWBNewContent) request.getAttribute("content");
            SWBNews news = (SWBNews) request.getAttribute("this");

            
            if (content == null && request.getParameter("uri") != null)
            {
                String uri = request.getParameter("uri");
                for (SWBNewContent _content : getNews(uri, user, news))
                {
                    if (_content.getResourceBase().getURI().equals(uri) || _content.getResourceBase().getId().equals(uri))
                    {
                        if (_content.getResourceBase().isValid() && paramRequest.getUser().haveAccess(_content.getResourceBase()))
                        {
                            content = _content;

                        }

                    }
                }
            }

            StringTokenizer st = new StringTokenizer(request.getRequestURI(), "/");
            if (st.countTokens() >= 4)
            {
                ArrayList<String> values = new ArrayList<String>();
                while (st.hasMoreTokens())
                {
                    values.add(st.nextToken());
                }
                String uri = values.get(3);
                if ("_rid".equals(uri) && values.size()>=6)
                {
                    uri = values.get(5);
                }
                for (SWBNewContent _content : getNews(uri, user, news))
                {
                    if (_content.getResourceBase().getURI().equals(uri) || _content.getResourceBase().getId().equals(uri))
                    {
                        if (_content.getResourceBase().isValid() && paramRequest.getUser().haveAccess(_content.getResourceBase()))
                        {
                            content = _content;

                        }

                    }
                }
            }
            List<SWBNewContent> newslist = getNews(null, paramRequest.getUser(), news);
            Collections.sort(newslist, new SWBNewContentComparator());

            String title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(user.getLanguage()));
            String image = "";
            if (content.getImage() != null)
            {
                image = content.getImage();
                if (news.isMobile())
                {
                    pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/thmb_image_" + content.getId() + "_" + image;
                }
                else
                {
                    pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/image_" + content.getId() + "_" + image;
                }
            }
%>

<%
            SWBNewContent next = null;
            SWBNewContent before = null;

            for (int icontent = 0; icontent < newslist.size(); icontent++)
            {
                SWBNewContent temp = newslist.get(icontent);
                if (temp.getURI().equals(content.getURI()))
                {
                    if (icontent > 0)
                    {
                        before = newslist.get(icontent - 1);
                    }
                    if (icontent < (newslist.size() - 1))
                    {
                        next = newslist.get(icontent + 1);
                    }
                }
            }

            if (before != null)
            {
                //String url = paramRequest.getWebPage().getUrl() + "?uri=" + before.getResourceBase().getSemanticObject().getEncodedURI();
                String url = paramRequest.getWebPage().getUrl();// + "?uri=" + before.getResourceBase().getSemanticObject().getId();
                String beforettitle=before.getResourceBase().getDisplayTitle(user.getLanguage());
                beforettitle=getTitleURL(beforettitle);
                String urlcontent = url.toString().replace("&", "&amp;")+"/"+before.getResourceBase().getSemanticObject().getId()+"/"+beforettitle;
%>
<a href="<%=urlcontent%>">Noticia anterior</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%                        }

            if (next != null)
            {
                //String url = paramRequest.getWebPage().getUrl() + "?uri=" + next.getResourceBase().getSemanticObject().getEncodedURI();
                String url = paramRequest.getWebPage().getUrl();//+ "?uri=" + next.getResourceBase().getSemanticObject().getId();
                String nexttitle=next.getResourceBase().getDisplayTitle(user.getLanguage());
                nexttitle=getTitleURL(nexttitle);
                String urlcontent = url.toString().replace("&", "&amp;")+"/"+next.getResourceBase().getSemanticObject().getId()+"/"+nexttitle;
%>
<a href="<%=urlcontent%>">Noticia siguiente</a>
<%
            }

%>

<br/><br/><h2 class="sectionTitle"><%=title%>
    <%
                if (content.getCountry() != null)
                {
                    String country = content.getCountry().getDisplayTitle(user.getLanguage());
    %>
    (<%=country%>)
    <%
                }

                String description = "";
                if (content.getResourceBase().getDisplayDescription(user.getLanguage()) != null)
                {
                    description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(user.getLanguage()));
                    if (description != null && description.trim().equals(""))
                    {
                        description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(user.getLanguage()));
                    }
                }

    %>
</h2>


<p><i><%=description%></i></p>
<%
            if (pathPhoto != null)
            {
                if (news.isMobile())
                {
%>
<img alt="Imagen noticia" src="<%=pathPhoto%>" />
<%
                }
                else
                {
%>
<img alt="Imagen noticia" width="368" height="230" src="<%=pathPhoto%>" />
<%
                }
%>             
<!--br/-->
<%
            }
%>

<%
            if (content.getOriginalTitle() != null)
            {
                String originalTitle = SWBUtils.TEXT.encodeExtendedCharacters(content.getOriginalTitle());
%>
<%--=originalTitle--%><br/>
<%
            }
            if (content.getSource() != null)
            {
                String source = SWBUtils.TEXT.encodeExtendedCharacters(content.getSource());
                if (content.getSourceURL() != null)
                {
%>
<a target="_blank" href="<%=content.getSourceURL()%>"><%=source%></a>
<%
                }
                else
                {
%>
<%=source%>
<%
                }
            }
            if (content.getAuthor() != null)
            {
                out.println(SWBUtils.TEXT.encodeExtendedCharacters(content.getAuthor()) + "<br/>");
            }
            if (content.getPublishDate() != null)
            {
                out.println(SWBUtils.TEXT.getStrDate(content.getPublishDate(), "es", "dd/mm/yyyy") + "<br/>");
            }

            SWBHttpServletResponseWrapper res = new SWBHttpServletResponseWrapper(response);
            ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setResourceBase(content.getResourceBase());
            ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setVirtualResource(content.getResourceBase());
            ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setMode(paramRequest.Mode_VIEW);
            ((org.semanticwb.portal.api.SWBParamRequestImp) paramRequest).setCallMethod(paramRequest.Call_CONTENT);
            content.doView(request, res, paramRequest);
            content.getResourceBase().incViews();
%>

<%=res.toString()%>
<%
%>
