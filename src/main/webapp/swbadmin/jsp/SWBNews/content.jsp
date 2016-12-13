<%@page import="org.semanticwb.model.Device"%>
<%@page import="org.semanticwb.model.CalendarRef"%>
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
                Iterator<CalendarRef> refs = resource.listCalendarRefs();
                boolean isOnSchedule = true;
                while (refs.hasNext())
                {
                    CalendarRef ref = refs.next();
                    if (ref.isValid() && ref.isActive() && ref.getCalendar().isActive() && ref.getCalendar().isValid())
                    {
                        if (!ref.getCalendar().isOnSchedule())
                        {
                            isOnSchedule = false;
                        }
                    }
                }
                Device d = resource.getDevice();
                boolean device = true;
                if (d != null)
                {
                    if (!user.hasDevice(d))
                    {
                        device = false;

                    }
                }

                if (device && user.hasDevice(resource.getDevice()) && isOnSchedule && resource.isValid() && !resource.isDeleted() && user.haveAccess(resource) && resource.isActive())
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
%><%
    if (request.getParameter("mode") != null && "strategy".equals(request.getParameter("mode")))
    {
%><jsp:include page="strategy.jsp" flush="true" /><%
        return;
    }
    if (paramRequest.getUser().getDevice().getId() != null && (paramRequest.getUser().getDevice().getId().equals("iPad") || paramRequest.getUser().getDevice().getId().equals("Android")))
    {
%><jsp:include page="contentiPad.jsp" flush="true" /><%
        return;
    }

    if (paramRequest.getUser().getDevice().getId() != null && (paramRequest.getUser().getDevice().getId().equals("iPhone") || paramRequest.getUser().getDevice().getId().equals("Android_mobile")))
    {
%><jsp:include page="contentiPhone.jsp" flush="true" /><%
        return;
    }
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
    if (st.countTokens() == 9)
    {
        ArrayList<String> values = new ArrayList<String>();
        while (st.hasMoreTokens())
        {
            String data = st.nextToken();
            values.add(data);
        }
        String s_month = values.get(7);
        String s_year = values.get(8);
        try
        {
            int iYear = Integer.parseInt(s_year);
            int iMonth = -1;
            for (String month : ds.getMonths())
            {
                iMonth++;
                if (month.equalsIgnoreCase(s_month))
                {
                    String key = iMonth + "_" + iYear;
                    if (iMonth >= 0 && iMonth <= 12)
                    {
                        List<SWBNewContent> news = getNews(null, paramRequest.getUser(), swbNews);
                        news = SWBNews.getNewsByMonth(news).get(key);
                        request.setAttribute("paramRequest", paramRequest);
                        request.setAttribute("news", news);
                        request.setAttribute("this", this);
%>
<jsp:include page="newsByMonth.jsp" flush="true" />
<%
                        /*String path = basePath + "newsByMonth.jsp";
                         RequestDispatcher dis = request.getRequestDispatcher(path);
                         try
                         {
                         request.setAttribute("paramRequest", paramRequest);
                         request.setAttribute("news", news);
                         request.setAttribute("this", this);
                         dis.include(request, response);
                         }
                         catch (Exception e)
                         {

                         }*/
                        return;
                    }
                    break;
                }
            }

        }
        catch (NumberFormatException nfe)
        {
        }
        return;
    }

    if (st.countTokens() >= 4)
    {
        ArrayList<String> values = new ArrayList<String>();
        while (st.hasMoreTokens())
        {
            values.add(st.nextToken());
        }
        String id = values.get(3);
        if ("_rid".equals(id) && values.size() >= 6)
        {
            id = values.get(5);
        }
        try
        {
            Integer.parseInt(id);
%><jsp:include page="shownew.jsp" flush="true" /><%
            return;

        }
        catch (Exception e)
        {
        }

    }

    if (request.getParameter("uri") != null)
    {
%><jsp:include page="shownew.jsp" flush="true" /><%
        return;
    }

