<%@page import="java.text.DateFormatSymbols"%>
<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.news.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.*"%>
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
                return d2.compareTo(d1);
            }
            else
            {
                return o1.getResourceBase().getIndex() >= o2.getResourceBase().getIndex() ? 1 : -1;
            }
        }
    }
%>


<%
    String usrlanguage = paramRequest.getUser().getLanguage();
    Locale locale = new Locale(usrlanguage);
    DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));

    List<SWBNewContent> contents = (List<SWBNewContent>) request.getAttribute("news");

    Collections.sort(contents, new SWBNewContentComparator());
    if (contents != null && contents.size() > 0)
    {

        for (SWBNewContent content : contents)
        {

            SWBResourceURL url = paramRequest.getRenderUrl();
                    //url.setParameter("uri",content.getResourceBase().getSemanticObject().getURI());
            //url.setParameter("uri", content.getResourceBase().getSemanticObject().getId());
            url.setMode(paramRequest.Mode_VIEW);
            url.setCallMethod(paramRequest.Call_CONTENT);
            String title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
            if (title != null && title.trim().equals(""))
            {
                title = SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getDisplayTitle(usrlanguage));
            }
            String titleURL = getTitleURL(content.getResourceBase().getDisplayTitle(usrlanguage));

            String urlcontent = url.toString().replace("&", "&amp;") + "/" + content.getResourceBase().getSemanticObject().getId() + "/" + titleURL;
            //String urlcontent=url.toString().replace("&", "&amp;");

            String titleImage = title.replace('"', '\'');
            String ago = "";
            String source = content.getSource();
            String date = "";
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
            String country = "";
            if (content.getCountry() != null)
            {
                country = "(" + SWBUtils.TEXT.encodeExtendedCharacters(content.getCountry().getTitle(usrlanguage)) + ")";
            }
            String originalTitle = "";
            if (content.getOriginalTitle() != null)
            {
                originalTitle = SWBUtils.TEXT.encodeExtendedCharacters(content.getOriginalTitle());
            }
            String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNews/sinfoto.png";
            pathPhoto = SWBPortal.getContextPath() + "/work/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/noticias_infotec.gif";
            String image = "";
            if (content.getImage() != null)
            {
                image = content.getImage();
                pathPhoto = SWBPortal.getWebWorkPath() + content.getSemanticObject().getWorkPath() + "/thmb_image_"+ content.getId()+"_"+image;
            }
            if (content.getPublishDate() != null)
            {
                int month = -1;

                if (request.getParameter("month") != null)
                {
                    try
                    {
                        month = Integer.parseInt(request.getParameter("month"));
                    }
                    catch (NumberFormatException e)
                    {
                        e.printStackTrace();
                    }
                }
                String languser = "es";
                if (paramRequest.getUser().getLanguage() != null)
                {
                    languser = paramRequest.getUser().getLanguage();
                }

                Calendar cal = Calendar.getInstance();
                cal.setTime(content.getPublishDate());
                int year = Calendar.getInstance().get(Calendar.YEAR);
                if (request.getParameter("year") != null)
                {
                    try
                    {
                        year = Integer.parseInt(request.getParameter("year"));
                    }
                    catch (NumberFormatException e)
                    {
                        e.printStackTrace();
                    }
                }
                Locale userlocale = new Locale(languser);
                DateFormatSymbols ds = new DateFormatSymbols(userlocale);
                String uri = request.getRequestURI();
                StringTokenizer st = new StringTokenizer(uri, "/");
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
                        year = Integer.parseInt(s_year);
                    }
                    catch (NumberFormatException nfe)
                    {
                    }
                    int iMonth = -1;
                    for (String dsmonth : ds.getMonths())
                    {
                        iMonth++;
                        if (dsmonth.equalsIgnoreCase(s_month))
                        {
                            month = iMonth;
                            break;
                        }
                    }
                }

                if (!(month == cal.get(Calendar.MONTH) && year == cal.get(Calendar.YEAR)))
                {
                    continue;
                }
                date = sdf.format(content.getPublishDate());

            }
%>
<div class="entradaVideos">
    <div class="thumbVideo">
        <%
            if (pathPhoto != null)
            {
        %>
        <img width="120" height="120" alt="<%=titleImage%>" src="<%=pathPhoto%>" />
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
    }

    String urlall = paramRequest.getWebPage().getUrl();
                //urlall.setMode(urlall.Mode_VIEW);
    //urlall.setCallMethod(urlall.Call_CONTENT);
    String viewAll = "[Ver todas las noticias]";
    if (paramRequest.getUser().getLanguage() != null && !paramRequest.getUser().getLanguage().equalsIgnoreCase("en"))
    {
        viewAll = "[View all news]";
    }
%>
<p><a href="<%=urlall%>"><%=viewAll%></a></p>
<%
    }
%>