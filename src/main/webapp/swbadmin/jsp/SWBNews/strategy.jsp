<%@page import="org.semanticwb.model.Resourceable"%><%@page import="java.text.SimpleDateFormat"%><%@page import="org.semanticwb.model.GenericObject"%><%@page import="org.semanticwb.model.Country"%><%@page import="org.semanticwb.model.User"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%><%@page import="org.semanticwb.portal.api.SWBResource"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="java.text.DateFormat"%><%@page import="java.util.Locale"%><%@page import="org.semanticwb.portal.resources.sem.news.*"%><%@page import="org.semanticwb.model.Resource"%><%@page import="java.util.*"%><%@page import="org.semanticwb.model.GenericIterator"%><%@page import="org.semanticwb.model.WebPage"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/><%!
    private static SimpleDateFormat df = new SimpleDateFormat("dd '.' MM '.' yyyy");
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
    public static final String NEWLINE = "br";
    private static final String[] htmlCode = new String[256];

    static
    {
        for (int i = 0; i < 10; i++)
        {
            htmlCode[i] = "&#00" + i + ";";
        }

        for (int i = 10; i < 32; i++)
        {
            htmlCode[i] = "&#0" + i + ";";
        }

        for (int i = 32; i < 128; i++)
        {
            htmlCode[i] = String.valueOf((char) i);
        }

        // Special characters
        htmlCode['\t'] = "\t";
        htmlCode['\n'] = "<" + NEWLINE + " />\n";
        htmlCode['\"'] = "&quot;"; // double quote
        htmlCode['&'] = "&amp;"; // ampersand
        htmlCode['<'] = "&lt;"; // lower than
        htmlCode['>'] = "&gt;"; // greater than

        for (int i = 128; i < 256; i++)
        {
            htmlCode[i] = "&#" + i + ";";
        }
    }

    public static String decode(String string)
    {
        int n = string.length();
        char character;
        StringBuffer buffer = new StringBuffer();
        // loop over all the characters of the String.
        for (int i = 0; i < n; i++)
        {
            character = string.charAt(i);
            // the Htmlcode of these characters are added to a StringBuffer one by one
            if (character < 256)
            {
                buffer.append(htmlCode[character]);
            }
            else
            {
                // Improvement posted by Joachim Eyrich
                buffer.append("&#").append((int) character).append(';');
            }
        }
        return buffer.toString().trim();
    }
    /*public String decode(String data)
    {
    data = data.replace("Á", "&Aacute;");
    data = data.replace("E", "&Eacute;");
    data = data.replace("Í", "&Iacute;");
    data = data.replace("Ó", "&Oacute;");
    data = data.replace("Ú", "&Uacute;");
    data = data.replace("á", "&aacute;");
    data = data.replace("é", "&eacute;");
    data = data.replace("i", "&iacute;");
    data = data.replace("ó", "&oacute;");
    data = data.replace("ú", "&uacute;");



    data = data.replace("\"", "&quot;");
    data = data.replace("ú", "&uacute;");


    return data;
    }*/