// muestra lista de noticias en listado
    String usrlanguage = paramRequest.getUser().getLanguage();
    Locale locale = new Locale(usrlanguage);
    Calendar calendar = Calendar.getInstance(locale);

    int currentMonth = calendar.get(Calendar.MONTH);

    DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));
    int limit = 15;
    List<SWBNewContent> contents = (List<SWBNewContent>) request.getAttribute("news");
    Collections.sort(contents, new SWBNewContentComparator());
    if (contents != null && contents.size() > 0)
    {

// muestra las 15 primeras noticias
        int inew = 0;
        for (SWBNewContent content : contents)
        {
            inew++;
//SWBResourceURL url = paramRequest.getRenderUrl();
//url.setMode(paramRequest.Mode_VIEW);
//url.setParameter("uri", content.getResourceBase().getSemanticObject().getURI());

//String url = paramRequest.getWebPage().getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getEncodedURI();
            String title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
            if (title != null && title.trim().equals(""))
            {
                title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
            }
            String date = "";
            if (content.getPublishDate() != null)
            {
                date = sdf.format(content.getPublishDate());
            }
            String country = "";
            if (content.getCountry() != null && content.getCountry().getDisplayTitle(usrlanguage) != null && !content.getCountry().getDisplayTitle(usrlanguage).equals(""))
            {
                country = "(" + SWBUtils.TEXT.encodeExtendedCharacters(content.getCountry().getDisplayTitle(usrlanguage)) + ")";
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

//String url = paramRequest.getWebPage().getUrl() + "?uri=" + content.getResourceBase().getSemanticObject().getId();
//String urlcontent = url.toString().replace("&", "&amp;");
            String ago = "";
            String source = content.getSource();
            if (date != null && !date.trim().equals(""))
            {
                if (content.getPublishTime() != null)
                {
                    Date time = content.getPublishTime();
                    Calendar cal = Calendar.getInstance();
                    Calendar cal2 = Calendar.getInstance();
                    cal2.setTime(time);
                    cal.setTime(content.getPublishDate());
                    cal.set(Calendar.HOUR_OF_DAY, cal2.get(Calendar.HOUR_OF_DAY));
                    cal.set(Calendar.MINUTE, cal2.get(Calendar.MINUTE));
                    cal.set(Calendar.SECOND, cal2.get(Calendar.SECOND));
                    cal.set(Calendar.MILLISECOND, cal2.get(Calendar.MILLISECOND));
                    ago = SWBUtils.TEXT.getTimeAgo(cal.getTime(), usrlanguage);
                }
                else
                {
                    ago = SWBUtils.TEXT.getTimeAgo(content.getPublishDate(), usrlanguage);
                }
            }
            User user = paramRequest.getUser();
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
            //String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNews/sinfoto.png";
                    /*String image = "";
             if (content.getImage() != null)
             {
             image = content.getImage();
             pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/thmb_image_" + image;
             }
             else
             {
             pathPhoto=SWBPortal.getContextPath()+"/work/models/"+paramRequest.getWebPage().getWebSiteId()+"/css/noticias_infotec.gif";
             }
             String titleImage = title.replace('"', '\'');*/

            if (content.getImage() != null)
            {
                String image = content.getImage();
                pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/thmb_image_" + content.getId() + "_" + image;
            }
            String id = paramRequest.getWebPage().getId();
%>
<div class="entradaVideos">
    <div class="thumbVideo">
        <%
            if (pathPhoto != null && !"Prensa".equals(id))
            {


        %>
        <img width="120" height="120" alt="<%=title%>" src="<%=pathPhoto%>" />
        <%
            }
        %>

    </div>
    <div class="infoVideo">
        <h3><%=title%><%
            if (country != null && !country.equals(""))
            {
            %>&nbsp;<%=country%><%
                }
            %>
        </h3>
        <%
            if (originalTitle != null && !originalTitle.trim().equals(""))
            {
        %>
        <p><%=originalTitle%></p>
        <%
            }
        %>
        <p><%=description%></p>
        <p class="fechaVideo">
            <%
                if (date != null && !date.trim().equals(""))
                {
            %>
            <%=date%> - <%=ago%>
            <%
                }
            %>

        </p>
        <%
            if (source != null)
            {
                if (content.getSourceURL() == null)
                {

        %>
        <p>Fuente: <%=source%></p>
        <%
        }
        else
        {
            String urlsource = content.getSourceURL();
            urlsource = urlsource.replace("&", "&amp;");
        %>
        <p>Fuente: <a href="<%=urlsource%>"><%=source%></a></p>
            <%
                    }
                }
            %>
        <p class="vermas"><a href="<%=urlcontent%>">Ver Más</a></p>
    </div>
    <div class="clear">&nbsp;</div>
</div>
<%
        if (inew >= limit)
        {
            break;
        }
    }
    int icolumna = 1;

%>
<ul id="col<%=icolumna%>">
    <%

        int count = 0;

        String[] years = SWBNews.getYears(contents);
        for (String year : years)
        {
            int iyear = Integer.parseInt(year);

            for (int month = 11; month >= 0; month--)
            {
                if (SWBNews.hasNews(contents, month, iyear))
                {
                    count++;
                }
            }
        }
        int elementInColumn = count / 3;
        if (elementInColumn == 0)
        {
            elementInColumn++;
        }

        int ielement = 0;
        years = SWBNews.getYears(contents);
        ArrayList<String> ayears = new ArrayList<String>();
        ayears.addAll(Arrays.asList(years));
        Collections.sort(ayears, new YearComparator());
        for (String year : ayears)
        {
            int iyear = Integer.parseInt(year);
            for (int month = 11; month >= 0; month--)
            {
                if (SWBNews.hasNews(contents, month, iyear))
                {
                    ielement++;
                    if (ielement > elementInColumn && icolumna != 3)
                    {
                        icolumna++;
                        ielement = 1;
    %>
</ul>
<ul id="col<%=icolumna%>">
    <%
        }

        String titleMonth = " " + getMonth(month, paramRequest.getUser()) + " " + iyear;
        SWBResourceURL url = paramRequest.getRenderUrl();
        url.setMode("month");
        //url.setParameter("month", String.valueOf(month));
        //url.setParameter("year", year);

        String lang = "es";
        if (paramRequest.getUser().getLanguage() != null)
        {
            lang = paramRequest.getUser().getLanguage();
        }

        String currentyear = String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
        String urlcontent = url.toString().replace("&", "&amp;") + "/" + ds.getMonths()[month] + "/" + year;
        if (currentMonth == month && currentyear.equals(year))
        {
    %>
    <li class="listaLinksMes"><a href="<%=urlcontent%>"><%=ultmsg%></a></li>
        <%
        }
        else
        {
        %>
    <li class="listaLinksMes"><a href="<%=urlcontent%>"><%=mensaje%><%=titleMonth%></a></li>
        <%
                        }

                    }
                }
            }
        %>
</ul>   
<%
    }
%>
