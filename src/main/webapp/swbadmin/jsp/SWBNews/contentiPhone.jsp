<%@page import="org.semanticwb.model.ResourceCollectionCategory"%><%@page import="java.text.DateFormatSymbols"%><%@page import="org.semanticwb.model.GenericIterator"%><%@page import="org.semanticwb.model.Country"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%><%@page import="org.semanticwb.portal.api.SWBResource"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.*"%><%@page import="java.text.DateFormat"%><%@page import="java.util.Locale"%><%@page import="org.semanticwb.portal.resources.sem.news.*"%><%@page import="org.semanticwb.model.Resource"%><%@page import="java.util.*"%><%@page import="org.semanticwb.model.WebPage"%><%@page import="org.semanticwb.model.User"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/><%!    private static String mensaje = "Noticias de ";

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
    private static String mesage = "News of ";
    private static String ultmsg = "Noticias del mes";
    private static String lastmsg = "Previous news";
    static String[] meses =
    {
        "Enero", "Febrero", "Marzo", "Abril", "Mayo",
        "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    };
    static String[] months =
    {
        "January", "February", "March", "April", "May",
        "June", "July", "August", "September", "October", "November", "December"
    };

    private String getMonth(int month, User user)
    {
        String getMonth = meses[month];
        return getMonth;
    }

    class YearComparator implements Comparator<String>
    {

        public int compare(String o1, String o2)
        {
            Integer i1 = Integer.parseInt(o1);
            Integer i2 = Integer.parseInt(o2);
            return i2.compareTo(i1);
        }
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
                return d2.compareTo(d1);
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

            String languser = "es";
            if (paramRequest.getUser().getLanguage() != null)
            {
                languser = paramRequest.getUser().getLanguage();
            }
            User user = paramRequest.getUser();
            Locale userlocale = new Locale(languser);
            DateFormatSymbols ds = new DateFormatSymbols(userlocale);
            String uri = request.getRequestURI();
            StringTokenizer st = new StringTokenizer(uri, "/");
            SWBNews swbNews = (SWBNews) request.getAttribute("this");
            if (request.getParameter("uri") != null)
            {
%><jsp:include page="shownew.jsp" flush="true" /><%
                return;
            }
            String usrlanguage = paramRequest.getUser().getLanguage();
            List<SWBNewContent> contents = (List<SWBNewContent>) request.getAttribute("news");
            Collections.sort(contents, new SWBNewContentComparator());
            DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));
            List<SWBNewContent> contentsToshow = new ArrayList<SWBNewContent>();
            for (int i = 0; i < 5; i++)
            {
                contentsToshow.add(contents.get(i));

            }
            for (SWBNewContent content : contentsToshow)
            {
                String title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                if (title != null && title.trim().equals(""))
                {
                    title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                }

                String originalTitle = "";
                if (content.getOriginalTitle() != null)
                {
                    originalTitle = SWBUtils.TEXT.encodeExtendedCharacters(content.getOriginalTitle());
                }
                SWBResourceURL url = paramRequest.getRenderUrl();
                url.setMode(paramRequest.Mode_VIEW);
                String titleURL = getTitleURL(content.getResourceBase().getDisplayTitle(usrlanguage));
                String urlcontent = url.toString().replace("&", "&amp;") + "/" + content.getResourceBase().getSemanticObject().getId() + "/" + titleURL;
                String description = "";
                if (content.getResourceBase().getDisplayDescription(user.getLanguage()) != null)
                {
                    description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(user.getLanguage()));
                    if (description != null && description.trim().equals(""))
                    {
                        description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(user.getLanguage()));
                    }
                }
                String pathPhoto = "/work/models/" + paramRequest.getWebPage().getWebSite().getId() + "/css/noticias_infotec.gif";
                if (content.getImage() != null)
                {
                    String image = content.getImage();
                    pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/thmb_image_" + content.getId() + "_" + image;
                }
                String date = "";
                if (content.getPublishDate() != null)
                {
                    date = sdf.format(content.getPublishDate());
                }
                String source = content.getSource();
                if (source == null)
                {
                    source = "";
                }
                String sourceURL = content.getSourceURL();
                if (sourceURL == null)
                {
                    sourceURL = "#";
                }

%>

<div class="notaChunks"><a href="<%=urlcontent%>"><img alt="<%=title%>"  src="<%=pathPhoto%>" width="80" height="80" /></a>
    <h3><a href="<%=urlcontent%>"><%=title%></a></h3>
    <p><a href="<%=urlcontent%>"><%=description%></a></p>
    <p class="fechaVideo"><%=date%></p>
    <p>
        Fuente: <a href="<%=sourceURL%>" class="fuente"><%=source%></a></p></div>
        <%
                    }
        %>