%><%
            if (paramRequest.getArgument("mode") != null && "title".equals(paramRequest.getArgument("mode")))
            {

%><jsp:include page="title.jsp" flush="true" /><%
                return;
            }
            if (paramRequest.getUser().getDevice().getId()!=null && (paramRequest.getUser().getDevice().getId().equals("iPad")|| paramRequest.getUser().getDevice().getId().equals("Android")))
            {
%><jsp:include page="strategyIpad.jsp" flush="true" /><%
                return;
            }
            String div = paramRequest.getArgument("div", "noticiasinfotec");
            String mainTitle = paramRequest.getArgument("title", "Últimas noticias");

            if (request.getParameter("div") != null)
            {
                div = request.getParameter("div");
            }

            if (request.getParameter("mainTitle") != null)
            {
                mainTitle = request.getParameter("mainTitle");
            }
            mainTitle = mainTitle;


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
            if (true)
            {
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
%>

<%
                                int npages = contentstoshow.size() / 3;
                                if (contentstoshow.size() % 3 != 0)
                                {
                                    npages++;
                                }
                                if (npages > 3)
                                {
                                    npages = 3;
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
                                int max = npage * 3;
                                int min = max - 2;



%>
<%
                                User user = paramRequest.getUser();
                                if (!(user.getDevice().getId().equals("iPad") || user.getDevice().getId().equals("iPhone")))
                                {
%>
<h3><%=decode(mainTitle)%></h3>
<%
                                }
%>

<%                //if (npages > 1)
                                {
                                    int prepage = npage;
                                    if (prepage > 1)
                                    {
                                        prepage--;
                                    }
                                    SWBResourceURL anterior = paramRequest.getRenderUrl();
                                    anterior.setCallMethod(SWBResourceURL.Call_DIRECT);
                                    anterior.setParameter("page", String.valueOf(prepage));
                                    anterior.setParameter("mode", "strategy");
                                    anterior.setParameter("div", div);
                                    anterior.setParameter("mainTitle", mainTitle);

%>

<div id="bloque_noticias_recientes<%=div%>" class="navegador noticias">
    <%
                        if (!(user.getDevice().getId().equals("iPad") || user.getDevice().getId().equals("iPhone")))
                        {
    %>
    <a class="anterior" href="javascript:changePage('<%=anterior.toString(true)%>','<%=div%>')" >anterior</a>
    <%
                        }
    %>

    <ul class="selector">

        <%
                            int dif = 3 - npages;
                            for (int ipage = 1; ipage <= npages; ipage++)
                            {
                                SWBResourceURL urlpage = paramRequest.getRenderUrl();
                                urlpage.setCallMethod(SWBResourceURL.Call_DIRECT);
                                urlpage.setParameter("page", String.valueOf(ipage));
                                urlpage.setParameter("mode", "strategy");
                                urlpage.setParameter("div", div);
                                urlpage.setParameter("mainTitle", mainTitle);
        %>
        <%
                                        if (!(user.getDevice().getId().equals("iPad") || user.getDevice().getId().equals("iPhone")))
                                        {
        %>
        <li><a href="javascript:changePage('<%=urlpage.toString(true)%>','<%=div%>')" ><%=ipage%></a></li>
        <%
                                        }
        %>

        <%
                            }
                            for (int ipage = 1; ipage <= dif; ipage++)
                            {
                                SWBResourceURL urlpage = paramRequest.getRenderUrl();
                                urlpage.setCallMethod(SWBResourceURL.Call_DIRECT);
                                urlpage.setParameter("page", String.valueOf(npages));
                                urlpage.setParameter("mode", "strategy");
                                urlpage.setParameter("div", div);
                                urlpage.setParameter("mainTitle", mainTitle);
        %>
        <%
                                        if (!(user.getDevice().getId().equals("iPad") || user.getDevice().getId().equals("iPhone")))
                                        {
        %>
        <li><a href="javascript:changePage('<%=urlpage.toString(true)%>','<%=div%>')" ><%=npages%></a></li>
        <%
                                        }

        %>

        <%
                            }
        %>


    </ul>
    <%
                        int nexpage = npage;
                        if (npage < npages)
                        {
                            nexpage++;
                        }
                        SWBResourceURL siguiente = paramRequest.getRenderUrl();
                        siguiente.setCallMethod(SWBResourceURL.Call_DIRECT);
                        siguiente.setParameter("page", String.valueOf(nexpage));
                        siguiente.setParameter("mode", "strategy");
                        siguiente.setParameter("div", div);
                        siguiente.setParameter("mainTitle", mainTitle);


    %>
    <%
                        if (!(user.getDevice().getId().equals("iPad") || user.getDevice().getId().equals("iPhone")))
                        {
    %>
    <a class="siguiente" href="javascript:changePage('<%=siguiente.toString(true)%>','<%=div%>')" >siguiente</a>
    <%
                        }
    %>

    <div style="clear: both; "></div>
</div>
<%
                                }

                                

                                if (contentstoshow.size() > 0)
                                {
%>
<ul id="noticias<%=div%>">
    <%
                        int i = 0;
                        for (SWBNewContent content : contentstoshow)
                        {
                            i++;
                            if (i >= min && i <= max)
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
                                String fuente = null;
                                if (content.getSource() != null)
                                {
                                    fuente = content.getSource();
                                }
    %>
    <%-- <li><a href="<%=url%>" ><img width="68" height="51" alt="<%=title%>" src="<%=image%>" />
            <span class="fecha"><%=date%></span>
            <b><%=title%></b>
            <%
                                            if (fuente != null)
                                            {
            %>        <span class="fuente"><%=decode(fuente)%></span>        <%
                                            }
            %><span><%=description%></span></a>
    </li> --%>
    <li><a href="<%=url%>"><img width="68" height="51" alt="imagen_noticia" src="<%=image%>"/></a>
        <span class="fecha"><%=date%></span>
        <h4><a href="<%=url%>"><%=title%></a></h4>                <%
                                        if (fuente != null)
                                        {
        %>        <span class="fuente"><%=decode(fuente)%></span>        <%
                                        }
        %>

        <p><%=description%></p>
    </li>
    <%
                            }

                        }
    %>
</ul>
<%
                                }
                                String urlNews = noticias.getUrl();
%>
<a class="ver_mas" href="<%=urlNews%>" >Ver m&aacute;s</a>
<%

            }

%>

