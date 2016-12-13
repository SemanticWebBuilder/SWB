<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.semanticwb.model.Resourceable"%><%@page import="org.semanticwb.model.ResourceCollectionCategory"%><%@page import="java.text.DateFormatSymbols"%><%@page import="org.semanticwb.model.GenericIterator"%><%@page import="org.semanticwb.model.Country"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%><%@page import="org.semanticwb.portal.api.SWBResource"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.*"%><%@page import="java.text.DateFormat"%><%@page import="java.util.Locale"%><%@page import="org.semanticwb.portal.resources.sem.news.*"%><%@page import="org.semanticwb.model.Resource"%><%@page import="java.util.*"%><%@page import="org.semanticwb.model.WebPage"%><%@page import="org.semanticwb.model.User"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/><%!    private static String mensaje = "Noticias de ";
    private static SimpleDateFormat df = new SimpleDateFormat("dd '/' MM '/' yyyy");

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
            String imageteaser = SWBPortal.getContextPath() + "/work/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/teaserNoticias.jpg";

            String languser = "es";
            if (paramRequest.getUser().getLanguage() != null)
            {
                languser = paramRequest.getUser().getLanguage();
            }


            Locale userlocale = new Locale(languser);
            DateFormatSymbols ds = new DateFormatSymbols(userlocale);
            String uri = request.getRequestURI();
            StringTokenizer st = new StringTokenizer(uri, "/");
            SWBNews swbNews = (SWBNews) request.getAttribute("this");

            WebPage noticias = paramRequest.getWebPage();
            Iterator<Resourceable> resourceables = paramRequest.getResourceBase().listResourceables();
            while (resourceables.hasNext())
            {
                Resourceable resourceable = resourceables.next();
                if (resourceable instanceof WebPage)
                {
                    noticias = (WebPage) resourceable;
                    break;
                }
            }
            String usrlanguage = paramRequest.getUser().getLanguage();
            List<SWBNewContent> contents = (List<SWBNewContent>) request.getAttribute("news");
            Collections.sort(contents, new SWBNewContentComparator());
            ArrayList<SWBNewContent> contentstoshow = new ArrayList<SWBNewContent>();
            for (SWBNewContent content : contents)
            {
                if (content.isHomeShow())
                {
                    contentstoshow.add(content);
                }
            }



            int npages = contentstoshow.size() / 4;
            if (contentstoshow.size() % 4 != 0)
            {
                npages++;
            }
            int npage = 1;
            if (request.getParameter("page") != null)
            {
                try
                {
                    npage = Integer.parseInt(request.getParameter("page"));
                }
                catch (Exception e)
                {
                    e.printStackTrace();
                }
            }
            if (npage <= 0)
            {
                npage = 1;
            }
            if (npage > npages)
            {
                npage = npages;
            }
            ArrayList<SWBNewContent> left = new ArrayList<SWBNewContent>();
            ArrayList<SWBNewContent> rigth = new ArrayList<SWBNewContent>();



            int initialIndex = (npage * 4) - 4;
            int finalIndex = npage * 4;

            ArrayList<SWBNewContent> page_contents = new ArrayList<SWBNewContent>();
            int i = 0;
            for (SWBNewContent content : contentstoshow)
            {
                if (i >= initialIndex && i < finalIndex)
                {
                    page_contents.add(content);
                }
                i++;
            }

            i = 0;
            for (SWBNewContent content : page_contents)
            {
                if (i % 2 == 0)
                {
                    left.add(content);
                }
                else
                {
                    rigth.add(content);
                }
                i++;
            }

