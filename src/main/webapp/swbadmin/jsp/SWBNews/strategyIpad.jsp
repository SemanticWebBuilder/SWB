<%@page import="org.semanticwb.model.Resourceable"%><%@page import="java.text.SimpleDateFormat"%><%@page import="org.semanticwb.model.GenericObject"%><%@page import="org.semanticwb.model.Country"%><%@page import="org.semanticwb.model.User"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%><%@page import="org.semanticwb.portal.api.SWBResource"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="java.text.DateFormat"%><%@page import="java.util.Locale"%><%@page import="org.semanticwb.portal.resources.sem.news.*"%><%@page import="org.semanticwb.model.Resource"%><%@page import="java.util.*"%><%@page import="org.semanticwb.model.GenericIterator"%><%@page import="org.semanticwb.model.WebPage"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/><%!    private static SimpleDateFormat df = new SimpleDateFormat("dd '.' MM '.' yyyy");

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
%>

<%
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
            if (!contentstoshow.isEmpty())
            {
%>
<ul class="infoChunks">
    <%
                    for (int i = 0; i < 3; i++)
                    {
                        SWBNewContent content = contentstoshow.get(i);
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
    <li><p class="fecha"><%=date%></p>
        <p><a href="<%=url%>" ><%=title%></a></p>
    </li>
    <%
                    }
    %>
</ul>
<%
%>







<%                                }
%>
