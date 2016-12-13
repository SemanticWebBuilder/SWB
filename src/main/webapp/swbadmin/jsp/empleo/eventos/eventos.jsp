<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.*"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.util.SWBPriorityComparator"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>

<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.Resourceable"%>
<%@page import="com.infotec.swb.resources.eventcalendar.*"%>
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

    public Set<Integer> getYears(List<Event> eventos)
    {

        HashSet<Integer> getYears = new HashSet<Integer>();
        for (Event event : eventos)
        {
            if (event.getStart() != null && event.isActive())
            {
                getYears.add(event.getStart().getYear());
            }
        }
        return getYears;

    }

    public Set<Integer> getMonths(List<Event> eventos, int year)
    {

        HashSet<Integer> getYears = new HashSet<Integer>();
        Date date;
        for (Event event : eventos)
        {
            date = event.getStart();
            if (date != null && date.getYear() == year && event.isActive())
            {
                getYears.add(date.getMonth());
            }
        }
        return getYears;

    }

    public Set<Event> getEvents(List<Event> eventos, int year, int month)
    {

        HashSet<Event> getYears = new HashSet<Event>();
        Date date;
        for (Event event : eventos)
        {
            date = event.getStart();
            if (date != null && date.getYear() == year && date.getMonth() == month && event.isActive())
            {
                getYears.add(event);
            }
        }
        return getYears;

    }

    class EventSortByStartDate implements Comparator<Event>
    {

        public int compare(Event event1, Event event2)
        {
            if (event1.getStart() == null || event2.getStart() == null)
            {
                return 0;
            }
            return event1.getStart().compareTo(event2.getStart());
        }
    }