%>
<div id="twoColumnsInterna">
    <h1><img src="<%=imageteaser%>" width="748" height="150" alt="Noticias" /></h1>
    <div id="leftCol">
        <%
                    for (SWBNewContent content : left)
                    {
                        String title = "Sin título";
                        if (content.getResourceBase().getDisplayTitle(usrlanguage) != null)
                        {
                            title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                            if (title != null && title.trim().equals(""))
                            {
                                title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                            }
                        }
                        String description = "";
                        if (content.getResourceBase().getDisplayDescription(usrlanguage) != null)
                        {
                            description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(usrlanguage));
                            if (description != null && description.trim().equals(""))
                            {
                                description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(usrlanguage));
                            }
                        }
                        String url = "#";
                        String image = content.getImage();

                        if (image == null)
                        {
                            image = SWBPortal.getContextPath() + "/work/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/noticias_infotec.gif";
                        }
                        else
                        {
                            image = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/image_" + content.getId() + "_" + image;
                        }
                        //url = noticias.getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getEncodedURI();
                        url = noticias.getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getId();
                        String titleURL = getTitleURL(content.getResourceBase().getDisplayTitle(usrlanguage));
                        url = noticias.getUrl() + "/" + content.getResourceBase().getSemanticObject().getId() + "/" + titleURL;
                        String date = "24/02/2011";
                        if (content.getPublishDate() != null)
                        {
                            date = df.format(content.getPublishDate());
                        }
                        else if (content.getResourceBase().getCreated() != null)
                        {
                            date = df.format(content.getResourceBase().getCreated());
                        }
        %>
        <div class="noteBits"><a href="<%=url%>"><img src="<%=image%>" alt="asad" width="108" height="96" /></a>
            <h2><a href="<%=url%>"><%=title%></a></h2>
            <p class="fecha"><%=date%></p>
            <p><a href="#"><%=description%></a></p>
        </div>
        <%                            }
        %>


    </div>
    <div id="rightCol">
        <%
                    for (SWBNewContent content : rigth)
                    {
                        String title = "Sin título";
                        if (content.getResourceBase().getDisplayTitle(usrlanguage) != null)
                        {
                            title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                            if (title != null && title.trim().equals(""))
                            {
                                title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
                            }
                        }
                        String description = "";
                        if (content.getResourceBase().getDisplayDescription(usrlanguage) != null)
                        {
                            description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(usrlanguage));
                            if (description != null && description.trim().equals(""))
                            {
                                description = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayDescription(usrlanguage));
                            }
                        }
                        String url = "#";
                        String image = content.getImage();

                        if (image == null)
                        {
                            image = SWBPortal.getContextPath() + "/work/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/noticias_infotec.gif";
                        }
                        else
                        {
                            image = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/image_" + content.getId() + "_" + image;
                        }
                        //url = noticias.getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getEncodedURI();
                        url = noticias.getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getId();
                        String titleURL = getTitleURL(content.getResourceBase().getDisplayTitle(usrlanguage));
                        url = noticias.getUrl() + "/" + content.getResourceBase().getSemanticObject().getId() + "/" + titleURL;
                        String date = "24 . 02 . 2011";
                        if (content.getPublishDate() != null)
                        {
                            date = df.format(content.getPublishDate());
                        }
                        else if (content.getResourceBase().getCreated() != null)
                        {
                            date = df.format(content.getResourceBase().getCreated());
                        }
        %>
        <div class="noteBits"><a href="<%=url%>"><img src="<%=image%>" alt="asad" width="108" height="96" /></a>
            <h2><a href="<%=url%>"><%=title%></a></h2>
            <p class="fecha"><%=date%></p>
            <p><a href="#"><%=description%></a></p>
        </div>
        <%                            }
        %>


    </div>

</div>

<%
            String urlNext = request.getRequestURL() + "?page=" + (npage + 1);
            String urlBefore = request.getRequestURL() + "?page=" + (npage - 1);
            if (npage - 1 == 0)
            {
                urlBefore = "#";
            }
            if (npage + 1 > npages)
            {
                urlNext = "#";
            }
%>
<div id="arrows"><a href="<%=urlBefore%>" id="leftArrow">atras</a> <a href="<%=urlNext%>" id="rightArrow">adelante</a></div>