%>
<%
            String defaultFormat = "dd 'de' MMMM 'del' yyyy";
            Locale es = new Locale("es");
            SimpleDateFormat df = new SimpleDateFormat(defaultFormat, es);
            DateFormatSymbols symbols = df.getDateFormatSymbols();
            String[] months =
            {
                "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
            };
            symbols.setMonths(months);
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            Iterator<Event> itevents = Event.ClassMgr.listEvents(paramRequest.getWebPage().getWebSite());
            List<Event> events = SWBUtils.Collections.copyIterator(itevents);
            HashSet<Event> finalEvents = new HashSet<Event>();
            /*for(Event event:events){
            out.println("evento="+event+"------------<br/>");
            }*/
            Collections.sort(events, new EventSortByStartDate());
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -1);
            Date now = cal.getTime();
            if ("hist".equals(paramRequest.getAction()))
            {

                for (Event event : events)
                {
                    Date date = event.getStart();
                    if (date != null && date.before(now))
                    {
                        finalEvents.add(event);
                    }
                }
                events.clear();
                events.addAll(finalEvents);


%>


<h3 class="tituloSeccion">Eventos Anteriores</h3>
<%
                Set<Integer> years = getYears(events);
                if (years.size() == 0)
                {
%>
<p>No hay eventos anteriores</p>
<%                    }
%>

<div id="Accordion1" class="Accordion">
    <%
                    List<Integer> yearsSort = new ArrayList<Integer>();
                    yearsSort.addAll(years);
                    Collections.sort(yearsSort, new Comparator<Integer>()
                    {

                        public int compare(Integer i1, Integer i2)
                        {
                            return i2.compareTo(i1);
                        }
                    });
                    for (Integer year : yearsSort)
                    {
                        String syear = "" + (year + 1900);
    %>
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><%=syear%></div>
        <div class="AccordionPanelContent">
            <%
                                    List<Integer> monthSort = new ArrayList<Integer>();
                                    monthSort.addAll(getMonths(events, year));
                                    Collections.sort(monthSort, new Comparator<Integer>()
                                    {

                                        public int compare(Integer i1, Integer i2)
                                        {
                                            return i2.compareTo(i1);
                                        }
                                    });

                                    for (Integer month : monthSort)
                                    {
                                        String smonth = months[month];


            %>
            <div class="mesNoticias">
                <h3><%=smonth%></h3>
                <%

                                                        List<Event> eventSort = new ArrayList<Event>();
                                                        eventSort.addAll(getEvents(events, year, month));
                                                        Collections.sort(eventSort, new Comparator<Event>()
                                                        {

                                                            public int compare(Event i1, Event i2)
                                                            {
                                                                return i2.getStart().compareTo(i1.getStart());
                                                            }
                                                        });
                                                        for (Event event : eventSort)
                                                        {
                                                            if (event.getStart() != null)
                                                            {
                                                                String text = "Sin título";
                                                                if (event.getTitle() != null)
                                                                {
                                                                    text = event.getTitle();
                                                                }
                                                                String description = "Sin descripción";
                                                                if (event.getDescription() != null)
                                                                {
                                                                    description = event.getDescription();
                                                                }
                                                                Date date = event.getStart();

                                                                String dateToShow = df.format(date);
                                                                String url = event.getUrl();
                                                                String titleURL = getTitleURL(event.getDisplayTitle(paramRequest.getUser().getLanguage()));
                                                                url += "/" + titleURL;
                %>
                <div class="noticia">
                    <img src="/work/models/infotec/foro/ico_conversacion.gif" alt="Noticia INFOTEC" >
                    <h4><a href="<%=url%>"><%=text%></a></h4>
                    <p>
                        <span class="resaltado"><%=dateToShow%>.&nbsp;</span> <%=description%>
                    </p>
                </div>
                <%
                                                            }
                                                        }
                %>

            </div>
            <%                                                }
            %>


        </div>
    </div>
    <%
                    }
    %>




</div>
<script type="text/javascript">
    <!--
    var Accordion1 = new Spry.Widget.Accordion("Accordion1");
    //-->
</script>
<%
                SWBResourceURL urlHist = paramRequest.getRenderUrl();
                urlHist.setAction("act");
%>

<br/><a href="<%=urlHist%>" id="noticiasAnteriores">Ver Eventos Recientes</a>

<%                            }
            else
            {

                for (Event event : events)
                {
                    Date date = event.getStart();
                    if (date != null && event.isValid() && date.after(now))
                    {
                        finalEvents.add(event);
                    }
                }
%>
<div id="noticiasRecientes">
    <h3 class="tituloSeccion">Eventos Recientes</h3>
    <%
                    if (finalEvents.size() == 0)
                    {
    %>
    <p>No hay eventos recientes</p>
    <%              }

                    events.clear();
                    events.addAll(finalEvents);
                    Collections.sort(events, new Event.EventSortByStartDate());
                    for (Event event : events)
                    {
                        if (event.getStart() != null)
                        {
                            String text = "Sin título";
                            if (event.getTitle() != null)
                            {
                                text = event.getTitle();
                            }
                            String description = "Sin descripción";
                            if (event.getDescription() != null)
                            {
                                description = event.getDescription();
                            }
                            Date date = event.getStart();
                            String dateToShow = df.format(date);
                            String url = event.getUrl();
                            String titleURL = getTitleURL(event.getDisplayTitle(paramRequest.getUser().getLanguage()));
                            url += "/" + titleURL;
    %>
    <div class="noticia">
        <img src="/work/models/infotec/foro/ico_conversacion.gif" alt="Noticia de TICs" >
        <h4><%=text%></h4>
        <p><%=dateToShow%>.&nbsp;<%=description%>
        </p>
        <a href="<%=url%>" class="verNotaCompleta">ver evento</a>
    </div>
    <%
                        }
                    }
                    SWBResourceURL urlHist = paramRequest.getRenderUrl();
                    urlHist.setAction("hist");

    %>
    <br/><a href="<%=urlHist%>" id="noticiasAnteriores">Ver Eventos Anteriores</a>
</div>
<%


            }

%>



